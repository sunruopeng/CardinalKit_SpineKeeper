//
//  BackwardBending.swift
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
struct BackwardBending: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .backwardBending //Change this
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let calendar = Calendar.autoupdatingCurrent
        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
        let startDateComps = calendar.dateComponents([.year, .month, .day], from: startDate)
        let endDate = calendar.dateComponents([.year, .month, .day], from: calendar.date(byAdding: .day, value: 28, to: startDate)!)
        
        
        var days: [Int] = []
        switch(UserDefaults.standard.integer(forKey: "activityScheduleIndex")) {
        case 0:
            days = [2,8,12,15,17,19,21,23,25,27]
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
        let title = NSLocalizedString("Backward Bend", comment: "")  // Title Change
        let summary = NSLocalizedString("Repeat 10 times", comment: "")
        let instructions = "This is especially good if you’ve been sitting at a desk. Stand up, placing hands on the top of buttocks, just below the waist. Keep your feet shoulder width apart with your toes turned slightly out. Bend your head, then shoulders, then back backward, letting hips go slightly forward for balance. Slowly return to standing. Repeat 10 times"

        
        // Create the intervention activity.
        let activity = OCKCarePlanActivity.intervention(
            withIdentifier: activityType.rawValue,//+startDate.description+endDate.description,
            groupIdentifier: "Todo's",
            title: title,
            text: summary,
            tintColor: Colors.red.color,  //Change the color here
            instructions: instructions,
            imageURL: Bundle.main.url(forResource: "backbend", withExtension: "png"),
            schedule: schedule,
            userInfo: nil,
            optional: false
        )
        
        return activity
    }
}
