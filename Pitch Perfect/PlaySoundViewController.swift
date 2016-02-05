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

    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load sound
        do {
            //let resourcePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3")!
            //let url = NSURL(fileURLWithPath: resourcePath)
            let url = receivedAudio.filePathUrl
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
            audioPlayer.enableRate = true
            
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        audioPlayer.prepareToPlay()
        
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
    
    @IBAction func playDeathDarkSound(sender: UIButton) {
        playDifPitchSounds(-1000)
    }
    
    @IBAction func playChipmunkSound(sender: UIButton) {
        playDifPitchSounds(1000)
    }
    
    func playDifPitchSounds(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()

        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
    }
    
    func playDifRateSounds(rate: Float) {
        if audioPlayer.playing {
            audioPlayer.stop()
            audioPlayer.currentTime = 0
        }
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    @IBAction func stopPlaySounds(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
    }

}
