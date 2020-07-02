//
//  PressUp.swift
//  ORKSample
//
//  Created by Aman Sinha on 11/15/17.
//  Copyright © 2017 Apple, Inc. All rights reserved.
//

import CareKit

/**
 Struct that conforms to the `Activity` protocol to define a press up
 activity.
 */
struct WallWash: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .wallWash
    
    /* Junaid Commnented
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let calendar = Calendar.autoupdatingCurrent
        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
        let startDateComps = calendar.dateComponents([.year, .month, .day], from: startDate)
        let endDate = calendar.dateComponents([.year, .month, .day], from: calendar.date(byAdding: .day, value: 28, to: startDate)!)
        
        var days: [Int] = []
        switch(UserDefaults.standard.integer(forKey: "activityScheduleIndex")) {
        case 0:
            days = [7,11,14,16,18,20,22,24,26,28]
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
        
        var occurrences = [Int](repeating: 0, count: 28)
        for day in days {
            occurrences[day-1]+=1
        }
        
        let schedule = OCKCareSchedule.monthlySchedule(withStartDate: startDateComps, occurrencesOnEachDay: occurrences as [NSNumber], endDate: endDate)
        
        // Get the localized strings to use for the activity.
        let title = "Wall Wash"
        let summary = "Repeat 10-15 times"
        let instructions = "Stand facing a wall with a cloth in hand. Squat down to 4:00 o’clock and back up to 10:00 o’clock (or as much as your range of motion allows). Hold each position for 1-2 seconds."
        
        // Create the intervention activity.
        let activity = OCKCarePlanActivity.intervention(
            withIdentifier: activityType.rawValue,//+startDate.description+endDate.description,
            groupIdentifier: "Todo's",
            title: title,
            text: summary,
            tintColor: Colors.stanfordOrange.color,
            instructions: instructions,
            imageURL: Bundle.main.url(forResource: "wallwash_combined", withExtension: "jpg"),
            schedule: schedule,
            userInfo: nil,
            optional: false
        )
        
        return activity
    }
 
 */
}

