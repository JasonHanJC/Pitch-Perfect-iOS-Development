//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Jason miew on 2/4/16.
//  Copyright © 2016 JasonHan. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {

    var playSlowSound: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load sound
        do {
            let resourcePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3")!
            let url = NSURL(fileURLWithPath: resourcePath)
            try playSlowSound = AVAudioPlayer(contentsOfURL: url)
            playSlowSound.enableRate = true
            
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        
        playSlowSound.prepareToPlay()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func playSlowSounds(sender: UIButton) {
        playDifRateSounds(0.5)
    }
    
    @IBAction func playFastSounds(sender: UIButton) {
        playDifRateSounds(2.0)
    }
    
    func playDifRateSounds(rate: Float) {
        if playSlowSound.playing {
            playSlowSound.stop()
            playSlowSound.currentTime = 0
        }
        playSlowSound.rate = rate
        playSlowSound.play()
    }
    
    @IBAction func stopPlaySounds(sender: UIButton) {
        playSlowSound.stop()
        playSlowSound.currentTime = 0
    }

}
