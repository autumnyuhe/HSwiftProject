//
//  NSObject+HExclusive.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/14.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private var kExclusiveSetKey: String = "kExclusiveSetKey"

typealias HExclusive = () -> Void

extension NSObject {
    
    private var exclusiveSet: NSMutableSet? {
        get {
            var set: NSMutableSet? = objc_getAssociatedObject(self, &kExclusiveSetKey) as? NSMutableSet
            if set == nil {
                set = NSMutableSet()
                objc_setAssociatedObject(self, &kExclusiveSetKey, set, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return set
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kExclusiveSetKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func exclusive(exc: String, delay interval: TimeInterval, exclusive: HExclusive) -> Void {
        let excString: String = String(format: "%p%@", self, exc);
        if (self.exclusiveSet!.contains(excString) == false) {
            self.exclusiveSet!.add(excString)
            if interval > 0 {
                let deadline = DispatchTime.now() + interval
                DispatchQueue.global().asyncAfter(deadline: deadline) {
                    if (self.exclusiveSet!.contains(excString) == true) {
                        self.exclusiveSet!.remove(excString)
                    }
                }
            }
            exclusive();
        }
    }
    
    func removeExclusive(_ exc: String) -> Void {
        let excString: String = String(format: "%p%@", self, exc);
        if (self.exclusiveSet!.contains(excString) == true) {
            self.exclusiveSet!.remove(excString)
        }
    }

}
