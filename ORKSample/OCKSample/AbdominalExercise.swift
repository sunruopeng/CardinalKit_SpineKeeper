//
//  InnerThighStretch.swift
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
struct AbdominalExercise: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .abdominalExercise //Change this
    
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
            days = []
            break;
        case 2:
            days = [4,10,14,16,18,20,22,24,26,28]
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
        let title = NSLocalizedString("Abdominal Crunch", comment: "")  // Title Change ###
        let summary = NSLocalizedString("Repeat 10-15 times", comment: "") // CHANGE COMMENT AND INSTRUCTIONS BELOW
        let instructions = "Lay on your back with both knees bent. Draw abdominal wall in. Maintaining abdominal wall drawn in, extend one leg (if your abdominal wall lifts up or your back arches, your leg is too close to the floor). Return leg and extend other leg. Repeat to fatigue or about 10-15 repetitions at a slow and controlled pace."
        
        // Create the intervention activity.
        let activity = OCKCarePlanActivity.intervention(
            withIdentifier: activityType.rawValue,//+startDate.description+endDate.description,
            groupIdentifier: "Todo's",
            title: title,
            text: summary,
            tintColor: Colors.blue.color,  //Change the color here ###
            instructions: instructions,
            imageURL: Bundle.main.url(forResource: "abdominalexercise", withExtension: "jpg"),
            schedule: schedule,
            userInfo: nil,
            optional: false
        )
        
        return activity
    }
}



