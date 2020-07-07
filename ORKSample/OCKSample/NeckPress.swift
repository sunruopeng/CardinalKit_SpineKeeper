
//
//  InnerThighStretch.swift
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
struct NeckPress: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .neckPress //Change this
    
    func carePlanActivity() -> OCKTask? {
        // Create a weekly schedule.
        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
        
        var days: [Int] = []
        switch(UserDefaults.standard.integer(forKey: "activityScheduleIndex")) {
        case 0:
            days = []
            break;
        case 1:
            days = []
            break;
        case 2:
            days = [6,11,14,17,19,21,23,25,27]
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
                                                          text: "Repeat 6 times",
                                                          targetValues: [],
                                                          duration: .allDay)
                scheduleElements.append(scheduleElement)
            }
        }
        
        let schedule = OCKSchedule(composing: scheduleElements)
        
        
        var activity = OCKTask(id: activityType.rawValue,
                               title: "Neck Press",
                               carePlanID: nil, schedule: schedule)
        
        activity.instructions = "This is an isometric exercise to strengthen your neck. Press your palm against your forehead, then use your neck muscles to push against your palm. Hold for ten seconds and repeat six times. Then press your palm against your temple and use your neck muscles to push against your palm, holding for ten seconds and repeating six times on each side. Then cup both hands behind your head and use your neck muscles to press back into your hands. Hold for ten seconds, and repeat six times."
        
        activity.groupIdentifier = "Todo's"
        activity.asset = "neck_combined.jpg"
        return activity
    }
}



