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

import Foundation
import UIKit
import ResearchKit
import HealthKit
import AVKit
import Zip
import MessageUI
import WebKit

class ProfileViewController: UITableViewController, HealthClientType, MFMailComposeViewControllerDelegate {
    // MARK: Properties
    
    // dob/age, leave study, change passcode, view tutorial, review consent, permissions, privacy, licenses
    let sections : [String] = ["Personal Info", "Settings", "Help", "Legal"]
    let items : [[String]] = [   ["Email", "Gender", "Date of Birth"],
                ["Change Passcode", "Email Data", "Leave Study"], //"Permissions"
                ["Tutorial", "Introduction Video", "Review Consent"],
                ["Privacy Policy", "Licenses"]
            ]
    
    
    @IBOutlet var nameLabel: UILabel!
    let healthObjectTypes = [
        HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
    ]
    
    var healthStore: HKHealthStore?
    
    @IBOutlet var applicationNameLabel: UILabel!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = (UserDefaults.standard.object(forKey: "firstName") as! String)
            + " "
            + (UserDefaults.standard.object(forKey: "lastName") as! String)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.01
        
        healthStore = HKHealthStore()
        guard let healthStore = healthStore else { fatalError("healhStore not set") }
        
        // Ensure the table view automatically sizes its rows.
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 25
        tableView.sectionFooterHeight = 25
        
        
        // remove the extra spearators after content is done
        self.view.backgroundColor = UIColor.white
        self.tableView.backgroundColor = Colors.stanfordLightTan.color
        self.tableView.tableFooterView = UIView()

        // Request authrization to query the health objects that need to be shown.
        let typesToRequest = Set<HKObjectType>(healthObjectTypes)
        healthStore.requestAuthorization(toShare: nil, read: typesToRequest) { authorized, error in
            guard authorized else { return }
            
            // Reload the table view cells on the main thread.
            OperationQueue.main.addOperation() {
                let allRowIndexPaths = self.healthObjectTypes.enumerated().map { (index, element) in return IndexPath(row: index, section: 0) }
                self.tableView.reloadRows(at: allRowIndexPaths, with: .automatic)
            }
        }
    }
    
    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileStaticTableViewCell.reuseIdentifier, for: indexPath) as? ProfileStaticTableViewCell else { fatalError("Unable to dequeue a ProfileStaticTableViewCell") }
        
        cell.titleLabel.text = items[indexPath.section][indexPath.row]
        cell.valueLabel.text = ""
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.valueLabel.text = UserDefaults.standard.object(forKey: "email") as? String
            case 1:
                cell.valueLabel.text = UserDefaults.standard.object(forKey: "gender") as? String
            case 2:
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale.current
                dateFormatter.dateStyle = DateFormatter.Style.short
                cell.valueLabel.text = dateFormatter.string(from: (UserDefaults.standard.object(forKey: "dateOfBirth") as! Date))
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 2:
                cell.titleLabel.textColor = Colors.red.color
            default:
                 break
            }
        default:
            break
        }
        
        
        
        /*
        let objectType = healthObjectTypes[(indexPath as NSIndexPath).row]
        
        switch(objectType.identifier) {
            case HKCharacteristicTypeIdentifier.dateOfBirth.rawValue:
                configureCellWithDateOfBirth(cell)
            
            case HKQuantityTypeIdentifier.height.rawValue:
                let title = NSLocalizedString("Height", comment: "")
                configureCell(cell, withTitleText: title, valueForQuantityTypeIdentifier: objectType.identifier)
                
            case HKQuantityTypeIdentifier.bodyMass.rawValue:
                let title = NSLocalizedString("Weight", comment: "")
                configureCell(cell, withTitleText: title, valueForQuantityTypeIdentifier: objectType.identifier)
            
            default:
                fatalError("Unexpected health object type identifier - \(objectType.identifier)")
        }
         */

        return cell
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let cell = sender as? UITableViewCell {
            let indexPath = self.tableView.indexPath(for: cell)!
            switch indexPath.section {
            case 2:
                if indexPath.row == 2{
                    return true
                }
            case 3:
                return true
            default:
                return false
            }
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            let indexPath = self.tableView.indexPath(for: cell)!
            let section = indexPath.section
            let index = indexPath.row
            let detailVC = segue.destination
            let baseURL = Bundle.main.resourceURL?.appendingPathComponent("HTMLContent")
            var htmlname = ""
            if section == 3 && index == 1 {
                htmlname = "Legal"
            }
            else if section == 3 && index == 0 {
                htmlname = "PrivacyPolicy"
            }
            else if section == 2 && index == 2 {
                htmlname = "consent"
            }
            else {return }
            let htmlFile = Bundle.main.path(forResource: htmlname, ofType: "html")
            let html = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
            let webView = WKWebView(frame: self.view.frame)
            webView.loadHTMLString(html!, baseURL: baseURL)
            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin];
            detailVC.view.addSubview(webView)
            detailVC.view.autoresizesSubviews = true
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            let passcodeVC = ORKPasscodeViewController.passcodeEditingViewController(withText: "",
                                                                                     delegate: self,
                                                                                     passcodeType: ORKPasscodeType.type4Digit)
            passcodeVC.modalPresentationStyle = .fullScreen
            self.present(passcodeVC, animated: true, completion: nil)
        }
        
        if indexPath.section == 1 && indexPath.row == 2 {
            self.performSegue(withIdentifier: "unwindToWithdrawlSegue", sender: self)
        }
        if indexPath.section == 1 && indexPath.row == 1 {
            
            
            let mailComposeViewController = self.configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            }else {
                self.showSendMailErrorAlert()
            }
        }
        
        if indexPath.section == 2 && indexPath.row == 0 {
            let orderedTask = ORKOrderedTask(identifier: "TutorialTask", steps: makeTutorialSteps())
            let taskViewController = ORKTaskViewController(task: orderedTask, taskRun: nil)
            taskViewController.delegate = self
            taskViewController.modalPresentationStyle = .fullScreen
            present(taskViewController, animated: true, completion: nil)
        }
        if indexPath.section == 2 && indexPath.row == 1 {
            let player = AVPlayer(url: Bundle.main.url(forResource: "StanfordSpineKeeperIntro", withExtension: "mov")!)
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
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController
    {
        let fileManager = FileManager.default
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        let text = appDelegate.getData()
        //print(text)
        let cipherdata = RNCryptor.encrypt(data: text.data(using: .utf8)!, withPassword: "whohasyourbacksmuck")
        let ciphertext = cipherdata.base64EncodedString()
        
        mailComposerVC.setToRecipients(["stanfordspinekeeper@stanford.edu"])
        mailComposerVC.setSubject("Spinekeeper Data")
        mailComposerVC.setMessageBody(ciphertext, isHTML: false)
    
        let documentsUrl =  fileManager.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        let fileUrl = documentsUrl.appendingPathComponent("spinekeeper-data.zip")
        let documentsPath = documentsUrl.path
        
        do {
            if let documentPath = documentsPath
            {
                let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                for fileName in fileNames {
                    
                    // delete old zip file if exist
                    if (fileName.hasSuffix(".zip"))
                    {
                        let filePathName = "\(documentPath)/\(fileName)"
                        try fileManager.removeItem(atPath: filePathName)
                    }
                    
                    if (fileName.hasPrefix("spinekeeper-data"))
                    {
                        let newUrl = documentsUrl.appendingPathComponent("spinekeeper-data")
                        let _ = try Zip.quickZipFiles([newUrl!], fileName: "spinekeeper-data", progress: { (progress) in
                            
                            print(progress)
                        })
                    }
                }
            }
        } catch {
            print("\(error.localizedDescription)")
        }
        
        if let fileData = NSData(contentsOf: fileUrl!) {
            mailComposerVC.addAttachmentData(fileData as Data, mimeType: "application/zip", fileName: "spinekeeper-data")
        }
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Spinekeeper", message: "Your device could not send an e-mail. Please check e-mail configuration settings and try again.",         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result{
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: %@", [error!.localizedDescription])
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeTutorialSteps() -> [ORKStep] {
        let tempStep = ORKInstructionStep.init(identifier: "tutorialStep1")
        tempStep.title = "Tutorial"
        tempStep.detailText = "We'll recommend a daily list of things to do in your Daily Activities Tab.\n\nFor each activity, you can tap the arrow on the right to see more detail. Tap the colored bubbles below each activity as you complete them."
        tempStep.image = ResearchContainerViewController.imageResize(with: UIImage(named: "tutorial_activity")!, andResizeTo: CGSize.init(width: 100.0, height: 135.0))
        //tempStep.image = UIImage(named: "tutorial_activity")
        
        let tempStep2 = ORKInstructionStep.init(identifier: "tutorialStep2")
        tempStep2.title = " "
        tempStep2.detailText = "Use the Insights tab to view your weekly progress.\n\nUse the Learn tab to know more about back pain."
        tempStep2.image = ResearchContainerViewController.imageResize(with: UIImage(named: "tutorial_symptoms")!, andResizeTo: CGSize.init(width: 100.0, height: 142.0))
        //tempStep2.image = UIImage(named: "tutorial_symptoms")
        
        return [tempStep, tempStep2]
        //let completionTask = ORKNavigableOrderedTask(identifier: "tutorialTask", steps: [tempStep, tempStep2])
        //let completeStep = ORKNavigablePageStep(identifier: "TutorialStep", pageTask: completionTask)
        //return completeStep
    }
    
    
    //        // dob/age, leave study, change passcode, view tutorial, review consent, permissions, privacy, licenses
    //        let items : [[String]] = [   [],
    //                                     ["", "Permissions", ""],
    //                                     ["", "Review Consent"],
    //                                     ["", ""]
    //        ]
    
    // MARK: Cell configuration
    
//    func configureCellWithDateOfBirth(_ cell: ProfileStaticTableViewCell) {
//        // Set the default cell content.
//        cell.titleLabel.text = NSLocalizedString("Date of Birth", comment: "")
//        cell.valueLabel.text = NSLocalizedString("-", comment: "")
//
//        // Update the value label with the date of birth from the health store.
//        guard let healthStore = healthStore else { return }
//
//        do {
//            let dateOfBirthcomps = try healthStore.dateOfBirthComponents()
//            let dateOfBirth = Calendar.current.date(from: dateOfBirthcomps)
//            let now = Date()
//
//            let ageComponents = Calendar.current.dateComponents([.year], from: dateOfBirth!, to: now)
//            let age = ageComponents.year
//            if (age != nil) { cell.valueLabel.text = "\(age!)" }
//            else {}
//        }
//        catch {
//        }
//    }

//    func configureCell(_ cell: ProfileStaticTableViewCell, withTitleText titleText: String, valueForQuantityTypeIdentifier identifier: String) {
//        // Set the default cell content.
//        cell.titleLabel.text = titleText
//        cell.valueLabel.text = NSLocalizedString("-", comment: "")
//
//        /*
//            Check a health store has been set and a `HKQuantityType` can be
//            created with the identifier provided.
//        */
//        guard let healthStore = HKHealthStore.self, let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: identifier)) else { return }
//
//        // Get the most recent entry from the health store.
//        healthStore.mostRecentQauntitySampleOfType(quantityType) { quantity, _ in
//            guard let quantity = quantity else { return }
//
//            // Update the cell on the main thread.
//            OperationQueue.main.addOperation() {
//                guard let indexPath = self.indexPathForObjectTypeIdentifier(identifier) else { return }
//                guard let cell = self.tableView.cellForRow(at: indexPath) as? ProfileStaticTableViewCell else { return }
//                
//                cell.valueLabel.text = "\(quantity)"
//            }
//        }
//    }
//
//    // MARK: Convenience
//
//    func indexPathForObjectTypeIdentifier(_ identifier: String) -> IndexPath? {
//        for (index, objectType) in HealthClientType.enumerated() where objectType.identifier == identifier {
//            return IndexPath(row: index, section: 0)
//        }
//
//        return nil
//    }
}

extension ProfileViewController: ORKPasscodeDelegate {
    
    public func passcodeViewControllerDidFinish(withSuccess viewController: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    public func passcodeViewControllerDidFailAuthentication(_ viewController: UIViewController) {
        //dismiss(animated: true, completion: nil)
    }
    
    public func passcodeViewControllerDidCancel(_ viewController: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
}



extension ProfileViewController : ORKTaskViewControllerDelegate {
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
            dismiss(animated: true, completion: nil)
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, viewControllerFor step: ORKStep) -> ORKStepViewController? {
        return nil
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, stepViewControllerWillDisappear stepViewController: ORKStepViewController, navigationDirection direction: ORKStepViewControllerNavigationDirection) {
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, stepViewControllerWillAppear stepViewController: ORKStepViewController) {
    }
    
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didChange result: ORKTaskResult) {
    }
}

