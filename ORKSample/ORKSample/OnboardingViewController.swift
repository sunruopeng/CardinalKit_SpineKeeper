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

import UIKit
import ResearchKit

class OnboardingViewController: UIViewController {
    // MARK: IB actions
    
    @IBAction func joinButtonTapped(_ sender: UIButton) {
        
        let eligProcessStep = makeEligibilityStep()
        
        let consentDocument = ConsentDocument()
        let htmlFile = Bundle.main.path(forResource: "consent", ofType: "html")
        let htmlContent = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
        consentDocument.htmlReviewContent = htmlContent
        let consentStep = ORKVisualConsentStep(identifier: "VisualConsentStep",
                                               document: consentDocument)
        let signature = consentDocument.signatures!.first!
        
        let healthDataStep = HealthDataStep(identifier: "Health")
        
        let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep",
                                                     signature: signature,
                                                     in: consentDocument)
        reviewConsentStep.title = "Consent"
        reviewConsentStep.text = "Review the consent form."
        reviewConsentStep.reasonForConsent = "Consent to join the Stanford SpineKeeper Study."
        
        let registerStep = ORKRegistrationStep(identifier: "RegistrationStep",
                                               title: "Account Registration",
                                               text: "Please make an account to be part of our study.",
                                               options: [ORKRegistrationStepOption.includeDOB,
                                                        ORKRegistrationStepOption.includeGender])
                                                        //ORKRegistrationStepOption.includeGivenName,
                                                        //ORKRegistrationStepOption.includeFamilyName,
        
        
        let verifyStep = ORKVerificationStep(identifier: "VerificationStep",
                                             text: "Please check your email and click the confirmation link in it to confirm you're part of our study. Then tap Continue.",
                                             verificationViewControllerClass: ASVerificationStepViewController.self)
        
        
        // don't need login
        //let loginStep = ORKLoginStep.init(identifier: "sdf", title: "sdf", text: "sdf", loginViewControllerClass: ASLoginStepViewController.self)
        
        let passcodeStep = ORKPasscodeStep(identifier: "Passcode")
        passcodeStep.passcodeType = ORKPasscodeType.type4Digit
        passcodeStep.text = "Now you will create a passcode to identify yourself to the app and protect access to information you've entered."
        
        let completionStep = ORKCompletionStep(identifier: "CompletionStep")
        completionStep.title = "Welcome aboard!"
        completionStep.text = "Thank you for joining the Stanford SpineKeeper Study."
        
        // for server mode
        var steps = [eligProcessStep,
                 consentStep,
                 reviewConsentStep,
                 healthDataStep,
                 registerStep,
                 verifyStep,
                 passcodeStep,
                 completionStep]
        
        // for non-server mode
        steps = [eligProcessStep,
                     consentStep,
                     reviewConsentStep,
                     healthDataStep,
                     registerStep,
                     passcodeStep,
                     completionStep]
        
        //let backPainStep = makeBackPainTask()
        //steps += [backPainStep]
        let backSurveyStep = makeBackSurveyTask()
        steps += [backSurveyStep]
        let demoStep = makeDemographicsTask()
        steps += [demoStep]
        let ODIStep = makeODITask()
        steps += [ODIStep]
        let tutStep = makeTutorialStep()
        steps += [tutStep]
        let scheduleStep = makeChooseActivityScheduleStep()
        steps += [scheduleStep]
        
        //DEBUG!!!
        //steps = [reviewConsentStep,healthDataStep,registerStep,passcodeStep,completionStep,scheduleStep]
        
        let orderedTask = ORKOrderedTask(identifier: "Join", steps: steps)
        let taskViewController = ORKTaskViewController(task: orderedTask, taskRun: nil)
        taskViewController.delegate = self
        taskViewController.modalPresentationStyle = .fullScreen
        present(taskViewController, animated: true, completion: nil)
    }
    
    func makeChooseActivityScheduleStep() -> ORKStep {
        let ques = "Select the type of activity schedule you want to participate in, or let us choose randomly for you. Once you select a choice, please wait for a minute while we set up your app."
        let textChoices = [
            ORKTextChoice(text: "Relaxed", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Active", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Choose for me", value: 2 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        let answerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
        let step = ORKQuestionStep(identifier: "ScheduleQuestionStep",
                                   title: "Activity Schedule",
                                   question: nil,
                                   answer: answerFormat)
        step.text = ques
        step.isOptional = false
        return step
    }
    
    func makeTutorialStep() -> ORKNavigablePageStep {
        
        let tempStep = ORKInstructionStep.init(identifier: "tutorialStep1")
        tempStep.title = "All Set!"
        tempStep.detailText = "We'll recommend a daily list of things to do in your Daily Activities Tab.\n\nFor each activity, you can tap the arrow on the right to see more detail. Tap the colored bubbles below each activity as you complete them."
        //tempStep.image = ResearchContainerViewController.imageResize(with: UIImage(named: "CareCard-Intro")!, andResizeTo: CGSize.init(width: 100.0, height: 100.0))
        tempStep.image = UIImage(named: "tutorial_activity")
        
        let tempStep2 = ORKInstructionStep.init(identifier: "tutorialStep2")
        tempStep2.title = " "
        tempStep2.detailText = "We'll also ask you to log your daily symptoms in the Symptom Tracker tab.\n\nFor each task, you should tap the arrow on the right to log your symptoms."
        //tempStep2.image = ResearchContainerViewController.imageResize(with: UIImage(named: "Symptom-Intro")!, andResizeTo: CGSize.init(width: 100.0, height: 100.0))
        tempStep2.image = UIImage(named: "tutorial_symptoms")
        
        let completionTask = ORKNavigableOrderedTask(identifier: "tutorialTask", steps: [tempStep, tempStep2])
        let completeStep = ORKNavigablePageStep(identifier: "TutorialStep", pageTask: completionTask)
        completeStep.title = "All Set!"
        return completeStep
    }
    
    func makeBackSurveyTask() -> ORKNavigablePageStep {
        
        let keelesteps = (StartBackSurvey().task() as! ORKOrderedTask).steps
        let steps = Array(keelesteps[0..<keelesteps.endIndex-1])
        
        let backPainTask = ORKNavigableOrderedTask(identifier: "keeleTask", steps: steps)
        let backPainStep = ORKNavigablePageStep(identifier: "keeleStep", pageTask: backPainTask)
        backPainStep.title = "The Keele Start Back Screening Tool"
        return backPainStep
    }
    
    func makeODITask() -> ORKNavigablePageStep {
        let keelesteps = (ODISurvey().task() as! ORKOrderedTask).steps
        let steps = Array(keelesteps[0..<keelesteps.endIndex-1])
        
        let backPainTask = ORKNavigableOrderedTask(identifier: "ODITask", steps: steps)
        let backPainStep = ORKNavigablePageStep(identifier: "ODIStep", pageTask: backPainTask)
        backPainStep.title = "Oswestry Disability Index"
        return backPainStep
    }
    
    func makeBackPainTask() -> ORKNavigablePageStep {
        var steps = [ORKStep]()
        let instructionStep = ORKInstructionStep(identifier: "IntroBackStep")
        instructionStep.title = "Today's Pain"
        instructionStep.text = "Thinking about today, please answer the next two questions to the best of your ability:"
        steps += [instructionStep]
        let yo = (BackPain().task() as! ORKOrderedTask).steps
        for step in steps { step.isOptional = true}
        steps += yo
        let backPainTask = ORKNavigableOrderedTask(identifier: "backPainTask", steps: steps)
        let backPainStep = ORKNavigablePageStep(identifier: "backPainStep", pageTask: backPainTask)
        return backPainStep
    }
    
    func makeDemographicsTask() -> ORKNavigablePageStep {
        var steps = [ORKStep]()
        let instructionStep = ORKInstructionStep(identifier: "IntroDemoStep")
        instructionStep.title = "Demographics"
        instructionStep.text = "Please tell us a little bit about yourself by answering the following questions:"

        // Create a question.
        let title0 = NSLocalizedString("Input your weight", comment: "")
        let answerFormat = ORKWeightAnswerFormat.init(measurementSystem: ORKMeasurementSystem.local)
        let questionStep0 = ORKQuestionStep(identifier: "weightStep",
                                            title: title0,
                                            question: title0,
                                            answer: answerFormat)
        questionStep0.text = title0
        questionStep0.isOptional = true
        steps += [questionStep0]
        
        // Create a question.
        let title = NSLocalizedString("Input your height", comment: "")
        let answerFormat1 = ORKHeightAnswerFormat(measurementSystem: ORKMeasurementSystem.local)
        let questionStep = ORKQuestionStep(identifier: "heightStep",
                                           title: title,
                                           question: title,
                                           answer: answerFormat1)
        questionStep.text = title
        questionStep.isOptional = true
        steps += [questionStep]
        
        let demoTask = ORKNavigableOrderedTask(identifier: "demoTask", steps: steps)
        let demoStep = ORKNavigablePageStep(identifier: "demoStep", pageTask: demoTask)
        demoStep.title = "Demographics"
        return demoStep
    }
    
    func makeEligibilityStep() -> ORKNavigablePageStep {
        let eligQues = "Please verify the following:\n\n\u{2022} You are at least 18 years old\n\n\u{2022} You reside in the US \n\n\u{2022} You can read and understand English in order to provide informed consent and follow this app's instructions"
        let eligTextChoices = [
            ORKTextChoice(text: "Yes, these are ALL true", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "No", value: 1 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        let eligAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: eligTextChoices)
        let eligStep = ORKQuestionStep(identifier: "EligibilityQuestionStep",
                                       title: "Eligiblity",
                                       question: "Eligiblity",
                                       answer: eligAnswerFormat)
        eligStep.text = eligQues
        eligStep.isOptional = false
        
        // change both success and failure to be of type completion subclasssed
        let eligFailureStep = ORKInstructionStep(identifier:"EligibilityFailureStep")
        eligFailureStep.title = "Sorry"
        eligFailureStep.text = "You aren't eligible for this study."
        //eligFailureStep.image = UIImage.init(named: "13_RiskToPrivacy")
        
        let eligQues2 = "Please verify the following:\n\n\u{2022} You DO NOT have any serious chronic medical issues that may limit your ability to participate in physical therapy and home exercise or make participation in physical therapy and home exercise medically inadvisable. This includes cancer, severe arthritis, neuropathy or other neuromuscular disease, angina, cardiovascular disease, pulmonary disease, stroke or other neurological disorder, or peripheral vascular disease\n\n\u{2022} You ARE NOT pregnant, incarcerated, or decisionally impaired"
        
        let eligTextChoices2 = [
            ORKTextChoice(text: "Yes, these are ALL true", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "No", value: 1 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        let eligAnswerFormat2 = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: eligTextChoices2)
        let eligStep2 = ORKQuestionStep(identifier: "EligibilityQuestionStep2",
                                        title: "Eligiblity",
                                        question: "Eligiblity",
                                        answer: eligAnswerFormat2)
        eligStep2.text = eligQues2
        eligStep2.isOptional = false
        
        let eligSuccessStep = ORKInstructionStep(identifier:"EligibilitySuccessStep")
        eligSuccessStep.text = "Great, you're eligible for the study!"
        eligSuccessStep.detailText = "Let's continue."
        
        let resultSelector = ORKResultSelector(stepIdentifier: "EligibilityQuestionStep", resultIdentifier: "EligibilityQuestionStep")
        let predicate = ORKResultPredicate.predicateForChoiceQuestionResult(with: resultSelector, expectedAnswerValue: 0 as NSCoding & NSCopying & NSObjectProtocol)
        let eligPredicateRule = ORKPredicateStepNavigationRule(resultPredicatesAndDestinationStepIdentifiers: [(predicate, "EligibilityQuestionStep2")])
        
        let resultSelector2 = ORKResultSelector(stepIdentifier: "EligibilityQuestionStep2", resultIdentifier: "EligibilityQuestionStep2")
        let predicate2 = ORKResultPredicate.predicateForChoiceQuestionResult(with: resultSelector2, expectedAnswerValue: 1 as NSCoding & NSCopying & NSObjectProtocol)
        let eligPredicateRule2 = ORKPredicateStepNavigationRule(resultPredicatesAndDestinationStepIdentifiers: [(predicate2, "EligibilityFailureStep")])
        
        let eligProcessTask = ORKNavigableOrderedTask(identifier: "eligTask", steps: [eligStep, eligFailureStep, eligStep2, eligSuccessStep])
        eligProcessTask.setNavigationRule(eligPredicateRule, forTriggerStepIdentifier: "EligibilityQuestionStep")
        eligProcessTask.setNavigationRule(eligPredicateRule2, forTriggerStepIdentifier: "EligibilityQuestionStep2")
        eligProcessTask.setNavigationRule(ORKDirectStepNavigationRule(destinationStepIdentifier: "EligibilityQuestionStep"),
                                          forTriggerStepIdentifier: "EligibilityFailureStep")
        let eligProcessStep = ORKNavigablePageStep(identifier: "eligProcessStep", pageTask: eligProcessTask)
        eligProcessStep.title = "Eligiblity"
        return eligProcessStep
    }
}


extension OnboardingViewController : ORKTaskViewControllerDelegate {
    /*
    func taskViewController(_ taskViewController: ORKTaskViewController, shouldPresent step: ORKStep) -> Bool {
    }
    
    func taskViewControllerShouldConfirmCancel(_ taskViewController: ORKTaskViewController) -> Bool {
    }
    
    func taskViewControllerSupportsSaveAndRestore(_ taskViewController: ORKTaskViewController) -> Bool {
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, hasLearnMoreFor step: ORKStep) -> Bool {
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, recorder: ORKRecorder, didFailWithError error: Error) {
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, learnMoreForStep stepViewController: ORKStepViewController) {
    }
 */
    
    // this happens at the very end
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        switch reason {
            case .completed:
                // save ConsentreviewStep results - first name, last name, start data
                if let result = taskViewController.result.stepResult(forStepIdentifier: "ConsentReviewStep"),
                let results = result.results,
                let sigResult = results.first as? ORKConsentSignatureResult,
                let sig = sigResult.signature,
                let firstName = sig.givenName,
                let lastName = sig.familyName {
                    UserDefaults.standard.set(firstName, forKey: "firstName")
                    UserDefaults.standard.set(lastName, forKey: "lastName")
                    let calendar = Calendar.autoupdatingCurrent
                    UserDefaults.standard.set(calendar.startOfDay(for: Date()), forKey: "startDate")
                    UserDefaults.standard.set("", forKey: "sixMinuteWalk")
                    UserDefaults.standard.set("", forKey: "startBackSurvey")
                    UserDefaults.standard.set("", forKey: "odiSurvey")
                    let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
                    var dict:[String: Bool] = [:]
                    for i in 0..<28 {
                        dict[calendar.date(byAdding: .day, value: i, to: startDate)!.description] = false
                    }
                    UserDefaults.standard.set(dict, forKey: "datesSynced")
                    let temp = Int(arc4random_uniform(UInt32(2)))
                    if temp == 0 {
                        UserDefaults.standard.set(temp, forKey: "activityScheduleIndex")
                    }
                    else {
                        UserDefaults.standard.set(temp+1, forKey: "activityScheduleIndex")
                    }
                    //UserDefaults.standard.set(0, forKey: "activityScheduleIndex")
                }
                //save RegistrationStep results - DOB, startDate, email, gender
                if let result = taskViewController.result.stepResult(forStepIdentifier: "RegistrationStep"),
                let dob = result.result(forIdentifier: ORKRegistrationFormItemIdentifierDOB),
                let email = result.result(forIdentifier: ORKRegistrationFormItemIdentifierEmail),
                let gender = result.result(forIdentifier: ORKRegistrationFormItemIdentifierGender)
                {
                    UserDefaults.standard.set((dob as! ORKDateQuestionResult).dateAnswer, forKey: "dateOfBirth")
                    UserDefaults.standard.set(Date(), forKey: "startDate")
                    UserDefaults.standard.set((email as! ORKTextQuestionResult).textAnswer, forKey: "email")
                    UserDefaults.standard.set((gender as! ORKChoiceQuestionResult).choiceAnswers?[0] as! String, forKey: "gender")
                }
                if let result = taskViewController.result.stepResult(forStepIdentifier: "ScheduleQuestionStep"),
                let results = result.results,
                let choiceResult = results.first as? ORKChoiceQuestionResult,
                    let choice = choiceResult.choiceAnswers?.first as! Int? {
                    var temp = choice
                    if choice == 2 { temp = Int(arc4random_uniform(UInt32(2))) }
                    if temp == 0 { UserDefaults.standard.set(temp, forKey: "activityScheduleIndex") }
                    else { UserDefaults.standard.set(temp+1, forKey: "activityScheduleIndex") }
                }
                if let taskResult = taskViewController.result.stepResult(forStepIdentifier: "keeleStep") {
                    let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    var out = formatter.string(from: startDate) + " "
                    var result = taskResult.result(forIdentifier: "BooleanQuestionStep.BooleanQuestionStep")
                    var r = result as! ORKBooleanQuestionResult
                    out += (r.booleanAnswer ?? -1).stringValue
                    out += " "
                    for i in 1...7 {
                        result = taskResult.result(forIdentifier: "BooleanQuestionStep" + String(i) + ".BooleanQuestionStep" + String(i))
                        r = result as! ORKBooleanQuestionResult
                        out += (r.booleanAnswer ?? -1).stringValue
                        out += " "
                    }
                    let result2 = taskResult.result(forIdentifier: "TextChoiceQuestionStep.TextChoiceQuestionStep")
                    let r2 = result2 as! ORKChoiceQuestionResult
                    if r2.choiceAnswers != nil {
                        out += r2.description.split(separator: "\n")[2].trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    else{
                        out += "-1"
                    }
                    let old = UserDefaults.standard.object(forKey: "startBackSurvey") as! String
                    UserDefaults.standard.set(old + out, forKey: "startBackSurvey")
                }
                if let taskResult = taskViewController.result.stepResult(forStepIdentifier: "ODIStep") {
                    let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    var out = formatter.string(from: startDate) + " "
                    
                    var result = taskResult.result(forIdentifier: "ODITextChoiceQuestionStep.ODITextChoiceQuestionStep")
                    var r = result as! ORKChoiceQuestionResult
                    if r.choiceAnswers != nil {
                        out += r.description.split(separator: "\n")[2].trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    else{
                        out += "-1"
                    }
                    out += " "
                    for i in [1,2,3,10,4,5,6,11] {
                        result = taskResult.result(forIdentifier: "ODITextChoiceQuestionStep" + String(i) + ".ODITextChoiceQuestionStep" + String(i))
                        r = result as! ORKChoiceQuestionResult
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
                }
                
                
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.containerViewController?.sampleData = SampleData(carePlanStore: (appDelegate.containerViewController?.careStoreManager.store)!)
                performSegue(withIdentifier: "unwindToStudy", sender: nil)
            
            case .discarded, .failed, .saved:
                dismiss(animated: true, completion: nil)
        @unknown default:
            print("Default Case")
        }
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, viewControllerFor step: ORKStep) -> ORKStepViewController? {
        if step is HealthDataStep {
            let healthStepViewController = HealthDataStepViewController(step: step)
            return healthStepViewController
        }
        return nil
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, stepViewControllerWillDisappear stepViewController: ORKStepViewController, navigationDirection direction: ORKStepViewControllerNavigationDirection) {
        /*
        if stepViewController is ORKVerificationStepViewController {
            let result = taskViewController.result.stepResult(forStepIdentifier: "VerifyStep")
            taskViewController.suspend()
            // check
        }
         */
        
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, stepViewControllerWillAppear stepViewController: ORKStepViewController) {
        // need email for verification step
        if stepViewController is ORKVerificationStepViewController {
            if let result = taskViewController.result.stepResult(forStepIdentifier: "ConsentReviewStep"),
                let results = result.results,
                let sigResult = results.first as? ORKConsentSignatureResult,
                let sig = sigResult.signature,
                let firstName = sig.givenName,
                let lastName = sig.familyName {
                UserDefaults.standard.set(firstName, forKey: "firstName")
                UserDefaults.standard.set(lastName, forKey: "lastName")
            }
            
            if let result = taskViewController.result.stepResult(forStepIdentifier: "RegistrationStep"),
            let dob = result.result(forIdentifier: ORKRegistrationFormItemIdentifierDOB),
            let email = result.result(forIdentifier: ORKRegistrationFormItemIdentifierEmail),
            (email as! ORKTextQuestionResult).textAnswer != nil {
                UserDefaults.standard.set((dob as! ORKDateQuestionResult).dateAnswer, forKey: "dateOfBirth")
                UserDefaults.standard.set((email as! ORKTextQuestionResult).textAnswer, forKey: "email")
                (stepViewController as! ORKVerificationStepViewController).resendEmailButtonTapped()
            }
        }
    }
    
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didChange result: ORKTaskResult) {
        /*
        if let result = result.stepResult(forStepIdentifier: "RegistrationStep"),
            let email = result.result(forIdentifier: ORKRegistrationFormItemIdentifierEmail),
            (email as! ORKTextQuestionResult).textAnswer != nil
        {
            UserDefaults.standard.set((email as! ORKTextQuestionResult).textAnswer, forKey: "email")
        }
         */
    }
}
