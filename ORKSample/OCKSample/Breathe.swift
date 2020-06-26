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
struct Breathe: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .breathe
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let calendar = Calendar.autoupdatingCurrent
        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
        let startDateComps = calendar.dateComponents([.year, .month, .day], from: startDate)
        let endDate = calendar.dateComponents([.year, .month, .day], from: calendar.date(byAdding: .day, value: 28, to: startDate)!)
        
        var occurrences = [Int](repeating: 0, count: 28)
        switch(UserDefaults.standard.integer(forKey: "activityScheduleIndex")) {
        case 0:
            occurrences = [Int](repeating: 1, count: 28)
            break;
        case 1:
            occurrences = [Int](repeating: 0, count: 28)
            break;
        case 2:
            occurrences = [Int](repeating: 0, count: 28)
            break;
        default:
            occurrences = [Int](repeating: 0, count: 28)
        }
        
        let schedule = OCKCareSchedule.monthlySchedule(withStartDate: startDateComps, occurrencesOnEachDay: occurrences as [NSNumber], endDate: endDate)
        
        // Get the localized strings to use for the activity.
        let title = NSLocalizedString("Breathe", comment: "")
        let summary = NSLocalizedString("Repeat 5 times", comment: "")
        let instructions = "\u{2022} Take a slow breath in through your nose, breathing into your lower belly (for about 4 seconds).\n\n\u{2022} Hold for 1 to 2 seconds.\n\n\u{2022}Exhale slowly through your mouth (for about 4 seconds).\n\n\u{2022} Wait a few seconds before taking another breath."
        
        // Create the intervention activity.
        let activity = OCKCarePlanActivity.intervention(
            withIdentifier: activityType.rawValue,//+startDate.description+endDate.description,
            groupIdentifier: "Todo's",
            title: title,
            text: summary,
            tintColor: Colors.green.color,
            instructions: instructions,
            imageURL: nil,
            schedule: schedule,
            userInfo: nil,
            optional: false
        )
        
        return activity
    }
}

