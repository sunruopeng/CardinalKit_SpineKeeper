
import ResearchKit
import CareKit

/**
 Struct that conforms to the `Assessment` protocol to define a mood
 assessment.
 */
struct ODISurvey: Assessment {
    // MARK: Activity
    
    let activityType: ActivityType = .odiSurvey
    
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
        let title = NSLocalizedString("ODI Survey", comment: "")
        
        let activity = OCKCarePlanActivity.assessment(
            withIdentifier: activityType.rawValue,//+startDate.description+endDate.description,
            groupIdentifier: "Diagnostics",
            title: title,
            text: "",
            tintColor: Colors.stanfordAqua.color,
            resultResettable: true,
            // imageURL: Bundle.main.url(forResource: "plank", withExtension: "jpg"),
            schedule: schedule,
            userInfo: nil,// ["hasTask" : "yes"]
            optional: false
        )
        
        return activity
    }
    
    // MARK: Assessment
    
    func task() -> ORKTask {
        var steps = [ORKStep]()
        
        // Instruction step
        let instructionStep = ORKInstructionStep(identifier: "ODIIntroStep")
        instructionStep.title = "Oswestry Disability Index"
        instructionStep.text = "Could you please complete this questionnaire. It is designed to give us information as to how your back (or leg) trouble has affected your ability to manage in everyday life."
  
        
        steps += [instructionStep]
        
        
        // Quest question using text choice
        var questQuestionStepTitle = "Pain intensity"
        var textChoices = [
            ORKTextChoice(text: "I have no pain at the moment.", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "The pain is very mild at the moment.", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "The pain is moderate at the moment.", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "The pain is farily severe at the moment.", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "The pain is very severe at the moment.", value: 4 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "The pain is the worst imaginable at the moment.", value: 5 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        var questAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
        var questQuestionStep = ORKQuestionStep(identifier: "ODITextChoiceQuestionStep",
                                                title: questQuestionStepTitle,
                                                question: nil,
                                                answer: questAnswerFormat)
        steps += [questQuestionStep]
        
        // Quest question using text choice
        questQuestionStepTitle = "Personal care (washing, dressing, etc.)"
        textChoices = [
            ORKTextChoice(text: "I can look after myself normally without causing extra pain.", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "I can look after myself normally but it is very painful.", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "It is painful to look after myself and I am slow and careful.", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "I need some help but manage most of my personal care.", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "I need help every day in most aspects of self care.", value: 4 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "I do not get dressed, wash with difficulty and stay in bed.", value: 5 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        questAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
        questQuestionStep = ORKQuestionStep(identifier: "ODITextChoiceQuestionStep1",
                                            title: questQuestionStepTitle,
                                            question: nil,
                                            answer: questAnswerFormat)
        steps += [questQuestionStep]

        // Quest question using text choice
        questQuestionStepTitle = "Lifting"
        textChoices = [
            ORKTextChoice(text: "I can lift heavy weights without extra pain.", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "I can lift heavy weights but it gives extra pain.", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pain prevents me from lifting heavy weights off the floor but I can manage if they are conveniently positioned, e.g. on a table. ", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pain prevents me from lifting heavy weights but I can manage light to medium weights if they are conveniently positioned.", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "I can lift only very light weights.", value: 4 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "I cannot lift or carry anything at all.", value: 5 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        questAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
        questQuestionStep = ORKQuestionStep(identifier: "ODITextChoiceQuestionStep2",
                                            title: questQuestionStepTitle,
                                            question: nil,
                                            answer: questAnswerFormat)
        steps += [questQuestionStep]
        
        // Quest question using text choice
        questQuestionStepTitle = "Walking"
        textChoices = [
            ORKTextChoice(text: "Pain does not prevent me walking any distance.", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pain prevents me walking more than 1 mile.", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pain prevents me walking more than 1/4 of a mile.", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pain prevents me walking more than 100 yards.", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "I can only walk using a stick or crutches.", value: 4 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "I am in bed most of the time and have to crawl to the toilet.", value: 5 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        questAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
        questQuestionStep = ORKQuestionStep(identifier: "ODITextChoiceQuestionStep3",
                                            title: questQuestionStepTitle,
                                            question: nil,
                                            answer: questAnswerFormat)
        steps += [questQuestionStep]
        
        // Quest question using text choice
        questQuestionStepTitle = "Sitting"
        textChoices = [
            ORKTextChoice(text: "I can sit in any chair as long as I like.", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "I can sit in my favourite chair as long as I like.", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pain prevents me from sitting for more than 1 hour.", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pain prevents me from sitting for more than 1/2 hour.", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pain prevents me from stiting for more than 10 minutes.", value: 4 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pain prevents me from sitting at all.", value: 5 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        questAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
        questQuestionStep = ORKQuestionStep(identifier: "ODITextChoiceQuestionStep10",
                                            title: questQuestionStepTitle,
                                            question: nil,
                                            answer: questAnswerFormat)
        steps += [questQuestionStep]

        
        // Quest question using text choice
        questQuestionStepTitle = "Standing"
        textChoices = [
            ORKTextChoice(text: "I can stand as long as I want without extra pain.", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "I can stand as long as I want but it gives me extra pain.", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pain prevents me from standing for me than 1 hour.", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pain prevents me from standing for more than 1/2 an hour.", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pain prevents me from standing for more than 10 minutes.", value: 4 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pain prevents me from standing at all.", value: 5 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        questAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
        questQuestionStep = ORKQuestionStep(identifier: "ODITextChoiceQuestionStep4",
                                            title: questQuestionStepTitle,
                                            question: nil,
                                            answer: questAnswerFormat)
        steps += [questQuestionStep]
        
        
        // Quest question using text choice
        questQuestionStepTitle = "Sleeping"
        textChoices = [
            ORKTextChoice(text: "My sleep is never disturbed by pain.", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "My sleep is occasionally disturbed by pain.", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Because of pain I have less than 6 hours sleep.", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Because of pain I have less than 4 hours sleep.", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Because of pain I have less than 2 hours sleep.", value: 4 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pain prevents me from sleeping at all.", value: 5 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        questAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
        questQuestionStep = ORKQuestionStep(identifier: "ODITextChoiceQuestionStep5",
                                            title: questQuestionStepTitle,
                                            question: nil,
                                            answer: questAnswerFormat)
        steps += [questQuestionStep]
        
        
        // Quest question using text choice
        questQuestionStepTitle = "Social Life"
        textChoices = [
            ORKTextChoice(text: "My social life is normal and causes me no pain.", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "My social life is normal but increases the degree of pain.", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pain has no significant effect on my social life apart from limiting my more energetic interests, e.g. sport etc.", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pain has restricted my social life and I do not go out as often.", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pain has restricted social life to my home.", value: 4 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "I have no social life because of pain.", value: 5 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        questAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
        questQuestionStep = ORKQuestionStep(identifier: "ODITextChoiceQuestionStep6",
                                            title: questQuestionStepTitle,
                                            question: nil,
                                            answer: questAnswerFormat)
        steps += [questQuestionStep]
        
        
        // Quest question using text choice
        questQuestionStepTitle = "Travelling"
        textChoices = [
            ORKTextChoice(text: "I can travel anywhere without pain.", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "I can travel anywhere but it gives extra pain.", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pain is bad but I manage journeys over 2 hours.", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pain restricts me to journeys of less than one hour.", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pain restricts me to short necessary journeys under 30 minutes.", value: 4 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pain prevents me from travelling except to recieve treatment.", value: 5 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        questAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
        questQuestionStep = ORKQuestionStep(identifier: "ODITextChoiceQuestionStep11",
                                            title: questQuestionStepTitle,
                                            question: nil,
                                            answer: questAnswerFormat)
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
 
        
        let summaryStep = ORKCompletionStep(identifier: "ODISummaryStep")
        summaryStep.title = "Thank you."
        summaryStep.text = "We appreciate your time."
        
        steps += [summaryStep]
        return ORKOrderedTask(identifier: activityType.rawValue, steps: steps)
    }
}
