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
struct TransverseCore: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .transverseCore //Change this
    
    
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
            days = [1,9,13,15,16,18,20,22,24,26,28]
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
                                                          text: "Repeat 10 time",
                                                          targetValues: [],
                                                          duration: .allDay)
                scheduleElements.append(scheduleElement)
            }
        }

        let schedule = OCKSchedule(composing: scheduleElements)
        var activity = OCKTask(id: activityType.rawValue,
                               title: "Transverse Core Strengthening",
                               carePlanID: nil, schedule: schedule)
        
        activity.instructions = "This exercise strengthens the muscles that cross from your ribs across your waist and help support you in an upright position. Stand with feet shoulder width apart and toes turned in very slightly. Hold a household object of desired weight (book, can of soup, exercise weight) directly in front of you. Keep your abdominal muscles tight and feet flat on the floor; rotate from side to side. Repeat 10 times.\n\nIf you are able to use progressively heavier balls, you will experience more benefit from this exercise. Check with your physician to see if you can/should do this."
        
        activity.groupIdentifier = "Todo's"
        activity.asset = "\(String(describing: Bundle.main.url(forResource: "transversecore_combined", withExtension: "jpg")))"
        return activity
    }
    
}

