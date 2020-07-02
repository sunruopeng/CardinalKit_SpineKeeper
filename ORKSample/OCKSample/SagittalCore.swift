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
struct SagittalCore: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .sagittalCore //Change this
    
    
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
            days = []
            break;
        case 1:
            days = []
            break;
        case 2:
            days = [2,9,13,16,18,20,22,24,26,28]
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
        let title = NSLocalizedString("Sagittal Core Strengthening", comment: "")  // Title Change ###
        let summary = NSLocalizedString("Repeat 10 times", comment: "") // CHANGE COMMENT AND INSTRUCTIONS BELOW
        let instructions = "You can stretch and strengthen the low back muscles that help you stand and lift. Stand with your feet shoulder width apart, about 18” in front of a wall (with your back to the wall).  Hold a household object of desired weight (book, can of soup, exercise weight) directly in front of you. Tighten your abdominal muscles, then reach through your legs to touch the wall, keeping hips and knees bent. Use your hips to push your body back to a standing position, then extend your arms and reach over your head and slightly backward. Repeat 10 times."
        
        // Create the intervention activity.
        let activity = OCKCarePlanActivity.intervention(
            withIdentifier: activityType.rawValue,//+startDate.description+endDate.description,
            groupIdentifier: "Todo's",
            title: title,
            text: summary,
            tintColor: Colors.pink.color,  //Change the color here ###
            instructions: instructions,
            imageURL: Bundle.main.url(forResource: "sagittalcore_combined", withExtension: "jpg"),
            schedule: schedule,
            userInfo: nil,
            optional: false
        )
        
        return activity
    }
    
    */
}

