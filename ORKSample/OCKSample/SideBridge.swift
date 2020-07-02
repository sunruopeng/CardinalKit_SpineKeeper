
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
struct SideBridge: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .sideBridge //Change this
    
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
            days = [7,12,15,17,19,21,23,25,27]
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
        let title = NSLocalizedString("Side Bridge", comment: "")  // Title Change ###
        let summary = NSLocalizedString("Repeat 1-5 times", comment: "") // CHANGE COMMENT AND INSTRUCTIONS BELOW
        let instructions = "On your side with knees bent at 90 degrees, prop up on your elbow, elongate neck away from shoulder, and draw your abdominal wall in. Continue to breathe. Lift hips away from table keeping your head, shoulders and hips in a straight line. Hold for 10 seconds working towards 30 seconds. Repeat 1-5 times or to fatigue."
        
        // Create the intervention activity.
        let activity = OCKCarePlanActivity.intervention(
            withIdentifier: activityType.rawValue,//+startDate.description+endDate.description,
            groupIdentifier: "Todo's",
            title: title,
            text: summary,
            tintColor: Colors.blue.color,  //Change the color here ###
            instructions: instructions,
            imageURL: Bundle.main.url(forResource: "sidebridge", withExtension: "jpg"),
            schedule: schedule,
            userInfo: nil,
            optional: false
        )
        
        return activity
    }
 
 */
}




