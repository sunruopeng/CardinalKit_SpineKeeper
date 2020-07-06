//
//  PressUp.swift
//  ORKSample
//
//  Created by Aman Sinha on 11/15/17.
//  Copyright © 2017 Apple, Inc. All rights reserved.
//

import Foundation
import CareKit
import UIKit

/**
 Struct that conforms to the `Activity` protocol to define a press up
 activity.
 */
struct Breathe: Activity {
    
    // MARK: Activity
    
    let activityType: ActivityType = .breathe
    
    func carePlanActivity() -> OCKTask? {
        // Create a weekly schedule.
        
        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
        
        
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
        
        
        if occurrences[0] == 0 {
            return nil
        }
        
        //Create Full Monthly Schedule
        var scheduleElements : [OCKScheduleElement] = []
        for index in 0..<occurrences.count {
            
            if occurrences[index] == 1 {
                let caldendar = Calendar.current
                let startOfDay = Calendar.current.startOfDay(for: startDate)
                let scheduleStartDate = caldendar.date(byAdding: .day, value: index, to: startOfDay)!
                
                let scheduleElement =  OCKScheduleElement(start: scheduleStartDate, end: nil,
                                                          interval: DateComponents(day: 28),
                                                          text: "Repeat 10 times",
                                                          targetValues: [],
                                                          duration: .allDay)
                scheduleElements.append(scheduleElement)
            }
        }
        
        let taskSchedule = OCKSchedule(composing: scheduleElements)
        var task = OCKTask(id: activityType.rawValue,
                           title: "Breathe",
                           carePlanID: nil, schedule: taskSchedule)
        
        task.instructions = "\u{2022} Take a slow breath in through your nose, breathing into your lower belly (for about 4 seconds).\n\n\u{2022} Hold for 1 to 2 seconds.\n\n\u{2022}Exhale slowly through your mouth (for about 4 seconds).\n\n\u{2022} Wait a few seconds before taking another breath."
        
        task.groupIdentifier = "Todo's"
        return task
    }
    
}
