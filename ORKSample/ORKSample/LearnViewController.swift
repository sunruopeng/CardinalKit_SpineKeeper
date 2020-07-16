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
import HealthKit
import WebKit

class LearnViewController: UITableViewController {
    // MARK: Properties
    
    @IBOutlet var applicationNameLabel: UILabel!
    
    // MARK: UIViewController
    
    let contents: [Dictionary<String, String>] = [
        [
            "title":"About this study",
            "image":"paperplus_icon",
            "htmlContent": "AboutStudy"
        ],
        [
            "title":"Who can participate?",
            "image":"eligibility",
            "htmlContent": "EligibleToParticipate"
        ],
        [
            "title":"Your role",
            "image":"walkingman",
            "htmlContent": "howstudyworks"
        ],
        [
            "title":"What is back pain?",
            "image":"heartagetest-Icon-body",
            "htmlContent": "disease_information"
        ],
        /*[
            "title":"Online resources",
            "image":"globe_icon",
            "htmlContent": "online_resources"
        ],
        [
            "title":"Online resources  - tbd share",
            "image":"globe_icon",
            "htmlContent": "online_resources"
        ],*/
        [
            "title":"KnowYourBack Videos",
            "image":"globe_icon",
            "htmlContent": "none"
        ],
        
        ]
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ensure the table view automatically sizes its rows.
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        
        // remove the extra spearators after content is done
        self.tableView.tableFooterView = UIView()
        //self.videoVC = LearnVideoViewController(style: UITableViewStyle.plain)
    }
    
    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LearnStaticTableViewCell.reuseIdentifier, for: indexPath) as? LearnStaticTableViewCell else { fatalError("Unable to dequeue a LearnStaticTableViewCell") }
        let index = indexPath.row
        let size = CGSize.init(width: 50, height: 50)
        let image = UIImage(named: contents[index]["image"]!)
        let newimage = LearnViewController.imageResize(with: image!, andResizeTo: size)
        cell.imageView?.image = newimage
        cell.imageView?.image = cell.imageView?.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cell.imageView?.tintColor = Colors.cardinalRed.color
        cell.textLabel?.text = contents[index]["title"]
        //cell.imageView?.tintColor = UIColor.green
        return cell
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "aboutSegue" {
            if let cell = sender as? UITableViewCell {
                let indexPath = self.tableView.indexPath(for: cell)!
                let index = indexPath.row
                let htmlname = contents[index]["htmlContent"]
            
                if htmlname == "none" {
                    performSegue(withIdentifier: "aboutVideoSegue", sender: self)
                    return false
                }
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            let indexPath = self.tableView.indexPath(for: cell)!
            let index = indexPath.row
            let detailVC = segue.destination
            let baseURL = Bundle.main.resourceURL?.appendingPathComponent("HTMLContent")
            let htmlname = contents[index]["htmlContent"]
            
            if htmlname == "none" {
//                //let tableVC = LearnVideoViewController(style: UITableViewStyle.plain)
//                //let tableView = UITableView(frame: CGRect(x: 10, y: 10, width: 100, height: 500) , style: UITableViewStyle.plain)
//                //tableView.register(LearnStaticTableViewCell.self, forCellReuseIdentifier: LearnStaticTableViewCell.reuseIdentifier)
//                //tableView.dataSource = tableVC
//                //tableView.delegate = tableVC
//                //tableVC.view = tableView
//                videoVC.view.frame = CGRect.init(x: 0,
//                                                 y: (self.navigationController?.navigationBar.frame.maxY)!,
//                                                 width: detailVC.view.frame.width,
//                                                 height: detailVC.view.frame.height
//                                                    - (self.navigationController?.navigationBar.frame.maxY)!
//                                                    - (self.tabBarController?.tabBar.frame.height)!)
//                //videoVC.view.frame = self.view.frame
//                detailVC.view.addSubview(videoVC.view)
//                detailVC.view.autoresizesSubviews = true
                return
                
                    //myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
                //myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
                //myTableView.dataSource = self
                //myTableView.delegate = self
                //self.view.addSubview(myTableView)
            }
            let htmlFile = Bundle.main.path(forResource: htmlname, ofType: "html")
            let html = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
            let webView = WKWebView(frame: self.view.frame)
            webView.loadHTMLString(html!, baseURL: baseURL)
            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin];
            detailVC.view.addSubview(webView)
            detailVC.view.autoresizesSubviews = true
        }
    }
    
    // don't need to do anything since it's handled by prepare for segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let index = indexPath.row
        
        switch index {
            case 0: // about
                break
            case 1:
                break
            case 2:
                break
            default:
                break
        }
        
    }
    
    func configureCell(_ cell: ProfileStaticTableViewCell, withTitleText titleText: String, valueForQuantityTypeIdentifier identifier: String) {
        // Set the default cell content.
        cell.titleLabel.text = titleText
        cell.valueLabel.text = NSLocalizedString("-", comment: "")
    }

}

