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
        
        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
        let endDate = startDate + 27
        
            if endDate > date {
                return
            }

        var query = OCKTaskQuery(for: date)
        query.excludesTasksWithNoEvents = true
        
        storeManager.store.fetchAnyTasks(query: query, callbackQueue: .main) { result in
            
            guard let tasks = try? result.get() else { return }
            tasks.forEach { task in
                let activity = task as! OCKTask
                if activity.userInfo == nil {
                    let assessments = [ActivityType.backPain.rawValue, ActivityType.odiSurvey.rawValue,
                                       ActivityType.sixMinuteWalk.rawValue, ActivityType.startBackSurvey.rawValue,
                                       ActivityType.weight.rawValue]
                    if activity.id.oneOf(other: assessments) {
                        let view = AssessmentInstructionsTaskViewSynchronizer()
                        let taskController = OCKInstructionsTaskController(storeManager: self.storeManager)
                        let taskCard = AssessmentViewController(controller: taskController, viewSynchronizer: view)
                        taskCard.controller.fetchAndObserveEvents(forTask: task, eventQuery: OCKEventQuery(for: date))
                        listViewController.appendViewController(taskCard, animated: false)
                    } else if activity.id == ActivityType.doorwayChestStretch.rawValue {
                        let view = GridTaskViewSynchronizer()
                        let taskController = OCKGridTaskController(storeManager: self.storeManager)
                        let taskCard = GridActivityViewController(controller: taskController, viewSynchronizer: view)
                        taskCard.controller.fetchAndObserveEvents(forTask: task, eventQuery: OCKEventQuery(for: date))
                        listViewController.appendViewController(taskCard, animated: false)
                    } else if activity.id == ActivityType.stepsCount.rawValue {
                        self.saveStepsRestult(date: date, activity: activity)
                    } else {
                        let view = SimpleInstructionsTaskViewSynchronizer()
                        let taskController = OCKInstructionsTaskController(storeManager: self.storeManager)
                        let taskCard = SimpleActivityViewController(controller: taskController, viewSynchronizer: view)
                        taskCard.controller.fetchAndObserveEvents(forTask: task, eventQuery: OCKEventQuery(for: date))
                        listViewController.appendViewController(taskCard, animated: false)
                    }
                } else {
                    let view = SimpleInstructionsTaskViewSynchronizer()
                    let taskController = OCKInstructionsTaskController(storeManager: self.storeManager)
                    let taskCard = MultimediaActivityViewController(controller: taskController, viewSynchronizer: view)
                    taskCard.controller.fetchAndObserveEvents(forTask: task, eventQuery: OCKEventQuery(for: date))
                    listViewController.appendViewController(taskCard, animated: false)
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
        
        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
        let daysDifference = startDate.interval(ofComponent: .day, fromDate: date)
        
        self.fetchSteps(date: date) { (steps) in
            
            if steps <= 0 {
                return
            }
            
            let taskID =  activity.localDatabaseID!
            let value = OCKOutcomeValue(steps)
            let outcome = OCKOutcome(taskID: taskID, taskOccurrenceIndex: daysDifference, values: [value])
            
            self.storeManager.store.fetchAnyEvent(forTask: activity, occurrence: daysDifference, callbackQueue: .main) { (eventResult) in
                
                switch eventResult {
                    
                case .success(_):
                    self.storeManager.store.deleteAnyOutcome(outcome, callbackQueue: .main) { (result) in
                        
                        self.storeManager.store.addAnyOutcome(outcome, callbackQueue: .main) { (outcomeResult) in
                            switch outcomeResult {
                                
                            case .success(_):
                                print("Outcome Successfully added")
                                
                            case .failure(let error):
                                print(error.localizedDescription)
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
            }
        }  else {
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
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
}
