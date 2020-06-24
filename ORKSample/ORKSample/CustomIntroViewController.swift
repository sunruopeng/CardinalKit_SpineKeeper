//
//  CustomIntroViewController.swift
//  ORKSample
//
//  Created by Aman Sinha on 4/16/18.
//  Copyright © 2018 Apple, Inc. All rights reserved.
//

import Foundation
import UIKit

import AVFoundation
import MediaPlayer
import AVKit

class CustomIntroViewController: UIViewController {
    // MARK: IB actions
    
    @IBAction func buttonTapped(_ sender: UIButton) {
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
}

