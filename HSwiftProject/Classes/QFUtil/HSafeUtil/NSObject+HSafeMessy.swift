//
//  NSObject+HSafeMessy.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/21.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension NSNull {
    static var stringValue = ""
    var stringValue: String {
        return ""
    }
        
    static var length = 0
    var length: Int {
        return 0
    }
    
    static var isEmpty = true
    var isEmpty: Bool {
        return true
    }
}

extension NSNumber {
    var length: Int {
        return self.stringValue.length
    }
    var isEmpty: Bool {
        return self.stringValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }
}

extension NSString {
    var stringValue: NSString {
        return self
    }
    var isEmpty: Bool {
        return self.stringValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }
}

extension String {
    var stringValue: String {
        return self
    }
}
