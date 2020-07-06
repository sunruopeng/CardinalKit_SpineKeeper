//
//  CareStoreReferenceManager.swift
//  ORKSample
//
//  Created by Muhammad Junaid Butt on 02/07/2020.
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import Foundation
import UIKit
import CareKit

// Singleton wrapper to hold a reference to OCKSynchronizedStoreManager and task identifiers
class CareStoreReferenceManager : NSObject {
    
    static let shared = CareStoreReferenceManager()
    
    // Manages synchronization of a CoreData store
    lazy var synchronizedStoreManager: OCKSynchronizedStoreManager = {
        let store = OCKStore(name: "Daily Activity")
        //        store.populateDailyTasks()
        let manager = OCKSynchronizedStoreManager(wrapping: store)
        return manager
    }()
    
    
    
    private override init() {
        

    }
}



//extension OCKStore {
//
//    // Adds tasks and contacts into the store
//    func populateDailyTasks() {
//
//        let thisMorning = Calendar.current.startOfDay(for: Date())
//        guard let beforeBreakfast = Calendar.current.date(byAdding: .day, value: 0, to: thisMorning) else {
//            return assertionFailure("Could not create time 8AM this morning")
//        }
//
//        let excerciseSchedule = OCKSchedule(composing: [
//            OCKScheduleElement(start: beforeBreakfast,
//                               end: nil,
//                               interval: DateComponents(day: 1),
//                               text: "Read info",
//                               targetValues: [],
//                               duration: .allDay)
//        ])
//
//        var excerciseTask = OCKTask(id: CareStoreReferenceManager.TaskIdentifiers.exercisesTypes.rawValue,
//                                   title: "Types of Excercise",
//                                   carePlanID: nil, schedule: excerciseSchedule)
//
//
//        let strengtheningSchedule = OCKSchedule(composing: [
//            OCKScheduleElement(start: beforeBreakfast,
//                               end: nil,
//                               interval: DateComponents(day: 2),
//                               text: "Repeat 10 times",
//                               targetValues: [],
//                               duration: .allDay)
//        ])
//
//        var strengtheningTask = OCKTask(id: CareStoreReferenceManager.TaskIdentifiers.strengthening.rawValue,
//                                   title: "Sagittal Core Strengthening",
//                                   carePlanID: nil, schedule: strengtheningSchedule)
//
//        excerciseTask.instructions = "Read Info."
//        //excerciseTask.impactsAdherence = false
//        excerciseTask.groupIdentifier = "Learn"
//        excerciseTask.userInfo = ["image":"exercisetype.png"]
//
//        strengtheningTask.instructions = "You can stretch and strengthen the low back muscles that help you stand and lift. Stand with your feet shoulder width apart, about 18” in front of a wall (with your back to the wall).  Hold a household object of desired weight (book, can of soup, exercise weight) directly in front of you. Tighten your abdominal muscles, then reach through your legs to touch the wall, keeping hips and knees bent. Use your hips to push your body back to a standing position, then extend your arms and reach over your head and slightly backward. Repeat 10 times."
//
//        strengtheningTask.groupIdentifier = "Todo's"
//        addTask(excerciseTask)
//        addTask(strengtheningTask)
//    }
//}
