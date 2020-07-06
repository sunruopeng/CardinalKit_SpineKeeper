//
//  Breathe.swift
//  ORKSample
//
//  Created by Muhammad Junaid Butt on 06/07/2020.
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import Foundation
import CareKit
import UIKit


struct Breathe : Task {
    
    let taskType: TaskType = .breathe
    
    func carePlanTask() -> OCKTask {
        // Create a weekly schedule.
        
        let calendar = Calendar.autoupdatingCurrent
        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
        //let startDateComps = Calendar.current.startOfDay(for:startDate)
        let endDate = Calendar.current.date(byAdding: .day, value: 28, to: startDate)
        //
        //        let startDateComps = calendar.dateComponents([.year, .month, .day], from: startDate)
        let endDateComps = calendar.dateComponents([.year, .month, .day], from: calendar.date(byAdding: .day, value: 28, to: startDate)!)
        
        let activityScheduleIndex = UserDefaults.standard.integer(forKey: "activityScheduleIndex")
        
        
        
        
        var occurrences = [Int](repeating: 0, count: 28)
        switch(UserDefaults.standard.integer(forKey: "activityScheduleIndex")) {
        case 0:
            occurrences = [Int](repeating: 1, count: 28)
            break;
        case 1:
            occurrences = [Int](repeating: 0, count: 28)
            break;
        case 2:
            occurrences = [Int](repeating: 0, count: 28)
            break;
        default:
            occurrences = [Int](repeating: 0, count: 28)
        }
        
        print(occurrences)
        
        
        //        if activityScheduleIndex == 0 {
        //
        //
        //        }
        
        
        let taskSchedule = OCKSchedule(composing: [
            OCKScheduleElement(start: startDate,
                               end: endDate,
                               interval: endDateComps,
                               text: "Repeat 10 times",
                               targetValues: [],
                               duration: .allDay)
        ])
        
        
        var task = OCKTask(id: taskType.rawValue,
                           title: "Breathe",
                           carePlanID: nil, schedule: taskSchedule)
        
        task.instructions = "\u{2022} Take a slow breath in through your nose, breathing into your lower belly (for about 4 seconds).\n\n\u{2022} Hold for 1 to 2 seconds.\n\n\u{2022}Exhale slowly through your mouth (for about 4 seconds).\n\n\u{2022} Wait a few seconds before taking another breath."
        
        task.groupIdentifier = "Todo's"
        
        
        return task
    }
    
}
