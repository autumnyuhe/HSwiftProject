//
//  HObject.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/26.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class NSInt: NSObject {
    var intValue: Int = 0
    required init(value: Int) {
        super.init()
        self.intValue = value
    }
}

class NSSize: NSObject {
    var sizeValue: CGSize = CGSizeZero
    required init(size: CGSize) {
        super.init()
        self.sizeValue = size
    }
    required init(width: CGFloat, height: CGFloat) {
        super.init()
        self.sizeValue = CGSize(width: width, height: height)
    }
}

class NSEdgeInsets: NSObject {
    var edgeInsetsValue: UIEdgeInsets = UIEdgeInsetsZero
    required init(edgeInsets: UIEdgeInsets) {
        super.init()
        self.edgeInsetsValue = edgeInsets
    }
    required init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        super.init()
        self.edgeInsetsValue = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
}

class NSItem: NSObject {
    var itemBlock: HTupleItem!
}

class NSHeader: NSObject {
    var headerBlock: HTupleHeader!
}

class NSFooter: NSObject {
    var footerBlock: HTupleFooter!
}

extension CGSize {
    var sizeValue: NSSize {
        return NSSize(size: self)
    }
}

extension UIEdgeInsets {
    var edgeInsetsValue: NSEdgeInsets {
        return NSEdgeInsets(edgeInsets: self)
    }
}
