//
//  TasksData.swift
//  ORKSample
//
//  Created by Muhammad Junaid Butt on 06/07/2020.
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import Foundation
import CareKit


class TasksData : NSObject {
    
    let tasks: [Task] = [
        PressUp(),Breathe()
    ]
    
    
    required init(carePlanStore: OCKStore) {
           super.init()
           
           //self._clearStore(store: carePlanStore)
           // Populate the store with the sample activities.
           for sampletask in self.tasks {
            let carePlantask = sampletask.carePlanTask()
            
            carePlanStore.addTask(carePlantask) { result in
                switch result {
                case .failure(let error): print("Error: \(error.localizedDescription)")
                case .success: print("Successfully saved a new task!")
                }
            }
           }
       }
}
