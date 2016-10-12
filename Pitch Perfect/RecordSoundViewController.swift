//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Jason miew on 2/2/16.
//  Copyright © 2016 JasonHan. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    // outlet:
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopRecordBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var pauseAndResumeRecordBtn: UIButton!
    @IBOutlet weak var recordBg: UIImageView!
    @IBOutlet weak var minLbl: UILabel!
    @IBOutlet weak var secLbl: UILabel!
    @IBOutlet weak var colonLbl: UILabel!
    
    
    // var:
    var soundRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var timer_1: Timer!
    var timer_2: Timer!
    var blinkStatus: Bool!
    var isPause: Bool!
    var startTime: TimeInterval!
    var pauseTime: TimeInterval!
    var timeGap_1: TimeInterval!
    var timeGap_2: TimeInterval!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startTime = 0.0
        pauseTime = 0.0
        timeGap_1 = 0.0
        timeGap_2 = 0.0
        blinkStatus = false
        isPause = true
    }
    
    // For showing and hiding things
    override func viewWillAppear(_ animated: Bool) {
        
        stopRecordBtn.isHidden = true
        recordLabel.isHidden = false
        pauseAndResumeRecordBtn.isHidden = true
        recordBtn.isEnabled = true
        recordBtn.isHidden = false
        recordBg.isHidden = true
        minLbl.isHidden = true
        colonLbl.isHidden = true
        secLbl.isHidden = true
    }

    
    @IBAction func recordSound(_ sender: UIButton) {
        
        recordLabel.text = "Recording in progress"
        stopRecordBtn.isHidden = false
        pauseAndResumeRecordBtn.isHidden = false
        recordBtn.isEnabled = false
        recordBtn.isHidden = true
        recordBg.isHidden = false
        minLbl.isHidden = false
        colonLbl.isHidden = false
        secLbl.isHidden = false
        
        // prepare to record
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let nameOfRecordSound = "myRecord"
        let recordingName = nameOfRecordSound + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath)
        
        // Setup audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        // Initialize and prepare the recorder
        try! soundRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        soundRecorder.delegate = self
        soundRecorder.isMeteringEnabled = true
        soundRecorder.prepareToRecord()
        soundRecorder.record()
        
        startTimer()
        
        startTime = Date.timeIntervalSinceReferenceDate
    }
    
    func startTimer() {
        if timer_1 != nil {
            timer_1.invalidate()
        }
        if timer_2 != nil {
            timer_2.invalidate()
        }
        
        timer_1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(RecordSoundViewController.recordLblBlink), userInfo: nil, repeats: true)
        timer_2 = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(RecordSoundViewController.timerLblUpdate), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer_1.invalidate()
        timer_2.invalidate()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            // Move to the next scene aka perform segue
            performSegue(withIdentifier: "stopRecording", sender: recordedAudio)
        } else {
            // Print out the err and enable the btn to record again
            print("Recording was not successful")
            recordBtn.isEnabled = true
            stopRecordBtn.isHidden = true
            pauseAndResumeRecordBtn.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            // segue.destinationViewController makes that when stopRecording is called the view will changed to the next wanted view
            let playSoundsVC:PlaySoundViewController = segue.destination as! PlaySoundViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        
        recordLabel.isHidden = true
        recordLabel.text = "Tap to Record"
        isPause = true
        pauseAndResumeRecordBtn.setImage(UIImage(named: "pauseImg"), for: UIControlState())
        
        
        // stop the record
        soundRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        pauseTime = 0.0
        stopTimer()
    }
    
    @IBAction func pauseAndResumeRecording(_ sender: UIButton) {
        
        if isPause == true {
            recordLabel.text = "Recording is Paused"
            soundRecorder.pause()
            pauseAndResumeRecordBtn.setImage(UIImage(named: "resumeImg"), for: UIControlState())
            isPause = false
            timeGap_1 = Date.timeIntervalSinceReferenceDate
            stopTimer()
        } else {
            recordLabel.text = "Recording in progress"
            soundRecorder.record()
            pauseAndResumeRecordBtn.setImage(UIImage(named: "pauseImg"), for: UIControlState())
            isPause = true
            timeGap_2 = Date.timeIntervalSinceReferenceDate
            pauseTime = pauseTime + timeGap_2 - timeGap_1
            startTimer()
        }
        
        
    }
    
    func recordLblBlink() {
        if isPause == true {
            if blinkStatus == false {
                recordLabel.alpha = 0.4
                blinkStatus = true
            } else {
                recordLabel.alpha = 1
                blinkStatus = false
            }
        } else {
            recordLabel.alpha = 1
        }
    }
    
    func timerLblUpdate() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        var elapsedTime: TimeInterval = currentTime - startTime - pauseTime
        
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        minLbl.text = "\(strMinutes)"
        secLbl.text = "\(strSeconds)"
    }

}

