//
//  SixMinuteWalkOptional.swift
//  ORKSample
//
//  Created by Muhammad Junaid Butt on 17/07/2020.
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import CareKit

struct SixMinuteWalkOptional: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .sixMinuteWalkOptional
    
    func carePlanActivity() -> OCKTask? {
        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
        
        let days = [1,10,19]
        var occurrences = [Int](repeating: 0, count: 28)
        for day in days {
            occurrences[day-1]+=1
        }
        
        var schedules : [OCKSchedule] = []
        let caldendar = Calendar.current
        let startOfDay = Calendar.current.startOfDay(for: startDate)
                
        for index in 0..<occurrences.count {
            if occurrences[index] == 0 {
                let scheduleStartDate = caldendar.date(byAdding: .day, value: index, to: startOfDay)!
                let scheduleElement =  OCKScheduleElement(start: scheduleStartDate, end: nil,
                                                          interval: DateComponents(day: 28),
                                                          text: "Perform a 6-minute walk",
                                                          targetValues: [],
                                                          duration: .allDay)
                
                let subSchedule = OCKSchedule(composing: [scheduleElement])
                schedules.append(subSchedule)
            }
        }
        
        let schedule = OCKSchedule(composing: schedules)
        var activity = OCKTask(id: activityType.rawValue,
                               title: "6-Minute Walk Test",
                               carePlanID: nil, schedule: schedule)
        activity.impactsAdherence = false
        activity.groupIdentifier = "Todo's"
        return activity
    }
}
