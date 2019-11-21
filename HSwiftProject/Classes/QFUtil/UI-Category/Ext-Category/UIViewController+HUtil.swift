//
//  UIViewController+HUtil.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/20.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension UIViewController {

    /**
    *  将UIViewController的类名作为NibName，使用initWithNibName方法，返回UIViewController对象
    */
    static func viewWithNibName(nibName: String) -> UIViewController {
        return self.init(nibName:NSStringFromClass(self.classForCoder()), bundle: nil)
    }

    /**
    *  键盘通知
    */
    func addKeyboardObserver() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() -> Void {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    @objc private func keyboardWillShow(_ notification: NSNotification) -> Void {
        if self.isViewInBackground() {
            return
        }
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let aValue: NSValue = userInfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRect: CGRect = aValue.cgRectValue
        
        let animationDurationValue: NSValue = userInfo.object(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as! NSValue
        var animationDuration: TimeInterval = 0
        animationDurationValue.getValue(&animationDuration)
        
        self.keyboardWillShowWithRect(keyboardRect, animationDuration: CGFloat(animationDuration))
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) -> Void {
        if self.isViewInBackground() {
            return
        }
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let aValue: NSValue = userInfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRect: CGRect = aValue.cgRectValue
        
        let animationDurationValue: NSValue = userInfo.object(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as! NSValue
        var animationDuration: TimeInterval = 0
        animationDurationValue.getValue(&animationDuration)
        
        self.keyboardWillHideWithRect(keyboardRect, animationDuration: CGFloat(animationDuration))
    }

    /**
    *  键盘通知回调事件，主要用于子类重写
    *
    *  @param keyboardRect 键盘rect
    *  @param duration     键盘弹出动画的时间
    */
    func keyboardWillShowWithRect(_ keyboardRect: CGRect, animationDuration duration: CGFloat) -> Void { }
    
    func keyboardWillHideWithRect(_ keyboardRect: CGRect, animationDuration duration: CGFloat) -> Void { }

    /**
    *  点击背景self.view的时候，关闭键盘
    */
    func hideKeyboardWhenTapBackground() -> Void {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(viewTapped(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }

    @objc private func viewTapped(_ recognizer: UITapGestureRecognizer) -> Void {
        UIApplication.hideKeyboard()
    }

    /**
    *  判断当前ViewController是否在顶部显示
    */
    func isViewInBackground() -> Bool {
        return self.isViewLoaded && self.view.window == nil
    }

}
