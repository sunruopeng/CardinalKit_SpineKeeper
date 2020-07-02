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
struct PressUp: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .pressUp
    
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
            days = [1,8,12,14,15,17,19,21,23,25,27]
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
        let title = NSLocalizedString("Press Up", comment: "")
        let summary = NSLocalizedString("Repeat 10 times", comment: "")
        let instructions = NSLocalizedString("Lie on your stomach, placing hands on the ground under your shoulders. Push up, attempting to straighten your elbows, so your back arches gently while your hips and legs remain on the ground. Don’t use your back muscles; your arms should support you, so you feel the stretch in your chest and stomach. Hold, then slowly lower yourself.", comment: "")
        
        // Create the intervention activity.
        let activity = OCKCarePlanActivity.intervention(
            withIdentifier: activityType.rawValue,//+startDate.description+endDate.description,
            groupIdentifier: "Todo's",
            title: title,
            text: summary,
            tintColor: Colors.purple.color,
            instructions: instructions,
            imageURL: Bundle.main.url(forResource: "pressup", withExtension: "jpg"),
            schedule: schedule,
            userInfo: nil,
            optional: false
        )
        
        return activity
    }
 
 */
}
