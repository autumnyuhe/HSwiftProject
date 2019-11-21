//
//  UIViewController+HDisappear.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/21.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import SwizzleSwift

enum HVCDisappearType : Int {
    case other   = 0
    case push    = 1
    case pop     = 2
    case dismiss = 3
}

extension UIViewController {
    
    @objc class func swizzle() -> Void {
        Swizzle(UIViewController.self) {
            #selector(dismiss(animated:completion:)) <-> #selector(pvc_dismiss(animated:completion:))
        }
    }
    
    @objc open func pvc_dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.dismiss(animated: flag, completion: completion)
        if (self.navigationController?.viewControllers.count)! > 0 {
            let viewControllers = (self.navigationController?.viewControllers)!
            for item in viewControllers {
                let vc = item as UIViewController
                vc.vcWillDisappear(.dismiss)
            }
        }else {
            self.vcWillDisappear(.dismiss)
        }
    }
    
    func vcWillDisappear(_ type: HVCDisappearType) -> Void { }

}

extension UINavigationController {
    
    @objc override class func swizzle() -> Void {
        Swizzle(UIViewController.self) {
            #selector(popViewController(animated:)) <-> #selector(disappear_popViewController(animated:))
            #selector(pushViewController(_:animated:)) <-> #selector(disappear_pushViewController(_:animated:))
        }
    }
    
    @objc open func disappear_popViewController(animated: Bool) -> UIViewController? {
        let popVC = self.disappear_popViewController(animated: animated)
        if (popVC?.isKind(of: UIViewController.self))! {
            popVC?.vcWillDisappear(.pop)
        }
        return popVC
    }
    
    @objc open func disappear_pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (self.topViewController?.isKind(of: UIViewController.self))! {
            self.topViewController?.vcWillDisappear(.push)
        }
        self.disappear_pushViewController(viewController, animated: animated)
    }

}
