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
                
                let taskCard = OCKChecklistTaskViewController(task: task,
                                                                   eventQuery: .init(for: date),
                                                                   storeManager: self.storeManager)
                
                listViewController.appendViewController(taskCard, animated: false)
            }
        }
    }
}
