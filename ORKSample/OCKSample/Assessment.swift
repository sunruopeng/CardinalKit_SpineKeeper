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

import CareKit
import ResearchKit

/**
 Protocol that adds a method to the `Activity` protocol that returns an `ORKTask`
 to present to the user.
 */
protocol Assessment: Activity {
    func task() -> ORKTask
}


/**
 Extends instances of `Assessment` to add a method that returns a
 `OCKCarePlanEventResult` for a `OCKCarePlanEvent` and `ORKTaskResult`. The
 `OCKCarePlanEventResult` can then be written to a `OCKCarePlanStore`.
 */

/* Junaid Commnented

extension Assessment {
    func buildResultForCarePlanEvent(_ event: OCKCarePlanEvent, taskResult: ORKTaskResult) -> OCKCarePlanEventResult {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        formatter.dateFormat = "yyyy-MM-dd"
        let activityType = ActivityType(rawValue: event.activity.identifier)
        if (activityType == ActivityType.startBackSurvey) {
            var out = formatter.string(from: calendar.date(from: event.date)!) + " "
            var result = taskResult.stepResult(forStepIdentifier: "BooleanQuestionStep")
            var results = result?.results
            var r = results?.first as! ORKBooleanQuestionResult
            out += (r.booleanAnswer ?? -1).stringValue
            out += " "
            for i in 1...7 {
                result = taskResult.stepResult(forStepIdentifier: "BooleanQuestionStep" + String(i))
                results = result?.results
                r = results?.first as! ORKBooleanQuestionResult
                out += (r.booleanAnswer ?? -1).stringValue
                out += " "
            }
            let result2 = taskResult.stepResult(forStepIdentifier: "TextChoiceQuestionStep")
            results = result2?.results
            let r2 = results?[0] as! ORKChoiceQuestionResult
            if r2.choiceAnswers != nil {
                out += r2.description.split(separator: "\n")[2].trimmingCharacters(in: .whitespacesAndNewlines)
            }
            else{
                out += "-1"
            }
            let old = UserDefaults.standard.object(forKey: "startBackSurvey") as! String
            UserDefaults.standard.set(old + out, forKey: "startBackSurvey")
            return OCKCarePlanEventResult(valueString: "Complete", unitString: nil, userInfo: nil)
            
        }
        if (activityType == ActivityType.odiSurvey) {
            var out = formatter.string(from: calendar.date(from: event.date)!) + " "
            var result = taskResult.stepResult(forStepIdentifier: "ODITextChoiceQuestionStep")
            var results = result?.results
            var r = results?[0] as! ORKChoiceQuestionResult
            if r.choiceAnswers != nil {
                out += r.description.split(separator: "\n")[2].trimmingCharacters(in: .whitespacesAndNewlines)
            }
            else{
                out += "-1"
            }
            out += " "
            for i in [1,2,3,10,4,5,6,11] {
                result = taskResult.stepResult(forStepIdentifier: "ODITextChoiceQuestionStep" + String(i))
                results = result?.results
                r = results?[0] as! ORKChoiceQuestionResult
                if r.choiceAnswers != nil {
                    out += r.description.split(separator: "\n")[2].trimmingCharacters(in: .whitespacesAndNewlines)
                }
                else{
                    out += "-1"
                }
                out += " "
            }
            let old = UserDefaults.standard.object(forKey: "odiSurvey") as! String
            UserDefaults.standard.set(old + out, forKey: "odiSurvey")
            return OCKCarePlanEventResult(valueString: "Complete", unitString: nil, userInfo: nil)
        }
        if (activityType == ActivityType.sixMinuteWalk) {
            var out = formatter.string(from: calendar.date(from: event.date)!) + " "
            let result = taskResult.stepResult(forStepIdentifier: "fitness.walk")
            let results = result?.results
            var res = results?[0] as! ORKFileResult
            for r1 in results! {
                if (r1.identifier == "pedometer") {
                    res = r1 as! ORKFileResult
                    do {
                        let string = try NSString.init(contentsOf: res.fileURL!, encoding: String.Encoding.utf8.rawValue)
                        out += string as String
                    } catch {}
                }
            }
//            let result = taskResult.stepResult(forStepIdentifier: "timed.walk.form")
//            var results = result?.results
//            let r1 = results?[0] as! ORKBooleanQuestionResult
//            out += (r1.booleanAnswer ?? -1).stringValue
//            out += " "
//            let r2 = results?[1] as! ORKChoiceQuestionResult
//            out += r2.choiceAnswers?[0] as! String
//            out += " "
//            var result2 = (taskResult.stepResult(forStepIdentifier: "timed.walk.trial1")?.firstResult) as! ORKTimedWalkResult
//            out += String(result2.duration)
//            out += " "
//            result2 = (taskResult.stepResult(forStepIdentifier: "timed.walk.turn.around")?.firstResult) as! ORKTimedWalkResult
//            out += String(result2.duration)19
//            out += " "
//            result2 = (taskResult.stepResult(forStepIdentifier: "timed.walk.trial2")?.firstResult) as! ORKTimedWalkResult
//            out += String(result2.duration)
            out += "\n"
            let old = UserDefaults.standard.object(forKey: "sixMinuteWalk") as! String
            UserDefaults.standard.set(old + out, forKey: "sixMinuteWalk")
            //print(UserDefaults.standard.object(forKey: "sixMinuteWalk") as! String)
            return OCKCarePlanEventResult(valueString: "Complete", unitString: nil, userInfo: nil)
        }
        
        if (activityType == ActivityType.backPain) {
            var result = taskResult.stepResult(forStepIdentifier: "backPainStep1")
            let results = result?.results
            let scaleResult = results?.first as? ORKScaleQuestionResult
            let answer = scaleResult?.scaleAnswer
            
            result = taskResult.stepResult(forStepIdentifier: "backPainStep2")
            let results2 = result?.results
            let scaleResult2 = results2?.first as? ORKScaleQuestionResult
            let answer2 = scaleResult2?.scaleAnswer

            return OCKCarePlanEventResult(valueString: answer!.stringValue + "," + (answer2?.stringValue)!, unitString: "average, max", userInfo: nil)
        }
        
        // Get the first result for the first step of the task result.
        guard let firstResult = taskResult.firstResult as? ORKStepResult, let stepResult = firstResult.results?.first else { fatalError("Unexepected task results") }
        
        // Determine what type of result should be saved.
        if let scaleResult = stepResult as? ORKScaleQuestionResult, let answer = scaleResult.scaleAnswer {
            return OCKCarePlanEventResult(valueString: answer.stringValue, unitString: "out of 10", userInfo: nil)
        }
        else if let numericResult = stepResult as? ORKNumericQuestionResult, let answer = numericResult.numericAnswer {
            return OCKCarePlanEventResult(valueString: answer.stringValue, unitString: numericResult.unit, userInfo: nil)
        }
        else if let textResult = stepResult as? ORKTextQuestionResult, let _ = textResult.textAnswer {
           // let answer = textResult.textAnswer
            return OCKCarePlanEventResult(valueString: "Completed", unitString: nil, userInfo: nil)
        }
        
            
            //FIX!!!!! handle all types of results
       //  else if let questionResult = stepResult
        fatalError("Unexpected task result type")
    }
}

 
 */
