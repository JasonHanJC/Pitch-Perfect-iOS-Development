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
    
    // var:
    var soundRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // For showing and hiding things
    override func viewWillAppear(animated: Bool) {
        
        stopRecordBtn.hidden = true
        recordBtn.enabled = true
    }

    
    @IBAction func recordSound(sender: UIButton) {
        
        recordLabel.hidden = false
        stopRecordBtn.hidden = false
        recordBtn.enabled = false
        
        // prepare to record
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        //let currentDateTime = NSDate()
        //let formatter = NSDateFormatter()
        //formatter.dateFormat = "ddMMyyyy-HHmmss"
        //let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let nameOfRecordSound = "myRecord"
        let recordingName = nameOfRecordSound + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        // Setup audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        // Initialize and prepare the recorder
        try! soundRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        soundRecorder.delegate = self
        soundRecorder.meteringEnabled = true
        soundRecorder.prepareToRecord()
        soundRecorder.record()
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            // Move to the next scene aka perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            // Print out the err and enable the btn to record again
            print("Recording was not successful")
            recordBtn.enabled = true
            stopRecordBtn.hidden = true
            
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
        
        // stop the record
        soundRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }

}

