//
//  CareStoreReferenceManager.swift
//  ORKSample
//
//  Created by Muhammad Junaid Butt on 02/07/2020.
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import Foundation
import CareKit

// Singleton wrapper to hold a reference to OCKSynchronizedStoreManager and task identifiers
final class CareStoreReferenceManager {
    
    enum TaskIdentifiers: String, CaseIterable {
        case coughingEpisodes
        case flueEpisodes
    }
    
    
    static let shared = CareStoreReferenceManager()
    
    // Manages synchronization of a CoreData store
    lazy var synchronizedStoreManager: OCKSynchronizedStoreManager = {
        let store = OCKStore(name: "Activity")
        store.populateDailyTasks()
        let manager = OCKSynchronizedStoreManager(wrapping: store)
        return manager
    }()
    
    private init() {}
}



extension OCKStore {

    // Adds tasks and contacts into the store
    func populateDailyTasks() {

        let thisMorning = Calendar.current.startOfDay(for: Date())
        guard let beforeBreakfast = Calendar.current.date(byAdding: .day, value: 6, to: thisMorning) else {
            return assertionFailure("Could not create time 8AM this morning")
        }

        let coughingSchedule = OCKSchedule(composing: [
            OCKScheduleElement(start: beforeBreakfast,
                               end: nil,
                               interval: DateComponents(day: 1),
                               text: "Anytime throughout the day",
                               targetValues: [],
                               duration: .allDay)
        ])

        var coughingTask = OCKTask(id: CareStoreReferenceManager.TaskIdentifiers.coughingEpisodes.rawValue,
                                   title: "Track coughing",
                                   carePlanID: nil, schedule: coughingSchedule)
        
        
        let flueSchedule = OCKSchedule(composing: [
            OCKScheduleElement(start: beforeBreakfast,
                               end: nil,
                               interval: DateComponents(day: 2),
                               text: "Anytime throughout the day",
                               targetValues: [],
                               duration: .allDay)
        ])

        var flueTask = OCKTask(id: CareStoreReferenceManager.TaskIdentifiers.flueEpisodes.rawValue,
                                   title: "Track Flue",
                                   carePlanID: nil, schedule: flueSchedule)
        
        coughingTask.instructions = "If you have coughed for a duration of 1 minute or more please log it here."
        coughingTask.impactsAdherence = false
        flueTask.instructions = "If you have Flue for a duration of half day or more please log it here."
        addTask(coughingTask)
        addTask(flueTask)
    }
}
