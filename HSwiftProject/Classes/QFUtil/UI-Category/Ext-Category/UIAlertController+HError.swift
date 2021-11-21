//
//  UIAlertController+HError.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/21.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private var alert_action_key = "alert_action_key"

extension UIAlertController {
    
    @discardableResult
    static func showAlertWithTitle(_ title: String?, message: String?, style: UIAlertController.Style, cancelButtonTitle: String?, otherButtonTitles: Array<String>?, completion: ((_ buttonIndex: Int) -> Void)?) -> UIAlertController? {

        if (UIDevice.current.systemVersion.floatValue >= 8.0) {
            let alertController = UIAlertController.init(title: title, message: message, preferredStyle: style)

            if (cancelButtonTitle != nil) {
                let cancelAction = UIAlertAction.init(title: cancelButtonTitle, style: UIAlertAction.Style.cancel) { action in
                    if (completion != nil) {
                        completion!(0);
                    }
                }
                alertController.addAction(cancelAction)
            }
            
            if (otherButtonTitles != nil && otherButtonTitles!.count > 0) {
                for i in 0..<otherButtonTitles!.count {
                    let action = UIAlertAction.init(title: otherButtonTitles![i], style: UIAlertAction.Style.default) { action in
                        if (completion != nil) {
                            let index = objc_getAssociatedObject(action, &alert_action_key) as! NSNumber;
                            completion!(index.intValue);
                        }
                    }
                    objc_setAssociatedObject(action, &alert_action_key, NSNumber.init(value: i+1), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    alertController.addAction(action)
                }
            }
            
            let rootController = UIApplication.shared.keyWindow?.rootViewController
            DispatchQueue.main.async {
                if ((rootController?.isKind(of: UIViewController.self)) != nil) {
                    rootController?.present(alertController, animated: true, completion: nil)
                }
            }
            return alertController
        }
        
        return nil
    }

    @discardableResult
    static func showAlertWithMessage(_ message: String, cancel: (() -> Void)?) -> UIAlertController? {
        let alertController = UIAlertController.init(title: "温馨提醒", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: "取消", style: .cancel) { action in
            if (cancel != nil) {
                cancel!()
            }
        }
        alertController.addAction(cancel)
        UIApplication.shared.getKeyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        
        return alertController
    }
}
