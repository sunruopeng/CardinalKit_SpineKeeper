//
//  StepsCount.swift
//  ORKSample
//
//  Created by Muhammad Junaid Butt on 13/07/2020.
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import CareKit
import UIKit



struct StepsCount: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .stepsCount
    
    func carePlanActivity() -> OCKTask? {
        // Create a weekly schedule.
        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
        let caldendar = Calendar.current
        
        //Create Full Monthly Schedule
        var scheduleElements : [OCKScheduleElement] = []
        for index in 0..<28 {
            
            let startOfDay = Calendar.current.startOfDay(for: startDate)
            let scheduleStartDate = caldendar.date(byAdding: .day, value: index, to: startOfDay)!
            
            let scheduleElement =  OCKScheduleElement(start: scheduleStartDate, end: nil,
                                                      interval: DateComponents(day: 28),
                                                      text: "",
                                                      targetValues: [],
                                                      duration: .allDay)
            scheduleElements.append(scheduleElement)
            
        }
        
        let taskSchedule = OCKSchedule(composing: scheduleElements)
        var task = OCKTask(id: activityType.rawValue,
                           title: "Steps Count",
                           carePlanID: nil, schedule: taskSchedule)
        
        task.instructions = "Steps Count"
        task.groupIdentifier = "Todo's"
        task.impactsAdherence = false
        
        return task
    }
    
}
