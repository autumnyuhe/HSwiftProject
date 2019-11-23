//
//  AppDelegate+HUtil.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/21.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    static var shouldAutorotate: Bool {
        get { self.getAssociatedValueForKey(#function) as! Bool }
        set { self.setAssociateWeakValue(newValue, key: #function) }
    }
    
    @available(iOS 6.0, *)
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        if (AppDelegate.shouldAutorotate) {
//            return [.portrait, .landscapeLeft, .landscapeRight]
//        }
//        return .portrait
        return [.portrait, .landscapeLeft, .landscapeRight]
    }
}
