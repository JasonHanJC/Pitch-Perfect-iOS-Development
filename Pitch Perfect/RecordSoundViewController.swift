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
    @IBOutlet weak var timerLbl: UILabel!
    
    
    // var:
    var soundRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var timer_1: NSTimer!
    var timer_2: NSTimer!
    var blinkStatus: Bool!
    var isPause: Bool!
    var startTime: NSTimeInterval!
    var pauseTime: NSTimeInterval!
    var timeGap_1: NSTimeInterval!
    var timeGap_2: NSTimeInterval!

    
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
    override func viewWillAppear(animated: Bool) {
        
        stopRecordBtn.hidden = true
        recordLabel.hidden = false
        pauseAndResumeRecordBtn.hidden = true
        recordBtn.enabled = true
        recordBtn.hidden = false
        recordBg.hidden = true
        timerLbl.hidden = true
    }

    
    @IBAction func recordSound(sender: UIButton) {
        
        recordLabel.text = "Recording in progress"
        stopRecordBtn.hidden = false
        pauseAndResumeRecordBtn.hidden = false
        recordBtn.enabled = false
        recordBtn.hidden = true
        recordBg.hidden = false
        timerLbl.hidden = false
        
        // prepare to record
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let nameOfRecordSound = "myRecord"
        let recordingName = nameOfRecordSound + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        // Setup audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker)
        
        // Initialize and prepare the recorder
        try! soundRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        soundRecorder.delegate = self
        soundRecorder.meteringEnabled = true
        soundRecorder.prepareToRecord()
        soundRecorder.record()
        
        startTimer()
        
        startTime = NSDate.timeIntervalSinceReferenceDate()
    }
    
    func startTimer() {
        if timer_1 != nil {
            timer_1.invalidate()
        }
        if timer_2 != nil {
            timer_2.invalidate()
        }
        
        timer_1 = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "recordLblBlink", userInfo: nil, repeats: true)
        timer_2 = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "timerLblUpdate", userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer_1.invalidate()
        timer_2.invalidate()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            // Move to the next scene aka perform segue
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            // Print out the err and enable the btn to record again
            print("Recording was not successful")
            recordBtn.enabled = true
            stopRecordBtn.hidden = true
            pauseAndResumeRecordBtn.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            // segue.destinationViewController makes that when stopRecording is called the view will changed to the next wanted view
            let playSoundsVC:PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        
        recordLabel.hidden = true
        recordLabel.text = "Tap to Record"
        isPause = true
        pauseAndResumeRecordBtn.setImage(UIImage(named: "pauseImg"), forState: .Normal)
        
        
        // stop the record
        soundRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        pauseTime = 0.0
        stopTimer()
    }
    
    @IBAction func pauseAndResumeRecording(sender: UIButton) {
        
        if isPause == true {
            recordLabel.text = "Recording is Paused"
            soundRecorder.pause()
            pauseAndResumeRecordBtn.setImage(UIImage(named: "resumeImg"), forState: .Normal)
            isPause = false
            timeGap_1 = NSDate.timeIntervalSinceReferenceDate()
            stopTimer()
        } else {
            recordLabel.text = "Recording in progress"
            soundRecorder.record()
            pauseAndResumeRecordBtn.setImage(UIImage(named: "pauseImg"), forState: .Normal)
            isPause = true
            timeGap_2 = NSDate.timeIntervalSinceReferenceDate()
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
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime: NSTimeInterval = currentTime - startTime - pauseTime
        
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        timerLbl.text = "\(strMinutes):\(strSeconds)"
    }

}

