//
//  UIButton+HUtil.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/19.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension UIButton {

    open var text: String? {
        get { return self.title(for: .normal) }
        set { self.setTitle(newValue, for: .normal) }
    }

    open var textFont: UIFont? {
        get { return self.titleLabel?.font }
        set { self.titleLabel?.font = newValue }
    }
    
    open var textColor: UIColor? {
        get { return self.titleColor(for: .normal) }
        set { self.setTitleColor(newValue, for: UIControl.State.normal) }
    }
    
    open var textAlignment: NSTextAlignment {
        get { return self.titleLabel?.textAlignment ?? .center }
        set { self.titleLabel?.textAlignment = newValue }
    }
    
    @objc open var image: UIImage? {
        get { return self.image(for: .normal) }
        set { self.setImage(newValue, for: UIControl.State.normal) }
    }
    
    open var backgroundImage: UIImage? {
        get { return self.backgroundImage(for: .normal) }
        set { self.setBackgroundImage(newValue, for: UIControl.State.normal) }
    }
    
    open func addTarget(_ target: Any?, action: Selector) {
        self.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
    }

    //let the min respond area is 44*44
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var bounds: CGRect = self.bounds
        let widthDelta: CGFloat = max(44.0 - bounds.width, 0)
        let heightDelta: CGFloat = max(44.0 - bounds.height, 0)
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
        self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -(self.imageView?.width ?? 0), bottom: 0, right: (self.imageView?.width)!-spacing)
        self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: (self.titleLabel?.width ?? 0)-spacing, bottom: 0, right: -(self.titleLabel?.width)!)
    }
    
    ///图上文字下
    open func imageUpAndTextDownWithSpacing(_ spacing: CGFloat) {
        self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -(self.imageView?.width ?? 0), bottom: -(self.imageView?.width ?? 0)-spacing/2, right: 0)
        self.titleEdgeInsets = UIEdgeInsets.init(top: -(self.titleLabel?.intrinsicContentSize.width ?? 0)-spacing/2, left: 0, bottom: 0, right: -(self.titleLabel?.intrinsicContentSize.width ?? 0))
    }

} 
