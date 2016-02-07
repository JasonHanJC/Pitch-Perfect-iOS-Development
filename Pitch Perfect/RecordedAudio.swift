//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Jason miew on 2/4/16.
//  Copyright © 2016 JasonHan. All rights reserved.
//

import Foundation

class RecordedAudio {
    
    private var _filePathUrl: NSURL!
    private var _title: String!
    
    var filePathUrl: NSURL {
        get {
            return _filePathUrl
        }
    }
    
    var title: String {
        get {
            return _title
        }
    }
    
    init(filePathUrl: NSURL, title: String) {
        self._filePathUrl = filePathUrl
        self._title = title
    }
    
    
}