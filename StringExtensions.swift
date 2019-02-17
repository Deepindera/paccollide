//
//  StringExtensions.swift
//  paccollide
//
//  Created by Deepindera on 9/09/2015.
//  Copyright (c) 2015 Deepindera. All rights reserved.
//

import Foundation
extension String {
    
    var length: Int {
        get {
            return self.characters.count
        }
    }
    
    func indexOf(target: String) -> Int {
        let range = self.rangeOfString(target)
        if let range = range {
            return self.startIndex.distanceTo(range.startIndex)
        } else {
            return -1
        }
    }
    
    func indexOf(target: String, startIndex: Int) -> Int {
        let startRange = self.startIndex.advancedBy(startIndex)
        let range = self.rangeOfString(target, options: NSStringCompareOptions.LiteralSearch, range: Range<String.Index>(start: startRange, end: self.endIndex))
        if let range = range {
            return self.startIndex.distanceTo(range.startIndex)
        } else {
            return -1
        }
    }
    
    func lastIndexOf(target: String) -> Int {
        var index = -1
        var stepIndex = self.indexOf(target)
        while stepIndex > -1 {
            index = stepIndex
            if stepIndex + target.length < self.length {
                stepIndex = indexOf(target, startIndex: stepIndex + target.length)
            } else {
                stepIndex = -1
            }
        }
        return index
    }
    
    func substringWithRange(range:Range<Int>) -> String {
        let start = self.startIndex.advancedBy(range.startIndex)
        let end = self.startIndex.advancedBy(range.endIndex)
        return self.substringWithRange(start..<end)
    }
    
    func removeCharsFromStart(count_:Int) -> String {
        let stringLength = self.characters.count
        
        let substringIndex = (stringLength < count_) ? 0 : count_
        
        return self.substringFromIndex(self.startIndex.advancedBy(substringIndex))
    }
    
    func removeCharsFromEnd(count_:Int) -> String {
        let stringLength = self.characters.count
        
        let substringIndex = (stringLength < count_) ? 0 : stringLength - count_
        
        return self.substringToIndex(self.startIndex.advancedBy(substringIndex))
    }
    
}
