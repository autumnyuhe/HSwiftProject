//
//  NSObject+HSelector.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension NSObject {
    func responds(to aSelector: Selector!, withPre prefix: String) -> Bool {
        let selectorString = prefix+NSStringFromSelector(aSelector)
        let selector = NSSelectorFromString(selectorString)
        return self.responds(to: selector)
    }
}
