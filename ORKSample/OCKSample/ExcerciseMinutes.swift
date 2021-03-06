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
struct ExcerciseMinutes: Assessment {
    // MARK: Activity
    
    let activityType: ActivityType = .excerciseMinutes
    
    func carePlanActivity() -> OCKTask? {
        return nil
    }
    
    //Junaid Commneted
//    func carePlanActivity() -> OCKCarePlanActivity {
//        // Create a weekly schedule.
//        let startDate = DateComponents(year: 2016, month: 01, day: 01)
//        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate as DateComponents, occurrencesOnEachDay: [1, 1, 1, 1, 1, 1, 1])
//
//        // Get the localized strings to use for the assessment.
//        let title = NSLocalizedString("Excercise", comment: "")
//        let summary = NSLocalizedString("Minutes of activity", comment: "")
//        let activity = OCKCarePlanActivity.assessment(
//            withIdentifier: activityType.rawValue,
//            groupIdentifier: nil,
//            title: title,
//            text: summary,
//            tintColor: Colors.purple.color,
//            resultResettable: false,
//            schedule: schedule,
//            userInfo: nil,
//            optional: false
//        )
//
//        return activity
//    }
    
    // MARK: Assessment
    
    func task() -> ORKTask {

        // Get the localized strings to use for the task.
        if #available(iOS 9.3, *) {
            let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleExerciseTime)!
            let unit = HKUnit.minute()
            let answerFormat = ORKHealthKitQuantityTypeAnswerFormat(quantityType: quantityType, unit: unit, style: .integer)
            let title = NSLocalizedString("Input the number of minutes of excercise you performed today", comment: "")
            let questionStep = ORKQuestionStep(identifier: activityType.rawValue,
                                               title: title,
                                               question: title,
                                               answer: answerFormat)
            questionStep.isOptional = false

            // Create an ordered task with a single question.
            let task = ORKOrderedTask(identifier: activityType.rawValue, steps: [questionStep])
            return task
        } else {
            let answerFormat = ORKNumericAnswerFormat(style: ORKNumericAnswerStyle.integer, unit: "min")
            let title = NSLocalizedString("Input the number of minutes of excercise you performed today", comment: "")
            let questionStep = ORKQuestionStep(identifier: activityType.rawValue,
                                               title: title,
                                               question: title,
                                               answer: answerFormat)
            questionStep.isOptional = false
            
            // Create an ordered task with a single question.
            let task = ORKOrderedTask(identifier: activityType.rawValue, steps: [questionStep])
            return task
        }
    }
}
