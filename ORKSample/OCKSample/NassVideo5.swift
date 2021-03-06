//
//  PressUp.swift
//  ORKSample
//
//  Created by Aman Sinha on 11/15/17.
//  Copyright © 2017 Apple, Inc. All rights reserved.
//

import CareKit
import UIKit

/**
 Struct that conforms to the `Activity` protocol to define a press up
 activity.
 */
struct NassVideo5: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .nassVideo5
    
    
    func carePlanActivity() -> OCKTask? {
        // Create a weekly schedule.
        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
        
        var days: [Int] = []
        switch(UserDefaults.standard.integer(forKey: "activityScheduleIndex")) {
        case 0:
            days = [24]
            break;
        case 1:
            days = [23]
            break;
        case 2:
            days = [23]
            break;
        default:
            days = []
        }
        
        if days.count == 0 {
            return nil
        }
        
        var occurrences = [Int](repeating: 0, count: 28)
        for day in days {
            occurrences[day-1]+=1
        }
        
        var scheduleElements : [OCKScheduleElement] = []
        for index in 0..<occurrences.count {
            
            if occurrences[index] == 1 {
                let caldendar = Calendar.current
                let startOfDay = Calendar.current.startOfDay(for: startDate)
                let scheduleStartDate = caldendar.date(byAdding: .day, value: index, to: startOfDay)!
                
                let scheduleElement =  OCKScheduleElement(start: scheduleStartDate, end: nil,
                                                          interval: DateComponents(day: 28),
                                                          text: "Watch video",
                                                          targetValues: [],
                                                          duration: .allDay)
                scheduleElements.append(scheduleElement)
            }
        }
        
        
        let schedule = OCKSchedule(composing: scheduleElements)
        var activity = OCKTask(id: activityType.rawValue,
                               title: "Body Mechanics",
                               carePlanID: nil, schedule: schedule)
        
        activity.instructions = "\u{2022} Take a slow breath in through your nose, breathing into your lower belly (for about 4 seconds).\n\n\u{2022} Hold for 1 to 2 seconds.\n\n\u{2022} Exhale slowly through your mouth (for about 4 seconds).\n\n\u{2022} Wait a few seconds before taking another breath."
        
        activity.groupIdentifier = "Learn"
        activity.userInfo = ["hasTask":"video","video":"nass5"]
        return activity
    }
}


