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
struct TransverseCore: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .transverseCore //Change this
    
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
            days = [1,9,13,15,16,18,20,22,24,26,28]
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
        let title = NSLocalizedString("Transverse Core Strengthening", comment: "")  // Title Change ###
        let summary = NSLocalizedString("Repeat 10 times", comment: "") // CHANGE COMMENT AND INSTRUCTIONS BELOW
        let instructions = "This exercise strengthens the muscles that cross from your ribs across your waist and help support you in an upright position. Stand with feet shoulder width apart and toes turned in very slightly. Hold a household object of desired weight (book, can of soup, exercise weight) directly in front of you. Keep your abdominal muscles tight and feet flat on the floor; rotate from side to side. Repeat 10 times.\n\nIf you are able to use progressively heavier balls, you will experience more benefit from this exercise. Check with your physician to see if you can/should do this."
        
        
        // Create the intervention activity.
        let activity = OCKCarePlanActivity.intervention(
            withIdentifier: activityType.rawValue,//+startDate.description+endDate.description,
            groupIdentifier: "Todo's",
            title: title,
            text: summary,
            tintColor: Colors.pink.color,  //Change the color here ###
            instructions: instructions,
            imageURL: Bundle.main.url(forResource: "transversecore_combined", withExtension: "jpg"),
            schedule: schedule,
            userInfo: nil,
            optional: false
        )
        
        return activity
    }
}

