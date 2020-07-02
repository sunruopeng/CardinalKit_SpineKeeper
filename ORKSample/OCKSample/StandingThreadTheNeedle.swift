//
//  StandingThreadTheNeedle.swift
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
struct StandingThreadTheNeedle: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .standingThreadTheNeedle //Change this
    
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
            days = [5,10,13,16,18,20,22,24,26,28]
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
        
        // Get the localized strings to use for the activity. ### Change the instructions
        let title = NSLocalizedString("Thread The Needle", comment: "")  // Title Change ###
        let summary = NSLocalizedString("Repeat 10-15 times", comment: "") // CHANGE COMMENT AND INSTRUCTIONS BELOW
        let instructions = "Stand with one hand on the wall and the opposite  leg on the ground, abdominals tight, back straight. Most of your weight should be through the arm on the wall. Reach under your arm pit area (3:00 o’clock) and reach out and up (10:00 o’clock). Keep your weight-bearing shoulder blade down. Repeat 10-15 times, holding 5 seconds. Switch sides and repeat."

        
        // Create the intervention activity.
        let activity = OCKCarePlanActivity.intervention(
            withIdentifier: activityType.rawValue,//+startDate.description+endDate.description,
            groupIdentifier: "Todo's",
            title: title,
            text: summary,
            tintColor: Colors.purple.color,  //Change the color here ###
            instructions: instructions,
            imageURL: Bundle.main.url(forResource: "standingthreadtheneedle_combined", withExtension: "jpg"),
            schedule: schedule,
            userInfo: nil,
            optional: false
        )
        
        return activity
    }
 
 */
}
