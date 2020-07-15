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
        let store = OCKStore(name: "stanford-store")
        let manager = OCKSynchronizedStoreManager(wrapping: store)
        return manager
    }()
    
    private override init() {}

    func updateProgress(by value: Int, for date: Date) {
        let store = self.synchronizedStoreManager.store
        store.fetchAnyEvents(taskID: ActivityType.progressTrack.rawValue,
            query: OCKEventQuery(for: date), callbackQueue: .main) { (result) in
                guard let events = try? result.get() else { return }
                if events.count > 0 {
                    let event = events.first!
                    if var outcome = event.outcome {
                        if let oldValue = outcome.values.first!.integerValue {
                            outcome.values[0] = OCKOutcomeValue(Int(oldValue + value))
                        } else if let oldValue = outcome.values.last!.integerValue {
                            outcome.values[1] = OCKOutcomeValue(Int(oldValue + value))
                        }
                        store.updateAnyOutcome(outcome, callbackQueue: .main) { (finalResult) in
                            switch finalResult {
                            case .failure(let error): print(error.localizedDescription)
                            case .success(_): print("Progress Outcome updated successfully.")
                            }
                        }
                    }
                }
        }
    }
}
