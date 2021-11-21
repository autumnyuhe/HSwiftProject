//
//  NSString+HUtil.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/19.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension String {
    
    var length: Int {
        return self.lengthOfBytes(using: .utf8)
    }
    
    var intValue: Int {
        return Int(self)!
    }

    var floatValue: Float {
        return Float(self)!
    }

    var doubleValue: Double {
        return Double(self)!
    }

    ///去除字符串两端的空白字符
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }

    func subString(to: Int) -> String {
        var to = to
        if to > self.count {
            to = self.count
        }
        return String(self.prefix(to))
    }

    func subString(from: Int) -> String {
        if from >= self.count {
            return ""
        }
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.endIndex
        return String(self[startIndex..<endIndex])
    }

    func subString(start: Int, end: Int) -> String {
        if start < end {
            let startIndex = self.index(self.startIndex, offsetBy: start)
            let endIndex = self.index(self.startIndex, offsetBy: end)
            
            return String(self[startIndex..<endIndex])
        }
        return ""
    }
    
}
