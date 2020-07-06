//
//  Task.swift
//  ORKSample
//
//  Created by Muhammad Junaid Butt on 06/07/2020.
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import Foundation
import CareKit



enum TaskType : String {
    
    case pressUp
    case breathe
}


protocol Task {
    var taskType: TaskType { get }
    func carePlanTask() -> OCKTask
}
