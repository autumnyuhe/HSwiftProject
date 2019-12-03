//
//  UIGestureRecognizer+HUtil.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/19.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private var gesture_block_key = "gesture_block_key"

typealias HGestureBlock = (_ sender: AnyObject) -> Void

class UIGestureRecognizerBlockTarget : NSObject {

    private var gestureBlock: HGestureBlock? = nil
    private let block: HGestureBlock? = nil
    
    private func invoke(_ sender: AnyObject) {
        if self.block != nil {
            self.block!(sender)
        }
    }

    convenience init(block: @escaping HGestureBlock) {
        self.init()
        gestureBlock = block
    }
    
}

extension UIGestureRecognizer {
    
    convenience init(block: @escaping HGestureBlock) {
        self.init()
        self.addActionBlock(block)
    }

    private func addActionBlock(_ block: @escaping HGestureBlock) {
        let target: UIGestureRecognizerBlockTarget = UIGestureRecognizerBlockTarget.init(block: block)
        self.addTarget(target, action: NSSelectorFromString("invoke:"))
        let targets: NSMutableArray = self.allGestureRecognizerBlockTargets()
        targets.add(target)
    }
    
    func removeAllActionBlocks() {
        let targets: NSMutableArray = self.allGestureRecognizerBlockTargets()
        targets.enumerateObjects { (target, idx, stop) in
            self.removeTarget(targets, action: NSSelectorFromString("invoke:"))
        }
        targets.removeAllObjects()
    }

    func allGestureRecognizerBlockTargets() -> NSMutableArray {
        var targets: NSMutableArray? = (objc_getAssociatedObject(self, &gesture_block_key) as! NSMutableArray)
        if targets == nil {
            targets = NSMutableArray()
            objc_setAssociatedObject(self, &gesture_block_key, targets, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return targets!
    }

}
