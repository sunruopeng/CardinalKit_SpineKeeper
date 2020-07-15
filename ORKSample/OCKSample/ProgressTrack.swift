//
//  ProgressTrack.swift
//  ORKSample
//
//  Created by Muhammad Junaid Butt on 15/07/2020.
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import CareKit

struct ProgressTrack: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .progressTrack
    
    func carePlanActivity() -> OCKTask? {
        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
        let caldendar = Calendar.current
        let startOfDay = caldendar.startOfDay(for: startDate)
        
        //Create Full Monthly Schedule
        var schedules : [OCKSchedule] = []
        for index in 0..<28 {
            let scheduleStartDate = caldendar.date(byAdding: .day, value: index, to: startOfDay)!
            let scheduleElement =  OCKScheduleElement(start: scheduleStartDate, end: nil,
                                                      interval: DateComponents(day: 28),
                                                      text: "",
                                                      targetValues: [],
                                                      duration: .allDay)
            
            schedules.append(OCKSchedule(composing: [scheduleElement]))
        }
        
        let taskSchedule = OCKSchedule(composing: schedules)
        var task = OCKTask(id: activityType.rawValue,
                           title: "Daily Progress",
                           carePlanID: nil, schedule: taskSchedule)
        
        task.instructions = "Daily Progress"
        task.groupIdentifier = "Todo's"
        task.impactsAdherence = false
        return task
    }
    
}
