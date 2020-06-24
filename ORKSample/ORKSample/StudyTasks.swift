/*
 Copyright (c) 2015, Apple Inc. All rights reserved.
 
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

struct StudyTasks {
    
    
    /*
     /// This task presents the video capture step in an ordered task.
     private var videoCaptureTask: ORKTask {
     // Create the intro step.
     let instructionStep = ORKInstructionStep(identifier: String(describing:Identifier.introStep))
     
     instructionStep.title = NSLocalizedString("Sample Survey", comment: "")
     
     instructionStep.text = exampleDescription
     
     let handSolidImage = UIImage(named: "hand_solid")!
     instructionStep.image = handSolidImage.withRenderingMode(.alwaysTemplate)
     
     let videoCaptureStep = ORKVideoCaptureStep(identifier: String(describing:Identifier.VideoCaptureStep))
     videoCaptureStep.accessibilityInstructions = NSLocalizedString("Your instructions for capturing the video", comment: "")
     videoCaptureStep.accessibilityHint = NSLocalizedString("Captures the video visible in the preview", comment: "")
     videoCaptureStep.templateImage = UIImage(named: "hand_outline_big")!
     videoCaptureStep.templateImageInsets = UIEdgeInsets(top: 0.05, left: 0.05, bottom: 0.05, right: 0.05)
     videoCaptureStep.duration = 30.0; // 30 seconds
     
     return ORKOrderedTask(identifier: String(describing:Identifier.VideoCaptureTask), steps: [
     instructionStep,
     videoCaptureStep
     ])
     }
     
     */
    /// This task presents the Timed Walk with turn around pre-defined active task.
    static let sixMinuteWalk: ORKOrderedTask = {
        let intendedUseDescription = "Fitness is important."
        // let speechInstruction = "walk for a bit then stop"
        return ORKOrderedTask.timedWalk(withIdentifier: "walking task", intendedUseDescription: intendedUseDescription, distanceInMeters: 100.0, timeLimit: 180.0, turnAroundTimeLimit: 60.0, includeAssistiveDeviceForm: true, options: [])
    }()
    
    
    static let microphoneTask: ORKOrderedTask = {
        let intendedUseDescription = "Everyone's voice has unique characteristics."
        let speechInstruction = "After the countdown, please read the following sentance at a moderate pace: 'I have dealt with back pain for a very long time.' You'll have 10 seconds."
        let shortSpeechInstruction = "read outloud - 'I have dealt with back pain for a very long time'."
        
        return ORKOrderedTask.audioTask(withIdentifier: "AudioTask", intendedUseDescription: intendedUseDescription, speechInstruction: speechInstruction, shortSpeechInstruction: shortSpeechInstruction, duration: 15, recordingSettings: nil, checkAudioLevel: false, options: ORKPredefinedTaskOption.excludeAccelerometer)
    }()
    
    static let backRangeOfMotionTask: ORKOrderedTask  = {
        let intendedUseDescription = "Back range of motion can be important in back pain"
        return ORKOrderedTask.kneeRangeOfMotionTask(withIdentifier: "back range of motion", limbOption: .right,intendedUseDescription: intendedUseDescription,  options: [])
    }()
    
    
    
    static let surveyTask: ORKOrderedTask = {
        var steps = [ORKStep]()
        
        // Instruction step
        let instructionStep = ORKInstructionStep(identifier: "IntroStep")
        instructionStep.title = "The Keele STarT Back Screening Tool"
        instructionStep.text = "Please answer these 9 questions to the best of your ability. It's okay to skip a question if you don't know the answer. Thinking about the last 2 weeks mark your response to the following questions:"
        
        steps += [instructionStep]
        
        
        // Boolean question
        let booleanQuestionStepTitle = "My back pain has spread down my leg(s) at some time in the last 2 weeks?"
        let booleanQuestionStep = ORKQuestionStep(identifier: "BooleanQuestionStep", title: booleanQuestionStepTitle, answer: ORKBooleanAnswerFormat())
        
        steps += [booleanQuestionStep]
        
        // Boolean question
        let booleanQuestionStepTitle1 = "I have had pain in the shoulder or neck at some time in the last 2 weeks?"
        let booleanQuestionStep1 = ORKQuestionStep(identifier: "BooleanQuestionStep1", title: booleanQuestionStepTitle1, answer: ORKBooleanAnswerFormat())
        
        steps += [booleanQuestionStep1]
        
        // Boolean question
        let booleanQuestionStepTitle2 = "I have only walked short distances because of my back pain?"
        let booleanQuestionStep2 = ORKQuestionStep(identifier: "BooleanQuestionStep2", title: booleanQuestionStepTitle2, answer: ORKBooleanAnswerFormat())
        
        steps += [booleanQuestionStep2]
        
        // Boolean question
        let booleanQuestionStepTitle3 = "In the last 2 weeks, I have dressed more slowly than usual because of back pain?"
        let booleanQuestionStep3 = ORKQuestionStep(identifier: "BooleanQuestionStep3", title: booleanQuestionStepTitle3, answer: ORKBooleanAnswerFormat())
        
        steps += [booleanQuestionStep3]
        
        // Boolean question
        let booleanQuestionStepTitle4 = "It’s not really safe for a person with a condition like mine to be physically active?"
        let booleanQuestionStep4 = ORKQuestionStep(identifier: "BooleanQuestionStep4", title: booleanQuestionStepTitle4, answer: ORKBooleanAnswerFormat())
        
        steps += [booleanQuestionStep4]
        
        // Boolean question
        let booleanQuestionStepTitle5 = "Worrying thoughts have been going through my mind a lot of the time?"
        let booleanQuestionStep5 = ORKQuestionStep(identifier: "BooleanQuestionStep5", title: booleanQuestionStepTitle5, answer: ORKBooleanAnswerFormat())
        
        steps += [booleanQuestionStep5]
        
        // Boolean question
        let booleanQuestionStepTitle6 = "I feel that my back pain is terrible and it’s never going to get any better?"
        let booleanQuestionStep6 = ORKQuestionStep(identifier: "BooleanQuestionStep6", title: booleanQuestionStepTitle6, answer: ORKBooleanAnswerFormat())
        
        steps += [booleanQuestionStep6]
        
        // Boolean question
        let booleanQuestionStepTitle7 = "In general I have not enjoyed all the things I used to enjoy?"
        let booleanQuestionStep7 = ORKQuestionStep(identifier: "BooleanQuestionStep7", title: booleanQuestionStepTitle7, answer: ORKBooleanAnswerFormat())
        
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
        let questQuestionStep = ORKQuestionStep(identifier: "TextChoiceQuestionStep", title: questQuestionStepTitle, answer: questAnswerFormat)
        
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
    }()
}
