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
struct Diary: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .diary
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let calendar = Calendar.autoupdatingCurrent
        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
        let startDateComps = calendar.dateComponents([.year, .month, .day], from: startDate)
        let endDate = calendar.dateComponents([.year, .month, .day], from: calendar.date(byAdding: .day, value: 28, to: startDate)!)
        
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
        
        var occurrences = [Int](repeating: 0, count: 28)
        for day in days {
            occurrences[day-1]+=1
        }
        
        let schedule = OCKCareSchedule.monthlySchedule(withStartDate: startDateComps, occurrencesOnEachDay: occurrences as [NSNumber], endDate: endDate)
        
        // Get the localized strings to use for the activity.
        let title = "Sleep Diary"
        let summary = "Log an entry"
        let instructions = "One of the best ways you can tell whether you are getting enough good-quality sleep, and whether you have signs of a sleep disorder, is by keeping a sleep diary.  Use this diary to record the quality and quantity of your sleep; your use of medications, alcohol, and caffeinated beverages; your exercise patterns; and how sleepy you feel during the day. After a week or so, look over this information to see how many hours of sleep or nighttime awakenings one night are linked to your being tired the next day. This information will give you a sense of how much uninterrupted sleep you need to avoid daytime sleepiness. You also can use the diary to see some of the patterns or practices that may keep you from getting a good night’s sleep.\n\n\u{2022}You can keep your own diary or use the Journal feature in the SYmptom Tracker tab."
        
        // Create the intervention activity.
        let activity = OCKCarePlanActivity.intervention(
            withIdentifier: activityType.rawValue,//+startDate.description+endDate.description,
            groupIdentifier: "Todo's",
            title: title,
            text: summary,
            tintColor: Colors.stanfordLightTan.color,
            instructions: instructions,
            imageURL: nil, //Bundle.main.url(forResource: "brace", withExtension: "png"),
            schedule: schedule,
            userInfo: nil,
            optional: false
        )
        
        return activity
    }
}

