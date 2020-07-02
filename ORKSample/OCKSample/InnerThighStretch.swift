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
struct InnerThighStretch: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .innerThighStretch //Change this
    
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
            days = [4,9,13,15,17,19,21,23,25,27]
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
        let title = NSLocalizedString("Inner Thigh Stretch", comment: "")  // Title Change ###
        let summary = NSLocalizedString("Hold for 60 seconds", comment: "") // CHANGE COMMENT AND INSTRUCTIONS BELOW
        let instructions = "Turn your body facing forward. Place your leg onto a chair and try to keep your leg straight. Adjust the height of the chair as necessary to allow you to maintain a straight leg. Lean into the leg on the chair to feel a stretch in the inner thigh area. Hold for 60 seconds"

        
        // Create the intervention activity.
        let activity = OCKCarePlanActivity.intervention(
            withIdentifier: activityType.rawValue,//+startDate.description+endDate.description,
            groupIdentifier: "Todo's",
            title: title,
            text: summary,
            tintColor: Colors.pink.color,  //Change the color here ###
            instructions: instructions,
            imageURL: Bundle.main.url(forResource: "innerthighstretch", withExtension: "jpg"),
            schedule: schedule,
            userInfo: nil,
            optional: false
        )
        
        return activity
    }
    
    */
}
