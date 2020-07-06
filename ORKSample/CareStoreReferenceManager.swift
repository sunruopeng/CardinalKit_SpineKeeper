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
}
