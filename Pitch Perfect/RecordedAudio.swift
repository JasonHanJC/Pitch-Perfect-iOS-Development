//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Jason miew on 2/4/16.
//  Copyright © 2016 JasonHan. All rights reserved.
//

import Foundation

class RecordedAudio {
    
    fileprivate var _filePathUrl: URL!
    fileprivate var _title: String!
    
    var filePathUrl: URL {
        get {
            return _filePathUrl
        }
    }
    
    var title: String {
        get {
            return _title
        }
    }
    
    init(filePathUrl: URL, title: String) {
        self._filePathUrl = filePathUrl
        self._title = title
    }
    
    
}
