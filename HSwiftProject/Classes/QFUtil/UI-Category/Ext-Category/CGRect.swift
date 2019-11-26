//
//  CGRect.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/19.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension CGRect {
    
    @available(iOS 2.0, *)
    var x: CGFloat {
        get { return self.origin.x }
        set { self.origin.x = newValue }
    }
    
    @available(iOS 2.0, *)
    var y: CGFloat {
        get { return self.origin.y }
        set { self.origin.y = newValue }
    }
    
    @available(iOS 2.0, *)
    public var width: CGFloat {
        get { return self.size.width }
        set { self.size.width = newValue }
    }
    
    @available(iOS 2.0, *)
    public var height: CGFloat {
        get { return self.size.height }
        set { self.size.height = newValue }
    }
    
}
