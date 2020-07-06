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
struct InnerThighStretch: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .innerThighStretch //Change this
    
    
    func carePlanActivity() -> OCKTask? {
        // Create a weekly schedule.
        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
        
        var days: [Int] = []
        switch(UserDefaults.standard.integer(forKey: "activityScheduleIndex")) {
        case 0:
            days = [4,9,13,15,17,19,21,23,25,27]
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
                                                          text: "Hold for 60 seconds",
                                                          targetValues: [],
                                                          duration: .allDay)
                scheduleElements.append(scheduleElement)
            }
        }
        
        let schedule = OCKSchedule(composing: scheduleElements)
        
        
        var activity = OCKTask(id: activityType.rawValue,
                               title: "Inner Thigh Stretch",
                               carePlanID: nil, schedule: schedule)
        
        activity.instructions = "Turn your body facing forward. Place your leg onto a chair and try to keep your leg straight. Adjust the height of the chair as necessary to allow you to maintain a straight leg. Lean into the leg on the chair to feel a stretch in the inner thigh area. Hold for 60 seconds"
        
        activity.groupIdentifier = "Todo's"
        activity.asset = "\(String(describing: Bundle.main.url(forResource: "innerthighstretch", withExtension: "jpg")))"
        
        return activity
    }
    
    
}
