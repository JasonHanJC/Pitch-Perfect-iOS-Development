//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Jason miew on 2/2/16.
//  Copyright © 2016 JasonHan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // outlet:
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopRecordBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    
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
        
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        
        recordLabel.hidden = true
        
    }

}

