//
//  UIView+HUtil.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/16.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension UIView {
    public func isSystemClass(_ aClass: AnyClass ) -> Bool {
        let bundle: Bundle = Bundle.init(for: aClass)
        if bundle == Bundle.main {
            return false
        }else {
            return true
        }
    }
}
