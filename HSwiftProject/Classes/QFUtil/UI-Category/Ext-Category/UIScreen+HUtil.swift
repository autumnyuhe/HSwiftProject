//
//  UIScreen+HUtil.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/19.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension UIScreen {
    
    static var bound: CGRect = {
        return UIScreen.main.bounds
    }()
        
    static var size: CGSize = {
        return UIScreen.main.bounds.size
    }()
        
    static var height: CGFloat = {
        return UIScreen.main.bounds.size.height
    }()
        
    static var width: CGFloat = {
        return UIScreen.main.bounds.size.width
    }()
        
    static var onePixel: CGFloat = {
        if UIScreen.main.responds(to: #selector(getter: nativeScale)) {
            return 1.0 / UIScreen.main.nativeScale
        }else {
            return 1.0 / UIScreen.main.scale
        }
    }()

}
