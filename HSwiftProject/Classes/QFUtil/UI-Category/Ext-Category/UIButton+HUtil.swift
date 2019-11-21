//
//  UIButton+HUtil.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/19.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension UIButton {

    open func setTitle(_ title: String?) {
        self.setTitle(title, for: UIControl.State.normal)
    }
    
    open func setTitleColor(_ color: UIColor?) {
        self.setTitleColor(color, for: UIControl.State.normal)
    }
    
    open func setFont(_ font: UIFont) {
        self.titleLabel?.font = font
    }
    
    open func setTextAlignment(_ textAlignment: NSTextAlignment) {
        self.titleLabel?.textAlignment = textAlignment
    }
    
    @objc  open func setImage(_ image: UIImage?) {
        self.setImage(image, for: UIControl.State.normal)
    }
    
    open func setBackgroundImage(_ image: UIImage?) {
        self.setBackgroundImage(image, for: UIControl.State.normal)
    }
    
    open func addTarget(_ target: Any?, action: Selector) {
        self.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
    }

    //let the min respond area is 44*44
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var bounds: CGRect = self.bounds
        let widthDelta: CGFloat = max(44.0 - bounds.size.width, 0)
        let heightDelta: CGFloat = max(44.0 - bounds.size.height, 0)
        bounds = bounds.insetBy(dx: -0.5 * widthDelta, dy: -0.5 * heightDelta)
        return bounds.contains(point)
    }

    ///图左文字右
    open func imageAndTextWithSpacing(_ spacing: CGFloat) {
        self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: spacing)
        self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: spacing, bottom: 0, right: 0)
    }

    ///图右文字左
    open func textAndImageWithSpacing(_ spacing: CGFloat) {
        self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -(self.imageView?.frame.size.width)!, bottom: 0, right: (self.imageView?.frame.size.width)!-spacing)
        self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: (self.titleLabel?.bounds.size.width)!-spacing, bottom: 0, right: -(self.titleLabel?.bounds.size.width)!)
    }
    
    ///图上文字下
    open func imageUpAndTextDownWithSpacing(_ spacing: CGFloat) {
        self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -(self.imageView?.frame.size.width)!, bottom: -(self.imageView?.frame.size.width)!-spacing/2, right: 0)
        self.titleEdgeInsets = UIEdgeInsets.init(top: -(self.titleLabel?.intrinsicContentSize.width)!-spacing/2, left: 0, bottom: 0, right: -(self.titleLabel?.intrinsicContentSize.width)!)
    }

} 
