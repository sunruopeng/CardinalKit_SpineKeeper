//
//  ASVerificationStepViewController.swift
//  ORKSample
//
//  Created by Aman Sinha on 3/20/17.
//  Copyright © 2017 Apple, Inc. All rights reserved.
//

import Foundation
import ResearchKit

class ASVerificationStepViewController : ORKVerificationStepViewController {
    
    func errorHelper(title: String, message: String) {
        let alert2Controller = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            print("OK")
        }
        alert2Controller.addAction(okAction)
        self.present(alert2Controller, animated: true, completion: nil)
    }
    
    static func staticErrorHelper(title: String, message: String, controller: UIViewController) {
        let alert2Controller = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            print("OK")
        }
        alert2Controller.addAction(okAction)
        controller.present(alert2Controller, animated: true, completion: nil)
    }
    
    override func continueTapped() {
        // check if the email has been verfiied
        // if so then self.goForward()
        // else tell them to do it again with an error
        
        // temporary
        //self.goForward()
        //return
        
        let url = URL(string: (AppDelegate.baseURLstring + "/auth/signIn"))
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if UserDefaults.standard.object(forKey: "username") == nil {
            self.errorHelper(title: "Hold on!", message: "We're still working on setting up your account.")
            return
        }
        let json : [String:Any] = ["username": UserDefaults.standard.object(forKey: "username") as! String,
                                   "password": UserDefaults.standard.object(forKey: "password") as! String,
                                   "study":"spine"]
        let data = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            guard let data = data, error == nil else {
                //print(error?.localizedDescription ?? "No data")
                self.errorHelper(title: "Oops!", message: error?.localizedDescription ?? "Something went wrong.")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            print(responseJSON ?? ["hi":"yo"])
            let status = (response as! HTTPURLResponse).statusCode
            if status == 200 {
                UserDefaults.standard.set(responseJSON!["sessionToken"], forKey: "sessionToken")
                UserDefaults.standard.set(responseJSON!["dataSharing"], forKey: "dataSharing")
                DispatchQueue.main.async {
                    self.goForward()
                }
                return
            }
            if status == 412 {
                UserDefaults.standard.set(responseJSON!["sessionToken"], forKey: "sessionToken")
                UserDefaults.standard.set(responseJSON!["dataSharing"], forKey: "dataSharing")
                self.doConsent()
                return
            }
            // 400 or 403
            self.errorHelper(title: "Oops!", message: responseJSON!["message"] as? String ?? "Something went wrong.")
        }
        task.resume()
    }
    
    func doConsent() {
        print("consenting")
        let url = URL(string: (AppDelegate.baseURLstring + "/consent"))
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserDefaults.standard.object(forKey: "sessionToken") as? String, forHTTPHeaderField: "Bridge-Session")
        //request.setValue(UserDefaults.standard.object(forKey: "sessionToken") as? String, forHTTPHeaderField: "sessionToken")
        //request.setValue(UserDefaults.standard.object(forKey: "sessionToken") as? String, forHTTPHeaderField: "token")
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        let json : [String:Any] = ["name": (UserDefaults.standard.object(forKey: "firstName") as! String) + " " + (UserDefaults.standard.object(forKey: "lastName") as! String),
                                   "scope": "no_sharing",//UserDefaults.standard.object(forKey: "dataSharing") as! String,
                                   "birthdate": dateFormatterPrint.string(from: (UserDefaults.standard.object(forKey: "dateOfBirth") as! Date))]
        let data = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            guard let data = data, error == nil else {
                //print(error?.localizedDescription ?? "No data")
                self.errorHelper(title: "Oops!", message: error?.localizedDescription ?? "Something went wrong.")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            print(responseJSON ?? ["hi":"yo"])
            let status = (response as! HTTPURLResponse).statusCode
            if status == 201 {
                self.continueTapped()
                return
            }
            self.errorHelper(title: "Oops!", message: responseJSON!["message"] as? String ?? "Something went wrong.")
        }
        task.resume()
    }
    
    override func resendEmailButtonTapped() {
        print("email tapped")
        UserDefaults.standard.set(nil, forKey: "username")
        UserDefaults.standard.set(nil, forKey: "password")
        UserDefaults.standard.set(nil, forKey: "dataSharing")
        UserDefaults.standard.set(nil, forKey: "sessionToken")
        UserDefaults.standard.set(0, forKey: "withdrawn")
        

        //request.setValue("application/json", forHTTPHeaderField: "Accept")
        //request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        //request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let password = randomAlphaNumericString(length: 32)
        UserDefaults.standard.set(password as String, forKey: "password")
        
        let url = URL(string: (AppDelegate.baseURLstring + "/auth/signUp"))
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let json : [String:Any] = ["password":password, "email": (UserDefaults.standard.object(forKey: "email") as! String), "study":"spine"]
        let data = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            guard let data = data, error == nil else {
                //print(error?.localizedDescription ?? "No data")
                self.errorHelper(title: "Oops!", message: error?.localizedDescription ?? "Something went wrong.")
                return
            }
            let status = (response as! HTTPURLResponse).statusCode
            if status != 201 {
                self.errorHelper(title: "Oops!", message: error?.localizedDescription ?? "Something went wrong.")
                return
            }
            // can be 500 otherwise
            
            //let responseData = String(data: data, encoding: String.Encoding.utf8)
            //print(responseData!)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                UserDefaults.standard.set(responseJSON["username"] as! String, forKey: "username")
            }
        }
        task.resume()
    }
    
    func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        var randomString = ""
        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }
        return randomString
    }
    
    static func doWithdrawl(controller: UIViewController) {
        print("withdrawing")
        
        // non-server mode
        UserDefaults.standard.set(1, forKey: "withdrawn")
        staticErrorHelper(title: "You have been withdrawn successfully", message: "Please tap 'OK' to reset the app to its original state.", controller: controller)
        (controller as! ResearchContainerViewController).toWithdrawl()
        
        /*
        let url = URL(string: (AppDelegate.baseURLstring + "/auth/withdraw"))
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserDefaults.standard.object(forKey: "sessionToken") as? String, forHTTPHeaderField: "Bridge-Session")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            guard let data = data, error == nil else {
                //print(error?.localizedDescription ?? "No data")
                DispatchQueue.main.async {
                    staticErrorHelper(title: "Oops!", message: error?.localizedDescription ?? "Something went wrong.", controller: controller)
                }
                return
            }
            let status = (response as! HTTPURLResponse).statusCode
            print(status)
            if status == 200 {
                UserDefaults.standard.set(1, forKey: "withdrawn")
                DispatchQueue.main.async {
                    staticErrorHelper(title: "You have been withdrawn successfully", message: "Please tap 'OK' to reset the app to its original state.", controller: controller)
                    (controller as! ResearchContainerViewController).toWithdrawl()
                }
                return
            }
            DispatchQueue.main.async {
                staticErrorHelper(title: "Oops!", message: "Something went wrong.", controller: controller)
            }
        }
        task.resume()
         */
    }
    
    /*
    let alertController = UIAlertController(title: "Check Your Email", message: "Simple alertView demo with Destructive and Ok.", preferredStyle: UIAlertControllerStyle.alert)
    let DestructiveAction = UIAlertAction(title: "Destructive", style: UIAlertActionStyle.default) {
        (result : UIAlertAction) -> Void in
        print("Destructive")
    }
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
        (result : UIAlertAction) -> Void in
        print("OK")
    }
    alertController.addAction(DestructiveAction)
    alertController.addAction(okAction)
    self.presentViewController(alertController, animated: true, completion: nil)
 */
}
