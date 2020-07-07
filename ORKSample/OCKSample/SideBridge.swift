
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
struct SideBridge: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .sideBridge //Change this
    
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
            days = [7,12,15,17,19,21,23,25,27]
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
                                                          text: "Repeat 1-5 times",
                                                          targetValues: [],
                                                          duration: .allDay)
                scheduleElements.append(scheduleElement)
            }
        }
        
        let schedule = OCKSchedule(composing: scheduleElements)
        
        
        var activity = OCKTask(id: activityType.rawValue,
                               title: "Side Bridge",
                               carePlanID: nil, schedule: schedule)
        
        activity.instructions = "On your side with knees bent at 90 degrees, prop up on your elbow, elongate neck away from shoulder, and draw your abdominal wall in. Continue to breathe. Lift hips away from table keeping your head, shoulders and hips in a straight line. Hold for 10 seconds working towards 30 seconds. Repeat 1-5 times or to fatigue."
        
        activity.groupIdentifier = "Todo's"
        activity.asset = "sidebridge.jpg"
        return activity
    }
    
    
}




