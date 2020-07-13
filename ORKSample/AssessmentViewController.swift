//
//  AssessmentViewController.swift
//  ORKSample
//
//  Created by Muhammad Junaid Butt on 08/07/2020.
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import ResearchKit
import CareKit

class AssessmentViewController: OCKInstructionsTaskViewController, ORKTaskViewControllerDelegate {
    
    private let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
    private let unit = HKUnit.pound()
    private var taskIdentifier = ""
    let formatter = DateFormatter()
    let calendar = Calendar.current
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Delegate method of ORKTaskViewControllerDelegate
    func taskViewController(_ taskViewController: ORKTaskViewController,
                            didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        
        print(reason.rawValue)
        print(error?.localizedDescription)
        
        if taskIdentifier == ActivityType.sixMinuteWalk.rawValue {
            
            if reason == .completed {
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
        
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        guard reason == .completed else {
            self.taskView.completionButton.isSelected = false
            self.taskView.completionButton.label.text = "Start Assessment"
            return
        }
        
        //handle result of weight assessment
        if taskIdentifier == ActivityType.weight.rawValue {
            let step1 = taskViewController.result.results!.first(where: { $0.identifier == "WeightSample" }) as! ORKStepResult
            let step1Result = step1.results!.first as! ORKNumericQuestionResult
            let weightAnswer = step1Result.numericAnswer
            let answerStep1 = Int(truncating: weightAnswer ?? 0.0)
            
            //save results
            self.saveAssessmentResult(values: [answerStep1])
        }
        
        //handle result of back survey assessment
        if taskIdentifier == ActivityType.startBackSurvey.rawValue {
            let question1 = taskViewController.result.results!.first(where: { $0.identifier == "BooleanQuestionStep" }) as! ORKStepResult
            let step1Result = question1.results!.first as! ORKBooleanQuestionResult
            let answer1 = Int(truncating: step1Result.booleanAnswer ?? false)
            
            let question2 = taskViewController.result.results!.first(where: { $0.identifier == "BooleanQuestionStep1" }) as! ORKStepResult
            let step2Result = question2.results!.first as! ORKBooleanQuestionResult
            let answer2 = Int(truncating: step2Result.booleanAnswer ?? false)
                        
            let question3 = taskViewController.result.results!.first(where: { $0.identifier == "BooleanQuestionStep2" }) as! ORKStepResult
            let step3Result = question3.results!.first as! ORKBooleanQuestionResult
            let answer3 = Int(truncating: step3Result.booleanAnswer ?? false)
                        
            let question4 = taskViewController.result.results!.first(where: { $0.identifier == "BooleanQuestionStep3" }) as! ORKStepResult
            let step4Result = question4.results!.first as! ORKBooleanQuestionResult
            let answer4 = Int(truncating: step4Result.booleanAnswer ?? false)
                        
            let question5 = taskViewController.result.results!.first(where: { $0.identifier == "BooleanQuestionStep4" }) as! ORKStepResult
            let step5Result = question5.results!.first as! ORKBooleanQuestionResult
            let answer5 = Int(truncating: step5Result.booleanAnswer ?? false)
                        
            let question6 = taskViewController.result.results!.first(where: { $0.identifier == "BooleanQuestionStep5" }) as! ORKStepResult
            let step6Result = question6.results!.first as! ORKBooleanQuestionResult
            let answer6 = Int(truncating: step6Result.booleanAnswer ?? false)
                        
            let question7 = taskViewController.result.results!.first(where: { $0.identifier == "BooleanQuestionStep6" }) as! ORKStepResult
            let step7Result = question7.results!.first as! ORKBooleanQuestionResult
            let answer7 = Int(truncating: step7Result.booleanAnswer ?? false)
            
            let question8 = taskViewController.result.results!.first(where: { $0.identifier == "BooleanQuestionStep7" }) as! ORKStepResult
            let step8Result = question8.results!.first as! ORKBooleanQuestionResult
            let answer8 = Int(truncating: step8Result.booleanAnswer ?? false)
                        
            let question9 = taskViewController.result.results!.first(where: { $0.identifier == "TextChoiceQuestionStep" }) as! ORKStepResult
            let step9Result = question9.results!.first as! ORKChoiceQuestionResult
            let answer9 = Int(truncating: step9Result.choiceAnswers?[0] as! NSNumber)
            
            //save results
            self.saveAssessmentResult(values: [answer1, answer2, answer3, answer4, answer5, answer6, answer7, answer8, answer9])
        }
        
        //handle result of ODI assessment
        if taskIdentifier == ActivityType.odiSurvey.rawValue {
            let question1 = taskViewController.result.results!.first(where: { $0.identifier == "ODITextChoiceQuestionStep" }) as! ORKStepResult
            let step1Result = question1.results!.first as! ORKChoiceQuestionResult
            let answer1 = Int(truncating: step1Result.choiceAnswers?[0] as! NSNumber)
            
            let question2 = taskViewController.result.results!.first(where: { $0.identifier == "ODITextChoiceQuestionStep1" }) as! ORKStepResult
            let step2Result = question2.results!.first as! ORKChoiceQuestionResult
            let answer2 = Int(truncating: step2Result.choiceAnswers?[0] as! NSNumber)
                        
            let question3 = taskViewController.result.results!.first(where: { $0.identifier == "ODITextChoiceQuestionStep2" }) as! ORKStepResult
            let step3Result = question3.results!.first as! ORKChoiceQuestionResult
            let answer3 = Int(truncating: step3Result.choiceAnswers?[0] as! NSNumber)
            
            let question4 = taskViewController.result.results!.first(where: { $0.identifier == "ODITextChoiceQuestionStep3" }) as! ORKStepResult
            let step4Result = question4.results!.first as! ORKChoiceQuestionResult
            let answer4 = Int(truncating: step4Result.choiceAnswers?[0] as! NSNumber)
                        
            let question5 = taskViewController.result.results!.first(where: { $0.identifier == "ODITextChoiceQuestionStep10" }) as! ORKStepResult
            let step5Result = question5.results!.first as! ORKChoiceQuestionResult
            let answer5 = Int(truncating: step5Result.choiceAnswers?[0] as! NSNumber)
                        
            let question6 = taskViewController.result.results!.first(where: { $0.identifier == "ODITextChoiceQuestionStep4" }) as! ORKStepResult
            let step6Result = question6.results!.first as! ORKChoiceQuestionResult
            let answer6 = Int(truncating: step6Result.choiceAnswers?[0] as! NSNumber)
                        
            let question7 = taskViewController.result.results!.first(where: { $0.identifier == "ODITextChoiceQuestionStep5" }) as! ORKStepResult
            let step7Result = question7.results!.first as! ORKChoiceQuestionResult
            let answer7 = Int(truncating: step7Result.choiceAnswers?[0] as! NSNumber)
                        
            let question8 = taskViewController.result.results!.first(where: { $0.identifier == "ODITextChoiceQuestionStep6" }) as! ORKStepResult
            let step8Result = question8.results!.first as! ORKChoiceQuestionResult
            let answer8 = Int(truncating: step8Result.choiceAnswers?[0] as! NSNumber)
            
            let question9 = taskViewController.result.results!.first(where: { $0.identifier == "ODITextChoiceQuestionStep11" }) as! ORKStepResult
            let step9Result = question9.results!.first as! ORKChoiceQuestionResult
            let answer9 = Int(truncating: step9Result.choiceAnswers?[0] as! NSNumber)
            
            //save results
            self.saveAssessmentResult(values: [answer1, answer2, answer3, answer4, answer5, answer6, answer7, answer8, answer9])
        }
        
        //handle result of 6-minutes walk assessment
        if taskIdentifier == ActivityType.sixMinuteWalk.rawValue {
            formatter.dateFormat = "yyyy-MM-dd"
            let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
            let components = calendar.dateComponents([.day, .month, .year], from: startDate as Date)
            var out = formatter.string(from: calendar.date(from: components)!) + " "
            let result = taskViewController.result.stepResult(forStepIdentifier: "fitness.walk")
            let results = result?.results
            if results?.count == 0 {
                return
            }
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
            
            
            out += "\n"
            let old = UserDefaults.standard.object(forKey: "sixMinuteWalk") as! String
            UserDefaults.standard.set(old + out, forKey: "sixMinuteWalk")
            
            
            //controller.appendOutcomeValue(withType: 0, at: IndexPath(item: 0, section: 0), completion: nil)
        }
        
        //handle result of back pain assessment
        if taskIdentifier == ActivityType.backPain.rawValue {
            let pain = taskViewController.result.results!.first(where: { $0.identifier == "backPainStep1" }) as! ORKStepResult
            let painResult = pain.results!.first as! ORKScaleQuestionResult
            let painAnswer = "average:\(Int(truncating: painResult.scaleAnswer!))"
            
            let pain1 = taskViewController.result.results!.first(where: { $0.identifier == "backPainStep2" }) as! ORKStepResult
            let painResult1 = pain1.results!.first as! ORKScaleQuestionResult
            let painAnswer1 = "max:\(Int(truncating: painResult1.scaleAnswer!))"
            
            //save results
            self.saveAssessmentResult(values: [painAnswer, painAnswer1])
        }
    }
    
    func saveAssessmentResult(values: [OCKOutcomeValueUnderlyingType]) {
        if values.count == 0 { return }
        guard
            let event = controller.eventFor(indexPath: IndexPath(item: 0, section: 0)),
            let taskID = (event.task as! OCKTask).localDatabaseID
            else { return }

        var outcomeValues = [OCKOutcomeValue]()
        for value in values {
            outcomeValues.append(OCKOutcomeValue(value))
        }
        
        let outcome = OCKOutcome(taskID: taskID, taskOccurrenceIndex: event.scheduleEvent.occurrence, values: outcomeValues)
        let store = CareStoreReferenceManager.shared.synchronizedStoreManager.store
        store.addAnyOutcome(outcome, callbackQueue: .main) { (result) in
            switch result {
            case .success(_): print("Outcome created")
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
    
    //This method is called when the user taps the card for detail view
    override func didSelectTaskView(_ taskView: UIView & OCKTaskDisplayable, eventIndexPath: IndexPath) {
        return
    }
    
    override func taskView(_ taskView: UIView & OCKTaskDisplayable, didCompleteEvent isComplete: Bool,
                           at indexPath: IndexPath, sender: Any?) {
        
        //if user un-mark the assessment then delete its results from the datastore as well
        if !isComplete {
            super.taskView(taskView, didCompleteEvent: isComplete, at: indexPath, sender: sender)
            //get the event
            guard let event = controller.eventFor(indexPath: indexPath) else { return }
            //if outcome is saved then delete it
            if let outcome = event.outcome {
                controller.store.deleteAnyOutcome(outcome, callbackQueue: .main, completion: nil)
            }
            return
        }
        
        //Start Assessment
        guard let event = controller.eventFor(indexPath: indexPath) else { return }
        guard let task = event.task as? OCKTask else { return }
        
        self.taskIdentifier = task.id
        
        //Check type of assessment and present that assessment
        if task.id == ActivityType.startBackSurvey.rawValue { //start back survey assessment
            let steps = self.createStepsForBackSurveyAssessment()
            
            let surveyTask = ORKOrderedTask(identifier: task.id, steps: steps)
            let surveyViewController = ORKTaskViewController(task: surveyTask, taskRun: nil)
            surveyViewController.delegate = self
            
            //present the survey to the user
            self.present(surveyViewController, animated: true, completion: nil)
        } else if task.id == ActivityType.odiSurvey.rawValue { //start back ODI survey assessment
            let steps = self.createStepsForODISurveyAssessment()
            
            let surveyTask = ORKOrderedTask(identifier: task.id, steps: steps)
            let surveyViewController = ORKTaskViewController(task: surveyTask, taskRun: nil)
            surveyViewController.delegate = self

            //present the survey to the user
            self.present(surveyViewController, animated: true, completion: nil)
        } else if task.id == ActivityType.sixMinuteWalk.rawValue { //start six minutes walk assessment
            let intendedUseDescription = "Fitness is important. Please hold your phone in your non-dominant hand or place it in your pocket while you complete this task."
            
            UIApplication.shared.isIdleTimerDisabled = true
            
            // let speechInstruction = "walk for a bit then stop"
            let task = ORKOrderedTask.fitnessCheck(withIdentifier: "walkingTask",
                                                   intendedUseDescription: intendedUseDescription,
                                                   walkDuration: 360, restDuration: 0, options: [])
            
            let surveyViewController = ORKTaskViewController(task: task, taskRun: nil)
            surveyViewController.delegate = self
            
            //present the survey to the user
            self.present(surveyViewController, animated: true, completion: nil)
        } else if task.id == ActivityType.weight.rawValue { //start weight assessment
            let answerFormat = ORKHealthKitQuantityTypeAnswerFormat(quantityType: quantityType,
                                                                    unit: unit, style: .decimal)
            
            // Create a question.
            let title = NSLocalizedString("Input your weight", comment: "")
            let questionStep = ORKQuestionStep(identifier: "WeightSample",
                                               title: title,
                                               question: title,
                                               answer: answerFormat)
            questionStep.isOptional = false
            
            // Create an ordered task with a single question.
            let task = ORKOrderedTask(identifier: task.id, steps: [questionStep])
            
            let surveyViewController = ORKTaskViewController(task: task, taskRun: nil)
            surveyViewController.delegate = self
            
            //present the survey to the user
            self.present(surveyViewController, animated: true, completion: nil)
        } else if task.id == ActivityType.backPain.rawValue { //start back pain assessment
            let steps = self.createStepsForBackPainAssessment()
            
            let task = ORKOrderedTask(identifier: task.id, steps: steps)
            let surveyViewController = ORKTaskViewController(task: task, taskRun: nil)
            surveyViewController.delegate = self
            
            //present the survey to the user
            self.present(surveyViewController, animated: true, completion: nil)
        }
    }
}

extension AssessmentViewController {
    func createStepsForBackSurveyAssessment() -> [ORKStep] {
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
        
        // Summary step
        let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
        summaryStep.title = "Thank you."
        summaryStep.text = "We appreciate your time."
        steps += [summaryStep]
        
        return steps
    }
    
    func createStepsForODISurveyAssessment() -> [ORKStep] {
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
                                                question: questQuestionStepTitle,
                                                answer: questAnswerFormat)
        questQuestionStep.text = questQuestionStepTitle
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
                                            question: questQuestionStepTitle,
                                            answer: questAnswerFormat)
        questQuestionStep.text = questQuestionStepTitle
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
                                            question: questQuestionStepTitle,
                                            answer: questAnswerFormat)
        questQuestionStep.text = questQuestionStepTitle
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
                                            question: questQuestionStepTitle,
                                            answer: questAnswerFormat)
        questQuestionStep.text = questQuestionStepTitle
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
                                            question: questQuestionStepTitle,
                                            answer: questAnswerFormat)
        questQuestionStep.text = questQuestionStepTitle
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
                                            question: questQuestionStepTitle,
                                            answer: questAnswerFormat)
        questQuestionStep.text = questQuestionStepTitle
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
                                            question: questQuestionStepTitle,
                                            answer: questAnswerFormat)
        questQuestionStep.text = questQuestionStepTitle
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
                                            question: questQuestionStepTitle,
                                            answer: questAnswerFormat)
        questQuestionStep.text = questQuestionStepTitle
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
                                            question: questQuestionStepTitle,
                                            answer: questAnswerFormat)
        questQuestionStep.text = questQuestionStepTitle
        steps += [questQuestionStep]
        
        // Summary step
        let summaryStep = ORKCompletionStep(identifier: "ODISummaryStep")
        summaryStep.title = "Thank you."
        summaryStep.text = "We appreciate your time."
        steps += [summaryStep]
        
        return steps
    }
    
    func createStepsForBackPainAssessment() -> [ORKStep] {
        var steps = [ORKStep]()
        
        // Get the localized strings to use for the task.
        let question = NSLocalizedString("What was your average pain in the last 24 hours?", comment: "")
        let maximumValueDescription = NSLocalizedString("Worst pain imaginable", comment: "")
        let minimumValueDescription = NSLocalizedString("No pain", comment: "")
        
        // Create a question and answer format.
        let answerFormat = ORKScaleAnswerFormat(
            maximumValue: 10,
            minimumValue: 0,
            defaultValue: -1,
            step: 1,
            vertical: false,
            maximumValueDescription: maximumValueDescription,
            minimumValueDescription: minimumValueDescription
        )
        
        let questionStep = ORKQuestionStep(identifier: "backPainStep1",
                                           title: question,
                                           question: question,
                                           answer: answerFormat)
        questionStep.isOptional = false
        steps += [questionStep]
        
        // Get the localized strings to use for the task.
        let question2 = NSLocalizedString("What was your maximum pain in the last 24 hours?", comment: "")
        let questionStep2 = ORKQuestionStep(identifier: "backPainStep2",
                                            title: question2,
                                            question: question2,
                                            answer: answerFormat)
        questionStep2.isOptional = false
        steps += [questionStep2]
        
        return steps
    }
}
