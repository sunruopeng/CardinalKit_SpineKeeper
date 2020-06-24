/*
 Copyright (c) 2016, Apple Inc. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 1.  Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2.  Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 3.  Neither the name of the copyright holder(s) nor the names of any contributors
 may be used to endorse or promote products derived from this software without
 specific prior written permission. No license is granted to the trademarks of
 the copyright holders even if such marks are included in this software.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import ResearchKit
import CareKit

/**
 Struct that conforms to the `Assessment` protocol to define a blood glucose
 assessment.
 */
struct SixMinuteWalk: Assessment {
    // MARK: Activity
    
    let activityType: ActivityType = .sixMinuteWalk
    
    func carePlanActivity() -> OCKCarePlanActivity {
        let calendar = Calendar.autoupdatingCurrent
        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
        let startDateComps = calendar.dateComponents([.year, .month, .day], from: startDate)
        //let endDate = calendar.dateComponents([.year, .month, .day], from: calendar.date(byAdding: .day, value: 28, to: startDate)!)
        //let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDateComps as DateComponents, occurrencesOnEachDay: [1, 1, 1, 1, 1, 1, 1])
        let endDate = calendar.dateComponents([.year, .month, .day], from: calendar.date(byAdding: .day, value: 365, to: startDate)!)
        
        let days = [1,10,19]
        var occurrences = [Int](repeating: 0, count: 28)
        for day in days {
            occurrences[day-1]+=1
        }
        let schedule = OCKCareSchedule.monthlySchedule(withStartDate: startDateComps, occurrencesOnEachDay: occurrences as [NSNumber], endDate: endDate)
        
        // Get the localized strings to use for the assessment.
        let title = NSLocalizedString("6-Minute Walk Test", comment: "")
        let summary = NSLocalizedString("Perform a 6-minute walk", comment: "")
        
        let activity = OCKCarePlanActivity.assessment(
            withIdentifier: activityType.rawValue,//+startDate.description+endDate.description,
            groupIdentifier: "Todo's",
            title: title,
            text: summary,
            tintColor: Colors.stanfordGreen.color,
            resultResettable: true,
            schedule: schedule,
            userInfo: nil,
            optional: false
        )
        return activity
    }
    
    // MARK: Assessment
    
    func task() -> ORKTask {
        let intendedUseDescription = "Fitness is important. Please hold your phone in your non-dominant hand or place it in your pocket while you complete this task."
        UIApplication.shared.isIdleTimerDisabled = true
        // let speechInstruction = "walk for a bit then stop"
        return ORKOrderedTask.fitnessCheck(withIdentifier: "walkingTask", intendedUseDescription: intendedUseDescription, walkDuration: 360, restDuration: 0, options: [])
        //DEBUG
        //return ORKOrderedTask.fitnessCheck(withIdentifier: "walkingTask", intendedUseDescription: intendedUseDescription, walkDuration: 5, restDuration: 0, options: [])
        
        
        //return ORKOrderedTask.timedWalk(withIdentifier: "walkingTask", intendedUseDescription: intendedUseDescription, distanceInMeters: 100.0, timeLimit: 180.0, turnAroundTimeLimit: 60.0, includeAssistiveDeviceForm: true, options: [])
    }
}
