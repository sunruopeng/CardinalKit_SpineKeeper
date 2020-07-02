
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
//struct NeckPress: Activity {
//    // MARK: Activity
//    
//    let activityType: ActivityType = .neckPress //Change this
//    
//    func carePlanActivity() -> OCKCarePlanActivity {
//        // Create a weekly schedule.
//        let calendar = Calendar.autoupdatingCurrent
//        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
//        let startDateComps = calendar.dateComponents([.year, .month, .day], from: startDate)
//        let endDate = calendar.dateComponents([.year, .month, .day], from: calendar.date(byAdding: .day, value: 28, to: startDate)!)
//        
//        
//        var days: [Int] = []
//        switch(UserDefaults.standard.integer(forKey: "activityScheduleIndex")) {
//        case 0:
//            days = []
//            break;
//        case 1:
//            days = []
//            break;
//        case 2:
//            days = [6,11,14,17,19,21,23,25,27]
//            break;
//        default:
//            days = []
//        }
//        
//        var occurrences = [Int](repeating: 0, count: 28)
//        for day in days {
//            occurrences[day-1]+=1
//        }
//        
//        let schedule = OCKCareSchedule.monthlySchedule(withStartDate: startDateComps, occurrencesOnEachDay: occurrences as [NSNumber], endDate: endDate)
//        
//        // Get the localized strings to use for the activity. ### Change the instructions
//        let title = NSLocalizedString("Neck Press", comment: "")  // Title Change ###
//        let summary = NSLocalizedString("Repeat 6 times", comment: "") // CHANGE COMMENT AND INSTRUCTIONS BELOW
//        let instructions = "This is an isometric exercise to strengthen your neck. Press your palm against your forehead, then use your neck muscles to push against your palm. Hold for ten seconds and repeat six times. Then press your palm against your temple and use your neck muscles to push against your palm, holding for ten seconds and repeating six times on each side. Then cup both hands behind your head and use your neck muscles to press back into your hands. Hold for ten seconds, and repeat six times."
//        
//        // Create the intervention activity.
//        let activity = OCKCarePlanActivity.intervention(
//            withIdentifier: activityType.rawValue,//+startDate.description+endDate.description,
//            groupIdentifier: "Todo's",
//            title: title,
//            text: summary,
//            tintColor: Colors.blue.color,  //Change the color here ###
//            instructions: instructions,
//            imageURL: Bundle.main.url(forResource: "neck_combined", withExtension: "jpg"),
//            schedule: schedule,
//            userInfo: nil,
//            optional: false
//        )
//        
//        return activity
//    }
//}
//
//
//
