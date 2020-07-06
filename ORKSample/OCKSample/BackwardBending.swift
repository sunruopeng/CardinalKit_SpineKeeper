//
//  BackwardBending.swift
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
struct BackwardBending: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .backwardBending //Change this
    
    
    func carePlanActivity() -> OCKTask? {
        // Create a weekly schedule.
        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
        
        var days: [Int] = []
        switch(UserDefaults.standard.integer(forKey: "activityScheduleIndex")) {
        case 0:
            days = [2,8,12,15,17,19,21,23,25,27]
            break;
        case 1:
            days = []
            break;
        case 2:
            days = []
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
                                                          text: "Repeat 10 times",
                                                          targetValues: [],
                                                          duration: .allDay)
                scheduleElements.append(scheduleElement)
            }
        }
        
        let schedule = OCKSchedule(composing: scheduleElements)
        
        
        var activity = OCKTask(id: activityType.rawValue,
                               title: "Backward Bend",
                               carePlanID: nil, schedule: schedule)
        
        activity.instructions = "This is especially good if you’ve been sitting at a desk. Stand up, placing hands on the top of buttocks, just below the waist. Keep your feet shoulder width apart with your toes turned slightly out. Bend your head, then shoulders, then back backward, letting hips go slightly forward for balance. Slowly return to standing. Repeat 10 times"
        
        activity.groupIdentifier = "Todo's"
        
        
        return activity
    }
    
    
    
}
