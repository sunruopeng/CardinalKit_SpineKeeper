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
    
    override func dailyPageViewController(_ dailyPageViewController: OCKDailyPageViewController, prepare listViewController: OCKListViewController, for date: Date) {
        
        var query = OCKTaskQuery(for: date)
        query.excludesTasksWithNoEvents = true
        
        storeManager.store.fetchAnyTasks(query: query, callbackQueue: .main) { result in
            
            guard let tasks = try? result.get() else { return }
            
            tasks.forEach { task in
                let activity = task as! OCKTask
                if activity.userInfo == nil {
                    let view = SimpleInstructionsTaskViewSynchronizer()
                    let taskController = OCKInstructionsTaskController(storeManager: self.storeManager)
                    let taskCard = SimpleActivityViewController(controller: taskController, viewSynchronizer: view)
                    taskCard.controller.fetchAndObserveEvents(forTask: task, eventQuery: OCKEventQuery(for: date))
                    listViewController.appendViewController(taskCard, animated: false)
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
}

// Define a custom view synchronizer.
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
