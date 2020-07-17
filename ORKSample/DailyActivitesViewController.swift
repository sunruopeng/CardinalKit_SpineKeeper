//
//  DailyActivitesViewController.swift
//  ORKSample
//
//  Created by Muhammad Junaid Butt on 02/07/2020.
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import CareKit

class DailyActivitesViewController: OCKDailyPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func dailyPageViewController(_ dailyPageViewController: OCKDailyPageViewController,
                                          prepare listViewController: OCKListViewController,
                                          for date: Date) {
        
        //Check whether 28 days have been passed or not
        let startDate = UserDefaults.standard.object(forKey: "startDate") as! Date
        let endDate = Calendar.current.date(byAdding: .day, value: 27, to: startDate)!
        
        if date > endDate {
            //Show dummy event with completion message
            let view = EmptyInstructionsTaskViewSynchronizer()
            let taskController = OCKInstructionsTaskController(storeManager: self.storeManager)
            let taskCard = EmptyActivityViewController(controller: taskController, viewSynchronizer: view)
            taskCard.controller.fetchAndObserveEvents(forTaskID: ActivityType.stepsCount.rawValue,
                                                      eventQuery: OCKEventQuery(for: date))
            listViewController.appendViewController(taskCard, animated: false)
            return
        }
        
        //fetch the task for the specified date
        var query = OCKTaskQuery(for: date)
        query.excludesTasksWithNoEvents = true
        
        storeManager.store.fetchAnyTasks(query: query, callbackQueue: .main) { result in
            guard let tasks = try? result.get() else { return }
            
            var todayActivityCount: Int = 0
            var progressTrackActivity: OCKTask? = nil
            
            tasks.forEach { task in
                let activity = task as! OCKTask
                if activity.userInfo == nil {
                    let assessments = [ActivityType.backPain.rawValue, ActivityType.odiSurvey.rawValue,
                                       ActivityType.sixMinuteWalk.rawValue, ActivityType.sixMinuteWalkOptional.rawValue,
                                       ActivityType.startBackSurvey.rawValue, ActivityType.weight.rawValue]
                    
                    if activity.id.oneOf(other: assessments) { //Assessment
                        if activity.impactsAdherence { todayActivityCount += 1 }
                        let view = AssessmentInstructionsTaskViewSynchronizer()
                        let taskController = OCKInstructionsTaskController(storeManager: self.storeManager)
                        let taskCard = AssessmentViewController(controller: taskController, viewSynchronizer: view)
                        taskCard.controller.fetchAndObserveEvents(forTask: task, eventQuery: OCKEventQuery(for: date))
                        listViewController.appendViewController(taskCard, animated: false)
                    } else if activity.id == ActivityType.doorwayChestStretch.rawValue { // Doorway Activity
                        if activity.impactsAdherence { todayActivityCount += 2 }
                        let view = GridTaskViewSynchronizer()
                        let taskController = OCKGridTaskController(storeManager: self.storeManager)
                        let taskCard = GridActivityViewController(controller: taskController, viewSynchronizer: view)
                        taskCard.controller.fetchAndObserveEvents(forTask: task, eventQuery: OCKEventQuery(for: date))
                        listViewController.appendViewController(taskCard, animated: false)
                    } else if activity.id == ActivityType.stepsCount.rawValue { //Dummy Activity to Store Steps Count
                        self.saveStepsRestult(date: date, activity: activity)
                    } else if activity.id == ActivityType.progressTrack.rawValue {
                        //Dummy Activity to Store Daily Progress
                        progressTrackActivity = activity
                    } else { //Simple activity
                        if activity.impactsAdherence { todayActivityCount += 1 }
                        let view = SimpleInstructionsTaskViewSynchronizer()
                        let taskController = OCKInstructionsTaskController(storeManager: self.storeManager)
                        let taskCard = SimpleActivityViewController(controller: taskController, viewSynchronizer: view)
                        taskCard.controller.fetchAndObserveEvents(forTask: task, eventQuery: OCKEventQuery(for: date))
                        listViewController.appendViewController(taskCard, animated: false)
                    }
                } else { //Multimedia Activity
                    if activity.impactsAdherence { todayActivityCount += 1 }
                    let view = SimpleInstructionsTaskViewSynchronizer()
                    let taskController = OCKInstructionsTaskController(storeManager: self.storeManager)
                    let taskCard = MultimediaActivityViewController(controller: taskController, viewSynchronizer: view)
                    taskCard.controller.fetchAndObserveEvents(forTask: task, eventQuery: OCKEventQuery(for: date))
                    listViewController.appendViewController(taskCard, animated: false)
                }
            }
            
            //Create the progress outcome in the CareKit datastore
            if let activity = progressTrackActivity {
                let occurrence = startDate.daysTo(date)
                self.storeManager.store.fetchAnyEvent(forTask: activity, occurrence: occurrence, callbackQueue: .main) { (result) in
                    switch result {
                    case .failure(let error): print(error.localizedDescription)
                    case .success(let event):
                        if event.outcome == nil {
                            let values = [OCKOutcomeValue("total:\(todayActivityCount)"), OCKOutcomeValue(Int(0))]
                            let outcome = OCKOutcome(taskID: activity.localDatabaseID!,
                                                     taskOccurrenceIndex: occurrence, values: values)
                            self.storeManager.store.addAnyOutcome(outcome, callbackQueue: .main) { (finalResult) in
                                switch finalResult {
                                case .failure(let error): print(error.localizedDescription)
                                case .success(_): print("Progress Outcome Created Successfully.")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fetchSteps(date: Date, completion: @escaping (_ dailySteps: Int) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.stepsAuthorized() {
            appDelegate.getSingleDaySteps(date: date) { stepcount in
                completion(Int(stepcount))
            }
        } else {
            completion(0)
        }
    }
    
    func saveStepsRestult(date: Date, activity: OCKTask) {
        let startDate = UserDefaults.standard.object(forKey: "startDate") as! Date
        let daysDifference = startDate.daysTo(date)
        
        self.fetchSteps(date: date) { (steps) in
            
            if steps <= 0 {
                return
            }
            
            let taskID =  activity.localDatabaseID!
            let value = OCKOutcomeValue(steps)
            let outcome = OCKOutcome(taskID: taskID, taskOccurrenceIndex: daysDifference, values: [value])
            
            self.storeManager.store.fetchAnyEvent(forTask: activity, occurrence: daysDifference, callbackQueue: .main) { (eventResult) in
                switch eventResult {
                case .success(let event):
                    if event.outcome == nil {
                        self.storeManager.store.addAnyOutcome(outcome, callbackQueue: .main) { (outcomeResult) in
                            switch outcomeResult {
                            case .success(_):
                                print("Outcome Successfully added")
                                
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                        
                    } else {
                        self.storeManager.store.deleteAnyOutcome(event.outcome!, callbackQueue: .main) { (result) in
                            switch result {
                            case .success(_):
                                print("Successfully deleted")
                            
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                                                        
                            self.storeManager.store.addAnyOutcome(outcome, callbackQueue: .main) { (outcomeResult) in
                                switch outcomeResult {
                                case .success(_):
                                    print("Outcome Successfully added")
                                    
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// Define a custom view synchronizer for empty instruction activity
class EmptyInstructionsTaskViewSynchronizer: OCKInstructionsTaskViewSynchronizer {
    
    override func makeView() -> OCKInstructionsTaskView {
        let view = super.makeView()
        return view
    }
    
    override func updateView(_ view: OCKInstructionsTaskView, context: OCKSynchronizationContext<OCKTaskEvents?>) {
        super.updateView(view, context: context)
        // Update the view when the data changes in the store here...
        view.headerView.titleLabel.text = "Well Done!"
        view.headerView.detailLabel.text = "28 Days of survey has been completed."
        view.headerView.detailDisclosureImage?.image = nil
        view.instructionsLabel.text = "Thank you for participating in Standford SpineKeeper study. We appreciate your time & efforts."
        view.completionButton.isHidden = true
    }
}

class EmptyActivityViewController: OCKInstructionsTaskViewController {
    //This method is called when the user taps the card for detail view
    override func didSelectTaskView(_ taskView: UIView & OCKTaskDisplayable, eventIndexPath: IndexPath) {
        return
    }
}

// Define a custom view synchronizer for simple instructions activities
class SimpleInstructionsTaskViewSynchronizer: OCKInstructionsTaskViewSynchronizer {
    
    override func makeView() -> OCKInstructionsTaskView {
        let view = super.makeView()
        return view
    }
    
    override func updateView(_ view: OCKInstructionsTaskView, context: OCKSynchronizationContext<OCKTaskEvents?>) {
        super.updateView(view, context: context)
        // Update the view when the data changes in the store here...
        if let event = context.viewModel?.firstEvent {
            let element = event.scheduleEvent.element
            view.headerView.titleLabel.text = event.task.title
            view.headerView.detailLabel.text = element.text
            view.instructionsLabel.text = ""
        }
    }
}

// Define a custom view synchronizer for simple grid activities
class GridTaskViewSynchronizer: OCKGridTaskViewSynchronizer {
    
    override func makeView() -> OCKGridTaskView {
        let view = super.makeView()
        return view
    }
    
    override func updateView(_ view: OCKGridTaskView, context: OCKSynchronizationContext<OCKTaskEvents?>) {
        super.updateView(view, context: context)
        // Update the view when the data changes in the store here...
        if let event = context.viewModel?.firstEvent {
            let element = event.scheduleEvent.element
            view.headerView.titleLabel.text = event.task.title
            view.headerView.detailLabel.text = element.text
            view.instructionsLabel.text = ""
        }
    }
}

// Define a custom view synchronizer for simple instructions activities
class AssessmentInstructionsTaskViewSynchronizer: OCKInstructionsTaskViewSynchronizer {
    
    override func makeView() -> OCKInstructionsTaskView {
        let view = super.makeView()
        view.headerView.detailDisclosureImage?.image = nil
        view.completionButton.label.text = "Start Assessment"
        return view
    }
    
    override func updateView(_ view: OCKInstructionsTaskView, context: OCKSynchronizationContext<OCKTaskEvents?>) {
        super.updateView(view, context: context)
        
        // Update the view when the data changes in the store here...
        guard let event = context.viewModel?.firstEvent else { return }
        let element = event.scheduleEvent.element
        view.headerView.titleLabel.text = event.task.title
        view.headerView.detailLabel.text = element.text
        view.instructionsLabel.text = ""
        
        //Check for 6-min daily optional activity
        if event.task.impactsAdherence == false {
            view.instructionsLabel.text = "This assessment is optional for today."
            view.completionButton.tintColor = Colors.blue.color
        }
        
        // Check if an answer exists or not and set the button accordingly
        if let values = context.viewModel?.firstEvent?.outcome?.values {
            //Show the values for Back Pain Assessment
            if event.task.id == ActivityType.backPain.rawValue && values.count == 2 {
                view.completionButton.isSelected = true
                
                var averagePain: Int = 0
                var maxPain: Int = 0
                var outcomeValue = values[0].stringValue ?? ""
                if outcomeValue.contains("average:") {
                    averagePain = Int(outcomeValue.components(separatedBy: ":").last!)!
                } else if outcomeValue.contains("max:") {
                    maxPain = Int(outcomeValue.components(separatedBy: ":").last!)!
                }
                
                outcomeValue = values[1].stringValue ?? ""
                if outcomeValue.contains("average:") {
                    averagePain = Int(outcomeValue.components(separatedBy: ":").last!)!
                } else if outcomeValue.contains("max:") {
                    maxPain = Int(outcomeValue.components(separatedBy: ":").last!)!
                }
                
                view.instructionsLabel.text = "Average: \(averagePain)\nMax: \(maxPain)"
            } else if event.task.id == ActivityType.sixMinuteWalk.rawValue ||
                event.task.id == ActivityType.sixMinuteWalkOptional.rawValue {
                if values.count == 2 {
                    view.completionButton.isSelected = true
                    
                    var steps: Int = 0
                    var distance: Double = 0
                    var outcomeValue = values[0].stringValue ?? ""
                    if outcomeValue.contains("steps:") {
                        steps = Int(outcomeValue.components(separatedBy: ":").last!)!
                    } else if outcomeValue.contains("distance:") {
                        distance = Double(outcomeValue.components(separatedBy: ":").last!)!
                    }
                    
                    outcomeValue = values[1].stringValue ?? ""
                    if outcomeValue.contains("distance:") {
                        distance = Double(outcomeValue.components(separatedBy: ":").last!)!
                    } else if outcomeValue.contains("steps:") {
                        steps = Int(outcomeValue.components(separatedBy: ":").last!)!
                    }
                    
                    view.instructionsLabel.text = "Steps: \(steps)\nDistance: \(String( format: "%.2f", distance))m"
                }
            }
        } else {
            view.completionButton.isSelected = false
            view.completionButton.label.text = "Start Assessment"
        }
    }
}

extension Equatable {
    func oneOf(other: [Self]) -> Bool {
        return other.contains(self)
    }
}

extension Date {
    func daysTo(_ date: Date) -> Int {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        guard let days = components.day else { return 0 }
        return days
    }
}
