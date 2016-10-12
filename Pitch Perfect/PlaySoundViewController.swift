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
    var audioPlayerNode: AVAudioPlayerNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load sound
        do {
            
            let url = receivedAudio.filePathUrl
            try audioPlayer = AVAudioPlayer(contentsOf: url as URL)
            audioPlayer.enableRate = true
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl as URL)
        audioPlayer.prepareToPlay()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func playSlowSounds(_ sender: UIButton) {
        playDifRateSounds(0.5)
    }
    
    @IBAction func playFastSounds(_ sender: UIButton) {
        playDifRateSounds(2.0)
    }
    
    @IBAction func playDeathDarkSound(_ sender: UIButton) {
        playDifPitchSounds(-1000)
    }
    
    @IBAction func playChipmunkSound(_ sender: UIButton) {
        playDifPitchSounds(1000)
    }
    
    @IBAction func playReverbSound(_ sender: UIButton) {
        resetAudioUnits()
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let reverb = AVAudioUnitReverb()
        reverb.loadFactoryPreset(AVAudioUnitReverbPreset.mediumHall)
        reverb.wetDryMix = 50
        audioEngine.attach(reverb)
        
        audioEngine.connect(audioPlayerNode, to: reverb, format: nil)
        audioEngine.connect(reverb, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    func playDifPitchSounds(_ pitch: Float) {
        resetAudioUnits()

        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attach(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    func playDifRateSounds(_ rate: Float) {
        resetAudioUnits()
        
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func resetAudioUnits() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.reset()
        }
        
        if audioPlayerNode.isPlaying {
            audioPlayerNode.stop()
        }
        
        if audioPlayer.isPlaying {
            audioPlayer.stop()
            audioPlayer.currentTime = 0
        }
    }
    
    @IBAction func stopPlaySounds(_ sender: UIButton) {
        resetAudioUnits()
    }

}
