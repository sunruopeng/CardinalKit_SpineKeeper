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
struct AbdominalExercise: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .abdominalExercise //Change this
    
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
            days = [4,10,14,16,18,20,22,24,26,28]
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
                                                          text: "Repeat 10-15 times",
                                                          targetValues: [],
                                                          duration: .allDay)
                scheduleElements.append(scheduleElement)
            }
        }
        
        
        let taskSchedule = OCKSchedule(composing: scheduleElements)
        
        
        var activity = OCKTask(id: activityType.rawValue,
                           title: "Abdominal Crunch",
                           carePlanID: nil, schedule: taskSchedule)
        
        activity.instructions = "You can stretch and strengthen the low back muscles that help you stand and lift. Stand with your feet shoulder width apart, about 18” in front of a wall (with your back to the wall).  Hold a household object of desired weight (book, can of soup, exercise weight) directly in front of you. Tighten your abdominal muscles, then reach through your legs to touch the wall, keeping hips and knees bent. Use your hips to push your body back to a standing position, then extend your arms and reach over your head and slightly backward. Repeat 10 times."
        
        activity.groupIdentifier = "Todo's"
        activity.asset = "\(String(describing: Bundle.main.url(forResource: "abdominalexercise", withExtension: "jpg")))"
        return activity
    }
    
}
