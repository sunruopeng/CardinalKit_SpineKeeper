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
 Struct that conforms to the `Assessment` protocol to define a mood
 assessment.
 */
struct StartBackSurvey: Assessment {
    // MARK: Activity
    
    
    let activityType: ActivityType = .startBackSurvey
    
    func carePlanActivity() -> OCKTask? {
        return nil
    }
    
    /* Junaid Commnented
    func carePlanActivity() -> OCKCarePlanActivity {
        let calendar = Calendar.autoupdatingCurrent
        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
        let startDateComps = calendar.dateComponents([.year, .month, .day], from: startDate)
        //let endDate = calendar.dateComponents([.year, .month, .day], from: calendar.date(byAdding: .day, value: 28, to: startDate)!)
        //let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDateComps as DateComponents, occurrencesOnEachDay: [1, 1, 1, 1, 1, 1, 1])
        let endDate = calendar.dateComponents([.year, .month, .day], from: calendar.date(byAdding: .day, value: 365, to: startDate)!)
        
        let days = [8,15,22,28]
        var occurrences = [Int](repeating: 0, count: 28)
        for day in days {
            occurrences[day-1]+=1
        }
        let schedule = OCKCareSchedule.monthlySchedule(withStartDate: startDateComps, occurrencesOnEachDay: occurrences as [NSNumber], endDate: endDate)
        
        
        // Get the localized strings to use for the assessment.
        let title = NSLocalizedString("Back Survey", comment: "")
        
        let activity = OCKCarePlanActivity.assessment(
            withIdentifier: activityType.rawValue,//+startDate.description+endDate.description,
            groupIdentifier: "Diagnostics",
            title: title,
            text: "",
            tintColor: Colors.stanfordGreen.color,
            resultResettable: true,
           // imageURL: Bundle.main.url(forResource: "plank", withExtension: "jpg"),
            schedule: schedule,
            userInfo: nil,// ["hasTask" : "yes"]
            optional: false
        )
        
        return activity
    }
 
 */
    
    // MARK: Assessment
    
    func task() -> ORKTask {
        var steps = [ORKStep]()
        
        // Instruction step
        let instructionStep = ORKInstructionStep(identifier: "IntroStep")
        instructionStep.title = "The Keele Start Back Screening Tool"
        instructionStep.text = "Please answer these 9 questions to the best of your ability. It's okay to skip a question if you don't know the answer. Thinking about the last 2 weeks mark your response to the following questions:"
        
        steps += [instructionStep]
        
        
        // Boolean question
        let booleanQuestionStepTitle = "My back pain has spread down my leg(s) at some time in the last 2 weeks?"
        let booleanQuestionStep = ORKQuestionStep(identifier: "BooleanQuestionStep",
                                                  title: booleanQuestionStepTitle,
                                                  question: booleanQuestionStepTitle,
                                                  answer: ORKBooleanAnswerFormat())
        booleanQuestionStep.text = booleanQuestionStepTitle
        steps += [booleanQuestionStep]
        
        // Boolean question
        let booleanQuestionStepTitle1 = "I have had pain in the shoulder or neck at some time in the last 2 weeks?"
        let booleanQuestionStep1 = ORKQuestionStep(identifier: "BooleanQuestionStep1",
                                                   title: booleanQuestionStepTitle1,
                                                   question: booleanQuestionStepTitle1,
                                                   answer: ORKBooleanAnswerFormat())
        booleanQuestionStep1.text = booleanQuestionStepTitle1
        steps += [booleanQuestionStep1]
        
        // Boolean question
        let booleanQuestionStepTitle2 = "I have only walked short distances because of my back pain?"
        let booleanQuestionStep2 = ORKQuestionStep(identifier: "BooleanQuestionStep2",
                                                   title: booleanQuestionStepTitle2,
                                                   question: booleanQuestionStepTitle2,
                                                   answer: ORKBooleanAnswerFormat())
        booleanQuestionStep2.text = booleanQuestionStepTitle2
        steps += [booleanQuestionStep2]
        
        // Boolean question
        let booleanQuestionStepTitle3 = "In the last 2 weeks, I have dressed more slowly than usual because of back pain?"
        let booleanQuestionStep3 = ORKQuestionStep(identifier: "BooleanQuestionStep3",
                                                   title: booleanQuestionStepTitle3,
                                                   question: booleanQuestionStepTitle3,
                                                   answer: ORKBooleanAnswerFormat())
        booleanQuestionStep3.text = booleanQuestionStepTitle3
        steps += [booleanQuestionStep3]
        
        // Boolean question
        let booleanQuestionStepTitle4 = "It’s not really safe for a person with a condition like mine to be physically active?"
        let booleanQuestionStep4 = ORKQuestionStep(identifier: "BooleanQuestionStep4",
                                                   title: booleanQuestionStepTitle4,
                                                   question: booleanQuestionStepTitle4,
                                                   answer: ORKBooleanAnswerFormat())
        booleanQuestionStep4.text = booleanQuestionStepTitle4
        steps += [booleanQuestionStep4]
        
        // Boolean question
        let booleanQuestionStepTitle5 = "Worrying thoughts have been going through my mind a lot of the time?"
        let booleanQuestionStep5 = ORKQuestionStep(identifier: "BooleanQuestionStep5",
                                                   title: booleanQuestionStepTitle5,
                                                   question: booleanQuestionStepTitle5,
                                                   answer: ORKBooleanAnswerFormat())
        booleanQuestionStep5.text = booleanQuestionStepTitle5
        steps += [booleanQuestionStep5]
        
        // Boolean question
        let booleanQuestionStepTitle6 = "I feel that my back pain is terrible and it’s never going to get any better?"
        let booleanQuestionStep6 = ORKQuestionStep(identifier: "BooleanQuestionStep6",
                                                   title: booleanQuestionStepTitle6,
                                                   question: booleanQuestionStepTitle6,
                                                   answer: ORKBooleanAnswerFormat())
        booleanQuestionStep6.text = booleanQuestionStepTitle6
        steps += [booleanQuestionStep6]
        
        // Boolean question
        let booleanQuestionStepTitle7 = "In general I have not enjoyed all the things I used to enjoy?"
        let booleanQuestionStep7 = ORKQuestionStep(identifier: "BooleanQuestionStep7",
                                                   title: booleanQuestionStepTitle7,
                                                   question: booleanQuestionStepTitle7,
                                                   answer: ORKBooleanAnswerFormat())
        booleanQuestionStep7.text = booleanQuestionStepTitle7
        steps += [booleanQuestionStep7]
        
        
        // Quest question using text choice
        let questQuestionStepTitle = "Overall, how bothersome has your back pain been in the last 2 weeks?"
        let textChoices = [
            ORKTextChoice(text: "Not at all", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Slightly", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Moderately", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Very Much", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Extremely", value: 4 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        let questAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
        let questQuestionStep = ORKQuestionStep(identifier: "TextChoiceQuestionStep",
                                                title: questQuestionStepTitle,
                                                question: questQuestionStepTitle,
                                                answer: questAnswerFormat)
        questQuestionStep.text = questQuestionStepTitle
        steps += [questQuestionStep]
        
        /*
         
         // Name question using text input
         let nameAnswerFormat = ORKTextAnswerFormat(maximumLength: 25)
         nameAnswerFormat.multipleLines = false
         let nameQuestionStepTitle = "What do you think the next comet that's discovered should be named?"
         let nameQuestionStep = ORKQuestionStep(identifier: "NameQuestionStep", title: nameQuestionStepTitle, answer: nameAnswerFormat)
         
         steps += [nameQuestionStep]
         
         let shapeQuestionStepTitle = "Which shape is the closest to the shape of Messier object 101?"
         let shapeTuples = [
         (UIImage(named: "square")!, "Square"),
         (UIImage(named: "pinwheel")!, "Pinwheel"),
         (UIImage(named: "pentagon")!, "Pentagon"),
         (UIImage(named: "circle")!, "Circle")
         ]
         let imageChoices : [ORKImageChoice] = shapeTuples.map {
         return ORKImageChoice(normalImage: $0.0, selectedImage: nil, text: $0.1, value: $0.1 as NSCoding & NSCopying & NSObjectProtocol)
         }
         let shapeAnswerFormat: ORKImageChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: imageChoices)
         let shapeQuestionStep = ORKQuestionStep(identifier: "ImageChoiceQuestionStep", title: shapeQuestionStepTitle, answer: shapeAnswerFormat)
         
         steps += [shapeQuestionStep]
         
         // Date question
         let today = NSDate()
         let dateAnswerFormat =  ORKAnswerFormat.dateAnswerFormat(withDefaultDate: nil, minimumDate: today as Date, maximumDate: nil, calendar: nil)
         let dateQuestionStepTitle = "When is the next solar eclipse?"
         let dateQuestionStep = ORKQuestionStep(identifier: "DateQuestionStep", title: dateQuestionStepTitle, answer: dateAnswerFormat)
         
         steps += [dateQuestionStep]
         
         /* Boolean question
         let booleanAnswerFormat = ORKBooleanAnswerFormat()
         let booleanQuestionStepTitle = "Is Venus larger than Saturn?"
         let booleanQuestionStep = ORKQuestionStep(identifier: "BooleanQuestionStep", title: booleanQuestionStepTitle, answer: booleanAnswerFormat)
         
         steps += [booleanQuestionStep]
         */
         
         // Continuous question
         let continuousAnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 150, minimumValue: 30, defaultValue: 20, step: 10, vertical: false, maximumValueDescription: "Objects", minimumValueDescription: " ")
         let continuousQuestionStepTitle = "How many objects are in Messier's catalog?"
         let continuousQuestionStep = ORKQuestionStep(identifier: "ContinuousQuestionStep", title: continuousQuestionStepTitle, answer: continuousAnswerFormat)
         
         steps += [continuousQuestionStep]
         
         */
        // Summary step
        
        let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
        summaryStep.title = "Thank you."
        summaryStep.text = "We appreciate your time."
        
        steps += [summaryStep]
        
        return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
    }
}
