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
struct Diary: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .diary
    
    
    func carePlanActivity() -> OCKTask? {
        // Create a weekly schedule.
        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
        
        var days: [Int] = []
        switch(UserDefaults.standard.integer(forKey: "activityScheduleIndex")) {
        case 0:
            days = []
            break;
        case 1:
            days = [13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28]
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
                                                          text: "Log an entry",
                                                          targetValues: [],
                                                          duration: .allDay)
                scheduleElements.append(scheduleElement)
            }
        }
        
        let schedule = OCKSchedule(composing: scheduleElements)
        var activity = OCKTask(id: activityType.rawValue,
                               title: "Sleep Diary",
                               carePlanID: nil, schedule: schedule)
        
        activity.instructions = "One of the best ways you can tell whether you are getting enough good-quality sleep, and whether you have signs of a sleep disorder, is by keeping a sleep diary.  Use this diary to record the quality and quantity of your sleep; your use of medications, alcohol, and caffeinated beverages; your exercise patterns; and how sleepy you feel during the day. After a week or so, look over this information to see how many hours of sleep or nighttime awakenings one night are linked to your being tired the next day. This information will give you a sense of how much uninterrupted sleep you need to avoid daytime sleepiness. You also can use the diary to see some of the patterns or practices that may keep you from getting a good night’s sleep.\n\n\u{2022}You can keep your own diary or use the Journal feature in the SYmptom Tracker tab."
        
        activity.groupIdentifier = "Todo's"
        return activity
    }
    
}

