//
//  UIAlertController+HError.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/21.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func showAlertWithMessage(_ message: String, cancel: @escaping () -> Void) -> Void {
        let alertController = UIAlertController.init(title: "温馨提醒", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: "取消", style: .cancel) { action in
            cancel()
        }
        alertController.addAction(cancel)
        UIApplication.shared.getKeyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
