//
//  NSObject+HUtil.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/16.
//  Copyright © 2019 wind. All rights reserved.
//

import Foundation

extension NSObject {
 
    //返回className
    var className: String {
        get{
            let name = type(of: self).description()
            if name.contains(".") {
                return name.components(separatedBy: ".")[1]
            }else {
                return name
            }
            
        }
    }
    
}
