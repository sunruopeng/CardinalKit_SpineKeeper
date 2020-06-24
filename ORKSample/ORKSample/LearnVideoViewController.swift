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

import AVFoundation
import MediaPlayer
import AVKit

class LearnVideoViewController: UITableViewController {
    // MARK: Properties
    
    @IBOutlet var applicationNameLabel: UILabel!
    
    // MARK: UIViewController
    
    let contents: [Dictionary<String, String>] = [
        [
            "title":"Regular Exercise",
            "image":"globe_icon",
            "video": "nass1"
        ],
        [
            "title":"Smoking",
            "image":"globe_icon",
            "video": "nass2"
        ],
        [
            "title":"Maintaining a Healthy Weight",
            "image":"globe_icon",
            "video": "nass3"
        ],
        [
            "title":"Core Strength",
            "image":"globe_icon",
            "video": "nass4"
        ],
        [
            "title":"Body Mechanics",
            "image":"globe_icon",
            "video": "nass5"
        ],
        [
            "title":"Posture Tips",
            "image":"globe_icon",
            "video": "nass6"
        ],
        [
            "title":"Reduce Stress",
            "image":"globe_icon",
            "video": "nass7"
        ],
        [
            "title":"Strong Bones",
            "image":"globe_icon",
            "video": "nass8"
        ],
        [
            "title":"Weekend Warriors",
            "image":"globe_icon",
            "video": "nass9"
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
        tableView.register(LearnStaticTableViewCell.self, forCellReuseIdentifier: LearnStaticTableViewCell.reuseIdentifier)
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let cell = sender as? UITableViewCell {
//            let indexPath = self.tableView.indexPath(for: cell)!
//            let index = indexPath.row
//            let detailVC = segue.destination
//            let baseURL = Bundle.main.resourceURL
//            let htmlname = contents[index]["htmlContent"]
//
//            if htmlname == "none" {
//
//            }
//
//
//            let htmlFile = Bundle.main.path(forResource: htmlname, ofType: "html")
//            let html = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
//            let webView = UIWebView.init(frame: self.view.frame)
//            webView.loadHTMLString(html!, baseURL: baseURL)
//            detailVC.view.addSubview(webView)
//            detailVC.view.autoresizesSubviews = true
//
//        }
//    }
    
    // don't need to do anything since it's handled by prepare for segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let index = indexPath.row
        let player = AVPlayer(url: Bundle.main.url(forResource: contents[index]["video"], withExtension: "mp4")!)
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
}

// MARK: Convenience

// func indexPathForObjectTypeIdentifier(_ identifier: String) -> IndexPath? {
//        for (index, objectType) in healthObjectTypes.enumerated() where objectType.identifier == identifier {
//            return IndexPath(row: index, section: 0)
//        }
//
//        return nil
//   }


