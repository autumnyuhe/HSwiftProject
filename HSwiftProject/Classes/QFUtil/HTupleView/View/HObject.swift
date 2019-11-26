//
//  HObject.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/26.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HObject: NSObject {
    
    var intValue: Int = 0
    var sizeValue: CGSize = CGSizeZero
    var edgeInsetsValue: UIEdgeInsets = UIEdgeInsetsZero
    
    required init(value: Int) {
        super.init()
        self.intValue = value
    }

    required init(size: CGSize) {
        super.init()
        self.sizeValue = size
    }
    required init(width: CGFloat, height: CGFloat) {
        super.init()
        self.sizeValue = CGSize(width: width, height: height)
    }

    required init(edgeInsets: UIEdgeInsets) {
        super.init()
        self.edgeInsetsValue = edgeInsets
    }
    required init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        super.init()
        self.edgeInsetsValue = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
}

extension CGSize {
    var hObject: HObject {
        return HObject(size: self)
    }
}

extension UIEdgeInsets {
    var hObject: HObject {
        return HObject(edgeInsets: self)
    }
}
