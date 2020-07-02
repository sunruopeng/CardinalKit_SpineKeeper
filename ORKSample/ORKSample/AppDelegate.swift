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

/* TODOS
  If it hasn't sent data to server in more than 7 days (successfully), try again now.
  If the next week's activities aren't planned yet and in the store, do it now.
  Activity identifiers are the activity name + startDate + endDate
      So when building insights, ask for the group identifier, then find the relevant activities in the right date range
  Custom carecardetail view which is kicked off by carecardviewcontrollerdelegate method didselectintervention
  Add initial user data into nsuserdefaults or careplanstore
 
store user date - fix dashboard link
 Aveg day last week steps vs. normal distrib of avg day
 Pain over time (week? start study?)
 Westworld spokes - core/strength, mindfulness, flexibility, Knowledge, Sleep, Activity
 
 Adherence to prescription last week
 insight of the day
 */

import UIKit
import ResearchKit

import MessageUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let baseURLstring = "https://device-qa.stanford.edu/mhc-KnRJe654r9xkA5tX/api/v1"
    let healthStore = HKHealthStore()
    var window: UIWindow?
    var tot: String = ""
    var steptot: String = ""
    
    var containerViewController: ResearchContainerViewController? {
        return window?.rootViewController as? ResearchContainerViewController
    }
    
    func application(_ application: UIApplication,
                     willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let standardDefaults = UserDefaults.standard
        if standardDefaults.object(forKey: "ORKSampleFirstRun") == nil {
            ORKPasscodeViewController.removePasscodeFromKeychain()
            standardDefaults.setValue("ORKSampleFirstRun", forKey: "ORKSampleFirstRun")
        }
        //UserDefaults.standard.set(Calendar.autoupdatingCurrent.startOfDay(for: Date()), forKey: "startDate")
        // Appearance customization
        let pageControlAppearance = UIPageControl.appearance()
        pageControlAppearance.pageIndicatorTintColor = UIColor.lightGray
        pageControlAppearance.currentPageIndicatorTintColor = UIColor.black
        // Dependency injection.
        containerViewController?.injectHealthStore(healthStore)
        return true
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIView.appearance().tintColor = Colors.cardinalRed.color
        lockApp()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if ORKPasscodeViewController.isPasscodeStoredInKeychain() {
            // Hide content so it doesn't appear in the app switcher.
            containerViewController?.contentHidden = true
        }
    }
    
    func getData() -> String {
        let name = (UserDefaults.standard.object(forKey: "firstName") as! String)
            + " "
            + (UserDefaults.standard.object(forKey: "lastName") as! String)
        return name + "\n\n" + self.tot + "\n\nSteps\n" + self.steptot
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        lockApp()
    }
    
//    func stepsAuthorized() -> Bool {
//        let temp = self.healthStore.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!)
//        return true
//    }
    
    func getSingleDaySteps(date: Date, completion: @escaping (_ stepcount: Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let startOfDay = Calendar.current.startOfDay(for: date)
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let endOfDay = Calendar.current.date(byAdding: components, to: startOfDay)!
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        healthStore.execute(query)
    }
    
    func syncDataWithServer() {
        let calendar = Calendar.autoupdatingCurrent
        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        //let endDate = calendar.date(byAdding: .day, value: 10, to: calendar.startOfDay(for: Date()))
        //var dict = UserDefaults.standard.object(forKey: "datesSynced") as? [String: Bool] ?? [String: Bool]()
        //if stepsAuthorized() {
        for i in 0..<28 {
            let date = calendar.date(byAdding: .day, value: i, to: startDate)!
            getSingleDaySteps(date: date) { stepcount in
                self.steptot += formatter.string(from: date) + " " + String(stepcount) + "\n"
            }
        }
        //}
        
        /*   Junaid Commnented
        let yo = containerViewController?.careStoreManager.store
        yo?.activities{ (success, activities, errorOrNil) in
                guard success else {
                    // perform proper error handling here
                    fatalError(errorOrNil!.localizedDescription)
                }
            for activity in activities {
                let activityType = ActivityType(rawValue: activity.identifier)
                for i in 0..<28 {
                    let date = calendar.date(byAdding: .day, value: i, to: startDate)
                    let dateComps = calendar.dateComponents([.day, .month, .year], from: date!)
                    yo?.events(for: activity, date: dateComps) { (events, error) in
                        for event in events{
                            //print(event.activity.identifier)
                            //print(event.state == .completed)
                            //print(event.result?.valueString ?? "none ")
                            self.tot += formatter.string(from: date!) + " "
                            self.tot += activity.identifier + " "
                            self.tot += String(event.state == .completed) + " "
                            if (activityType == ActivityType.backPain ||
                                activityType == ActivityType.weight) {
                                if event.state == .completed {
                                    self.tot += event.result?.valueString ?? "none "
                                }
                            }
                            
                            if (activityType == ActivityType.sixMinuteWalk) {
                                self.tot += UserDefaults.standard.object(forKey: "sixMinuteWalk") as! String
                            }
                            if (activityType == ActivityType.odiSurvey) {
                                self.tot += UserDefaults.standard.object(forKey: "odiSurvey") as! String
                            }
                            if (activityType == ActivityType.startBackSurvey) {
                                self.tot += UserDefaults.standard.object(forKey: "startBackSurvey") as! String
                            }
                            self.tot += "\n"
                        }
                    }
                }
            }
            /*
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self.containerViewController
            
            // Configure the fields of the interface.
            composeVC.setToRecipients(["justinnorden@gmail.com"])
            composeVC.setSubject("Hello!")
            composeVC.setMessageBody(self.tot, isHTML: false)
            
            // Present the view controller modally.
            self.containerViewController?.present(composeVC, animated: true, completion: nil)
            */
        }
        
        */
        
//        //print("hello")
//        var i = 0
//        var date = calendar.date(byAdding: .day, value: i, to: startDate)
//        while (date?.compare(endDate!).rawValue)! < 0 {
//            let val = (dict[date!.description])
//            //print(val)
//            if val == false {
//                //print(date)
//                dict[date!.description] = true
//            }
//
//            i+=1
//            date = calendar.date(byAdding: .day, value: i, to: startDate)
//        }
//        dict = UserDefaults.standard.object(forKey: "datesSynced") as? [String: Bool] ?? [String: Bool]()
//        for (key, val) in dict {
//            //print(key, val)
//        }
//        //check all days up to day before today and then if not yes for synced, send zip
//
        
    }
    
    func lockApp() {
        /*
            Only lock the app if there is a stored passcode and a passcode
            controller isn't already being shown.
        */
        guard ORKPasscodeViewController.isPasscodeStoredInKeychain() && !(containerViewController?.presentedViewController is ORKPasscodeViewController)
            && UserDefaults.standard.object(forKey: "startDate") != nil else { return }
        window?.makeKeyAndVisible()
        let passcodeViewController = ORKPasscodeViewController.passcodeAuthenticationViewController(withText: "Please enter your passcode.", delegate: self)
        passcodeViewController.modalPresentationStyle = .fullScreen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.containerViewController?.present(passcodeViewController, animated: false, completion: nil)
        }
    }
}

extension AppDelegate: ORKPasscodeDelegate {
    func passcodeViewControllerDidFinish(withSuccess viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
        containerViewController?.contentHidden = false
        containerViewController?.toStudy()
        syncDataWithServer()
    }
    
    func passcodeViewControllerDidFailAuthentication(_ viewController: UIViewController) {
        
    }
}
