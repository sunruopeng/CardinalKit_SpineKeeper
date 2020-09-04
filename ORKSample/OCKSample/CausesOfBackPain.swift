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
struct CausesOfBackPain: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .causesOfBackPain
    
 
    func carePlanActivity() -> OCKTask? {
        // Create a weekly schedule.
        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)

        var days: [Int] = []
        switch(UserDefaults.standard.integer(forKey: "activityScheduleIndex")) {
        case 0:
            days = [7]
            break;
        case 1:
            days = [7]
            break;
        case 2:
            days = [7]
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
                                                          text: "Read info",
                                                          targetValues: [],
                                                          duration: .allDay)
                scheduleElements.append(scheduleElement)
            }
        }
        
        let schedule = OCKSchedule(composing: scheduleElements)
        var activity = OCKTask(id: activityType.rawValue,
                               title: "Causes of Back Pain",
                               carePlanID: nil, schedule: schedule)
        
        activity.instructions = "Back pain often develops without a cause that your doctor can identify with a test or an imaging study. Conditions commonly linked to back pain include: \u{2022} Muscle or ligament strain. Repeated heavy lifting or a sudden awkward movement can strain back muscles and spinal ligaments. If you're in poor physical condition, constant strain on your back can cause painful muscle spasms.\n\n\u{2022} Bulging or ruptured disks. Disks act as cushions between the bones (vertebrae) in your spine. The soft material inside a disk can bulge or rupture and press on a nerve. However, you can have a bulging or ruptured disk without back pain. Disk disease is often found incidentally when you have spine X-rays for some other reason.\n\n\u{2022} Arthritis. Osteoarthritis can affect the lower back. In some cases, arthritis in the spine can lead to a narrowing of the space around the spinal cord, a condition called spinal stenosis.\n\n\u{2022} Osteoporosis. Your spine's vertebrae can develop painful fractures if your bones become porous and brittle."
        
        activity.groupIdentifier = "Learn"
        return activity
    }
}




