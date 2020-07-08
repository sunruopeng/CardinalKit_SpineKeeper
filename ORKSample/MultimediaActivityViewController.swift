//
//  MultimediaActivityViewController.swift
//  ORKSample
//
//  Created by Muhammad Junaid Butt on 07/07/2020.
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import CareKit
import AVKit
import WebKit

class MultimediaActivityViewController: OCKInstructionsTaskViewController {
    
    //This method is called when the user taps the card for detail view
    override func didSelectTaskView(_ taskView: UIView & OCKTaskDisplayable, eventIndexPath: IndexPath) {
        guard let event = controller.eventFor(indexPath: eventIndexPath) else { return }
        guard let task = event.task as? OCKTask else { return }
        guard let userInfo = task.userInfo else { return }
        
        //Check the type of the task
        if userInfo["hasTask"] == "video" {
            let player = AVPlayer(url: Bundle.main.url(forResource: userInfo["video"], withExtension: "mp4")!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true) {
                do {
                    AVAudioSession.sharedInstance().perform(NSSelectorFromString("setCategory:error:"),
                                                            with: AVAudioSession.Category.playback)
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch {
                    print(error)
                }
                
                playerViewController.player!.play()
            }
            return
        }
        
        if userInfo["hasTask"] == "image" {
            let careCardImageView = ImageScrollView(frame: UIScreen.main.bounds)
            
            let vc = UIViewController()
            vc.view.addSubview(careCardImageView)
            let image = ResearchContainerViewController.imageResize(with: UIImage(named: userInfo["image"]!)!,
                                                                    andResizeTo: careCardImageView.frame.size)
            careCardImageView.display(image: image)
            careCardImageView.adjustFrameToCenter()
            careCardImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight,
                                                  .flexibleLeftMargin, .flexibleRightMargin];
            vc.view.autoresizesSubviews = true
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        if userInfo["hasTask"] == "html" {
            let baseURL = Bundle.main.resourceURL?.appendingPathComponent("HTMLContent")
            let vc = UIViewController()
            let htmlname = userInfo["html"]
            let htmlFile = Bundle.main.path(forResource: htmlname, ofType: "html")
            let html = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
            
            let webView = WKWebView(frame: UIScreen.main.bounds)
            webView.loadHTMLString(html!, baseURL: baseURL)
            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin];
            vc.view.addSubview(webView)
            vc.view.autoresizesSubviews = true
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
    }
}
