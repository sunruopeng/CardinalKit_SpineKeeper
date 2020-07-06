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
import CareKit

//import Foundation
import AVFoundation
import MediaPlayer
import AVKit

import MessageUI

class ResearchContainerViewController: UIViewController, HealthClientType, MFMailComposeViewControllerDelegate { //MFMessageComposeViewControllerDelegate
    // MARK: HealthClientType
    
    var healthStore: HKHealthStore?
    var sampleData: SampleData?
    let careStoreManager = CareStoreReferenceManager.shared
    var careCardVC : DailyActivitesViewController?
    
    /* Junaid Commnented
    var careCardVC : OCKCareCardViewController?
    var symptomCardVC : OCKSymptomTrackerViewController?
    var insightsVC : OCKInsightsViewController?
 
 */
    var dashboardVC : DashboardTableViewController?

    // MARK: Propertues
    
    var contentHidden = false {
        didSet {
            guard contentHidden != oldValue && isViewLoaded else { return }
            children.first?.view.isHidden = contentHidden
        }
    }
    
    static func imageResize(with img: UIImage, andResizeTo newSize: CGSize) -> UIImage {
        let scale = UIScreen.main.scale
        /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
        //UIGraphicsBeginImageContext(newSize);
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale);
        let rect = CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height)
        img.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage!
    }
    
    required init?(coder aDecoder: NSCoder) {
        //UserDefaults.standard.set(Calendar.autoupdatingCurrent.startOfDay(for: Date()), forKey: "startDate")
        

        if UserDefaults.standard.object(forKey: "startDate") != nil {
            sampleData = SampleData(carePlanStore: careStoreManager.synchronizedStoreManager.store as! OCKStore)
        }
        super.init(coder: aDecoder)
        
        
        careCardVC = createCareCardViewController()
        
        /* Junaid Commnented
         careCardVC = createCareCardViewController()
         symptomCardVC = createSymptomTrackerViewController()
         insightsVC = createInsightsViewController()
         
         */
         // Junaid Commnented
        //careStoreManager.delegate = self
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this line along with setting the global tint in main.storyboard makes the colors consistent everywhere
        //UIView.appearance(whenContainedInInstancesOf: [UIViewController.self]).tintColor = window?.rootViewController?.view.tintColor
//        UIView.appearance().tintColor = self.view.tintColor
        //ORKPasscodeViewController.removePasscodeFromKeychain() // for debugging and to reset the account
        if ORKPasscodeViewController.isPasscodeStoredInKeychain() && UserDefaults.standard.object(forKey: "startDate") != nil {
//            perform(#selector(ResearchContainerViewController.showPasscode), with: nil, afterDelay: 1.0)
        }
        else {
            if ORKPasscodeViewController.isPasscodeStoredInKeychain() {
                ORKPasscodeViewController.removePasscodeFromKeychain()
            }
            toOnboarding()
        }
        /*
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.recipients = ["2063845857"]
        composeVC.body = "I love Swift!"
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        }*/
    }
    
    private func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    //func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    //}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let healthStore = healthStore {
            segue.destination.injectHealthStore(healthStore)
        }
    }
    
    // MARK: Unwind segues
    
    @IBAction func unwindToStudy(_ segue: UIStoryboardSegue) {
        toStudy()
    }
    
    @IBAction func unwindToWithdrawl(_ segue: UIStoryboardSegue) {
        toWithdrawl()
    }
    
    
    fileprivate func createCareCardViewController() -> DailyActivitesViewController {
        let viewController = DailyActivitesViewController(storeManager: CareStoreReferenceManager.shared.synchronizedStoreManager)
        
        viewController.title = "Activities"
         viewController.tabBarItem = UITabBarItem(title: viewController.title, image: UIImage(named:"carecard"), selectedImage: UIImage(named: "carecard-filled"))
        
        return viewController
    }
    
    /* Junaid Commnented
    
    fileprivate func createCareCardViewController() -> OCKCareCardViewController {
        let viewController = OCKCareCardViewController(carePlanStore: CarePlanStoreManager.sharedCarePlanStoreManager.store)
        viewController.glyphType = .heart
        viewController.glyphTintColor = Colors.cardinalRed.color
        //viewController.maskImage = UIImage(named: "heart-gray")
        //viewController.smallMaskImage = UIImage(named: "heart-gray-small")
        //viewController.maskImageTintColor = Colors.cardinalRed.color
        viewController.delegate = self
        
        // Setup the controller's title and tab bar item
        viewController.title = NSLocalizedString("Daily Activities", comment: "")
        viewController.headerTitle = NSLocalizedString("Activity Completion", comment: "")
        viewController.tabBarItem = UITabBarItem(title: viewController.title, image: UIImage(named:"carecard"), selectedImage: UIImage(named: "carecard-filled"))
        return viewController
    }
    fileprivate func createSymptomTrackerViewController() -> OCKSymptomTrackerViewController {
        let viewController = OCKSymptomTrackerViewController(carePlanStore: careStoreManager.store)
        viewController.glyphType = .stethoscope
        viewController.glyphTintColor = Colors.stanfordAqua.color
        //viewController.progressRingTintColor = Colors.stanfordAqua.color
        viewController.delegate = self
        
        // Setup the controller's title and tab bar item
        viewController.title = NSLocalizedString("Symptom Tracker", comment: "")
        viewController.headerTitle = NSLocalizedString("Log Completion", comment: "")
        //viewController.showEdgeIndicators = true
        viewController.tabBarItem = UITabBarItem(title: viewController.title, image: UIImage(named:"CK-symptoms"), selectedImage: UIImage(named: "CK-symptoms-filled"))
        return viewController
    }
    fileprivate func createInsightsViewController() -> OCKInsightsViewController {
        // Create an `OCKInsightsViewController` with sample data.
        let headerTitle = NSLocalizedString("", comment: "")
        let viewController = OCKInsightsViewController(insightItems: careStoreManager.insights, patientWidgets: nil, thresholds: nil, store: careStoreManager.store)
        //let viewController = OCKInsightsViewController(insightItems: careStoreManager.insights, headerTitle: headerTitle, headerSubtitle: "")
        //viewController.showEdgeIndicators = true
        // Setup the controller's title and tab bar item
        viewController.title = NSLocalizedString("Insights", comment: "")
        viewController.tabBarItem = UITabBarItem(title: viewController.title, image: UIImage(named:"tab_dashboard"), selectedImage: UIImage(named: "tab_dashboard_selected"))
        return viewController
    }
 */
 
    
    
    // MARK: Transitions
    
    @objc func showPasscode() {
        let passcodeVC = ORKPasscodeViewController.passcodeAuthenticationViewController(withText: "", delegate: self)
        passcodeVC.modalPresentationStyle = .fullScreen
        present(passcodeVC, animated: false, completion: nil)
    }
    
    func toOnboarding() {
        performSegue(withIdentifier: "toOnboarding", sender: self)
    }
    
    func toStudy() {
        performSegue(withIdentifier: "toStudy", sender: self)
    }
    
    func toWithdrawl() {
        if UserDefaults.standard.integer(forKey: "withdrawn") == 0 {
            let viewController = WithdrawViewController()
            viewController.delegate = self
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true, completion: nil)
        }
        
        /* Junaid Commnented
         if UserDefaults.standard.integer(forKey: "withdrawn") == 1 {
         sampleData?.resetStore(store: CarePlanStoreManager.sharedCarePlanStoreManager.store)
         ORKPasscodeViewController.removePasscodeFromKeychain()
         toOnboarding()
         }
         */
    }
}

extension ResearchContainerViewController: ORKTaskViewControllerDelegate {
    public func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        UIApplication.shared.isIdleTimerDisabled = false
        // Check if the user has finished the `WithdrawViewController`.
        if taskViewController is WithdrawViewController {
            /*
                If the user has completed the withdrawl steps, remove them from
                the study and transition to the onboarding view.
            */
            if reason == .completed {
                ASVerificationStepViewController.doWithdrawl(controller: self)
            }
            // Dismiss the `WithdrawViewController`.
            dismiss(animated: true, completion: nil)
        }
        
        //FIX!!
        // needs to grab fro healthkit when symptomtracker tab is clicked and needs to put into healthkit at the right date
        // needs to do this for appropriate carecard guys too (activity)
        // needs to always also save to the careplanstore
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        // Make sure the reason the task controller finished is that it was completed.
        guard reason == .completed else { return }
        
        // Determine the event that was completed and the `SampleAssessment` it represents.
        
        /* Junaid Commnented
        guard let event = symptomCardVC!.lastSelectedAssessmentEvent,
            let activityType = ActivityType(rawValue: event.activity.identifier),
            let sampleAssessment = sampleData?.activityWithType(activityType) as? Assessment else { return }
        
        // Build an `OCKCarePlanEventResult` that can be saved into the `OCKCarePlanStore`.
        let carePlanResult = sampleAssessment.buildResultForCarePlanEvent(event, taskResult: taskViewController.result)
        
        // Check assessment can be associated with a HealthKit sample.
        if let healthSampleBuilder = sampleAssessment as? HealthSampleBuilder {
            // Build the sample to save in the HealthKit store.
            let sample = healthSampleBuilder.buildSampleWithTaskResult(taskViewController.result)
            let sampleTypes: Set<HKSampleType> = [sample.sampleType]
            
            // Requst authorization to store the HealthKit sample.
            let healthStore = HKHealthStore()
            healthStore.requestAuthorization(toShare: sampleTypes, read: sampleTypes, completion: { success, _ in
                // Check if authorization was granted.
                if !success {
                    /*
                     Fall back to saving the simple `OCKCarePlanEventResult`
                     in the `OCKCarePlanStore`.
                     */
                    self.completeEvent(event, inStore: self.careStoreManager.store, withResult: carePlanResult)
                    return
                }
                
                // Save the HealthKit sample in the HealthKit store.
                healthStore.save(sample, withCompletion: { success, _ in
                    if success {
                        /*
                         The sample was saved to the HealthKit store. Use it
                         to create an `OCKCarePlanEventResult` and save that
                         to the `OCKCarePlanStore`.
                         */
                        let healthKitAssociatedResult = OCKCarePlanEventResult(
                            quantitySample: sample,
                            quantityStringFormatter: nil,
                            display: healthSampleBuilder.unit,
                            displayUnitStringKey: healthSampleBuilder.localizedUnitForSample(sample),
                            userInfo: nil
                        )
                        
                        self.completeEvent(event, inStore: self.careStoreManager.store, withResult: healthKitAssociatedResult)
                    }
                    else {
                        /*
                         Fall back to saving the simple `OCKCarePlanEventResult`
                         in the `OCKCarePlanStore`.
                         */
                        self.completeEvent(event, inStore: self.careStoreManager.store, withResult: carePlanResult)
                    }
                    
                })
            })
        }
        else {
            // Update the event with the result.
            completeEvent(event, inStore: careStoreManager.store, withResult: carePlanResult)
        }
 
 */

    }
    // MARK: Convenience
    /* Junaid Commnented
    fileprivate func completeEvent(_ event: OCKCarePlanEvent, inStore store: OCKCarePlanStore, withResult result: OCKCarePlanEventResult) {
        store.update(event, with: result, state: .completed) { success, _, error in
            if !success {
                print(error?.localizedDescription as Any)
            }
        }
    }
 */

}


extension ResearchContainerViewController: ORKPasscodeDelegate {

    public func passcodeViewControllerDidFinish(withSuccess viewController: UIViewController) {
        dismiss(animated: true, completion: nil)
        toStudy()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.syncDataWithServer()
    }
    
    public func passcodeViewControllerDidFailAuthentication(_ viewController: UIViewController) {
        
        
    }
}

// MARK: CarePlanStoreManagerDelegate

/* Junaid Commnented
extension ResearchContainerViewController: CarePlanStoreManagerDelegate {
    
    /// Called when the `CarePlanStoreManager`'s insights are updated.
    /* Junaid Commnedted
     
     func carePlanStoreManager(_ manager: CarePlanStoreManager, didUpdateInsights insights: [OCKInsightItem]) {
     // Update the insights view controller with the new insights.
     insightsVC?.items = insights
     }
     
     */
}

 */






// need carecardelegate since we can have assessments in carecard too unlike sampleProj
// add symptom delegate and orktask delegate
// FIX!!!

/*  Junaid Commnented
extension ResearchContainerViewController: OCKCareCardViewControllerDelegate {

    
    func careCardViewController(_ viewController: OCKCareCardViewController, shouldHandleEventCompletionFor interventionActivity: OCKCarePlanActivity) -> Bool {
        //false if special activity
        
        return true
    }
    
    /*
    func careCardViewController(_ viewController: OCKCareCardViewController, didSelectButtonWithInterventionEvent interventionEvent: OCKCarePlanEvent) {
        
    }*/
    
    func careCardViewController(_ viewController: OCKCareCardViewController, didSelectRowWithInterventionActivity interventionActivity: OCKCarePlanActivity) {
        //print(interventionActivity.userInfo?["hasTask"] as? String)
        if (interventionActivity.userInfo?["hasTask"] as? String) == nil{
            let temp = OCKCareCardDetailViewController(intervention: interventionActivity)
            viewController.navigationController?.pushViewController(temp, animated: true)
            return
        }
        
        if (interventionActivity.userInfo?["hasTask"] as? String) == "video" {
            let player = AVPlayer(url: Bundle.main.url(forResource: (interventionActivity.userInfo?["video"] as? String), withExtension: "mp4")!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true){
                do {
                    //try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                    if #available(iOS 10.0, *) {
                        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                    } else {
                        AVAudioSession.sharedInstance().perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.playback)
                    }
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch {
                    print(error)
                }
                playerViewController.player!.play()
            }
            return
        }
        
        if (interventionActivity.userInfo?["hasTask"] as? String) == "image" {
            let careCardImageView = ImageScrollView(frame: CGRect.init(x: viewController.view.frame.minX, y: 1, width: viewController.view.frame.width, height: viewController.view.frame.height))
            //let careCardImageView = ImageScrollView(frame: self.view.frame)
            let vc = UIViewController()
            vc.view.addSubview(careCardImageView)
            let image = ResearchContainerViewController.imageResize(with: UIImage(named: (interventionActivity.userInfo?["image"] as? String)!)!, andResizeTo: careCardImageView.frame.size)
            careCardImageView.display(image: image)
            careCardImageView.adjustFrameToCenter()
            careCardImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin];
            vc.view.autoresizesSubviews = true
            viewController.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        if (interventionActivity.userInfo?["hasTask"] as? String) == "html" {
            let baseURL = Bundle.main.resourceURL
            let vc = UIViewController()
            let htmlname = interventionActivity.userInfo?["html"] as? String
            let htmlFile = Bundle.main.path(forResource: htmlname, ofType: "html")
            let html = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
            let webView = UIWebView(frame: self.view.frame)
            webView.loadHTMLString(html!, baseURL: baseURL)
            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin];
            vc.view.addSubview(webView)
            vc.view.autoresizesSubviews = true
            viewController.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        
//        // Lookup the assessment the row represents.
//        guard let activityType = ActivityType(rawValue: interventionActivity.identifier) else { return }
//        guard let sampleAssessment = sampleData.activityWithType(activityType) as? Assessment else { return }
//
//
//        // Show an `ORKTaskViewController` for the assessment's task.
//        let taskViewController = ORKTaskViewController(task: sampleAssessment.task(), taskRun: nil)
//        taskViewController.delegate = self
//
//        if activityType == ActivityType.voiceAnalysis {
//            do {
//                let defaultFileManager = FileManager.default
//
//                // Identify the documents directory.
//                let documentsDirectory = try defaultFileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//
//                // Create a directory based on the `taskRunUUID` to store output from the task.
//                let outputDirectory = documentsDirectory.appendingPathComponent(taskViewController.taskRunUUID.uuidString)
//                try defaultFileManager.createDirectory(at: outputDirectory, withIntermediateDirectories: true, attributes: nil)
//
//                taskViewController.outputDirectory = outputDirectory
//            }
//            catch let error as NSError {
//                fatalError("The output directory for the task with UUID: \(taskViewController.taskRunUUID.uuidString) could not be created. Error: \(error.localizedDescription)")
//            }
//        }
//
//        // TODO have a completion block to fill in the bubble
//        present(taskViewController, animated: true, completion: nil)
    }
}

 */

/* Junaid Commnented
extension ResearchContainerViewController: OCKSymptomTrackerViewControllerDelegate {
    
    /// Called when the user taps an assessment on the `OCKSymptomTrackerViewController`.
    func symptomTrackerViewController(_ viewController: OCKSymptomTrackerViewController, didSelectRowWithAssessmentEvent assessmentEvent: OCKCarePlanEvent) {
        // Lookup the assessment the row represents.
        guard let activityType = ActivityType(rawValue: assessmentEvent.activity.identifier) else { return }
        guard let sampleAssessment = sampleData?.activityWithType(activityType) as? Assessment else { return }
        
        /*
         Check if we should show a task for the selected assessment event
         based on its state.
         */
        guard assessmentEvent.state == .initial ||
            assessmentEvent.state == .notCompleted ||
            (assessmentEvent.state == .completed && assessmentEvent.activity.resultResettable) else { return }
        
        // Show an `ORKTaskViewController` for the assessment's task.
        let taskViewController = ORKTaskViewController(task: sampleAssessment.task(), taskRun: nil)
        taskViewController.delegate = self
        taskViewController.outputDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        taskViewController.modalPresentationStyle = .fullScreen
        present(taskViewController, animated: true, completion: nil)
    }
}

 */
