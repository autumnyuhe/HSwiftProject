//
//  UIView+HUtil.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/16.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private let TIPS_IMAGE_VIEW_TAG = 10000
private let TIPS_LABEL_TAG = 10001

private var topLineLayerKey = "topLineLayerKey"
private var bottomLineLayerKey = "bottomLineLayerKey"
private var userInfoAddressKey = "userInfoAddressKey"

extension UIView {
    
    /**
    *  根据nib name返回UIView
    */
    static func viewWithNibName(nibName: String) -> UIView {
        return Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as! UIView
    }
    
    /**
    *  根据nib创建一个view，nib name为ClassName
    */
    static func viewFromNib() -> UIView {
        return Bundle.main.loadNibNamed(NSStringFromClass(self.classForCoder()), owner: nil, options: nil)?.first as! UIView
    }
    
 
    @available(iOS 2.0, *)
    var x: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    
    @available(iOS 2.0, *)
    var y: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    
    @available(iOS 2.0, *)
    public var width: CGFloat {
        get { return self.frame.size.width }
        set { self.frame.size.width = newValue }
    }
    
    @available(iOS 2.0, *)
    public var height: CGFloat {
        get { return self.frame.size.height }
        set { self.frame.size.height = newValue }
    }
    
    @available(iOS 2.0, *)
    public var origin: CGPoint {
        get { return self.frame.origin }
        set { self.frame.origin = newValue }
    }
    
    @available(iOS 2.0, *)
    public var size: CGSize {
        get { return self.frame.size }
        set { self.frame.size = newValue }
    }
    
    @available(iOS 2.0, *)
    var centerX: CGFloat {
        get { return self.center.x }
        set { self.center = CGPoint(x: newValue, y: self.center.y) }
    }
    
    @available(iOS 2.0, *)
    var centerY: CGFloat {
        get { return self.center.x }
        set { self.center = CGPoint(x: self.center.y, y: newValue) }
    }
    
    @available(iOS 2.0, *)
    var minX: CGFloat {
        return self.frame.minX
    }

    @available(iOS 2.0, *)
    var minY: CGFloat {
        return self.frame.minY
    }

    @available(iOS 2.0, *)
    var midX: CGFloat {
        return self.frame.midX
    }
    
    @available(iOS 2.0, *)
    var midY: CGFloat {
        return self.frame.midY
    }

    @available(iOS 2.0, *)
    var maxX: CGFloat {
        return self.frame.maxX
    }
    
    @available(iOS 2.0, *)
    var maxY: CGFloat {
        return self.frame.maxY
    }

    /**
    *  根据传入的width来水平居中
    */
    func horizontalCenterWithWidth(_ width: CGFloat) {
        self.x = CGFloat(ceilf(Float((width - self.width)/2)))
    }

    /**
    *  根据传入的height来竖直居中
    */
    func verticalCenterWithHeight(_ height: CGFloat) {
        self.x = CGFloat(ceilf(Float((height - self.height)/2)))
    }
    
    func horizontalCenterInSuperView() {
        if self.superview != nil {
            self.horizontalCenterWithWidth(self.superview!.width)
        }
    }
    
    func verticalCenterInSuperView() {
        if self.superview != nil {
            self.verticalCenterWithHeight(self.superview!.height)
        }
    }
    
    /**
    *  添加双击事件
    */
    func addDoubleTapGestureWithBlock(block: @escaping HGestureBlock) -> UITapGestureRecognizer {
        self.addTapGestureWithNumberOfTapsRequired(2, block: block)
    }

    private func addTapGestureWithNumberOfTapsRequired(_ numberOfTapsRequired: Int, block: @escaping HGestureBlock) -> UITapGestureRecognizer {
        self.isUserInteractionEnabled = true
        let recognizer: UITapGestureRecognizer = UITapGestureRecognizer.init(block: block)
        recognizer.numberOfTapsRequired = numberOfTapsRequired
        self.addGestureRecognizer(recognizer)
        return recognizer
        
    }
    
    /**
    *  添加单击事件，多次调用只会持有一个UITapGestureRecognizer对象，之前的会被清除
    */
    func addSingleTapGestureWithBlock(block: @escaping HGestureBlock) -> UITapGestureRecognizer {
        for item in self.gestureRecognizers! {
            let gesture: UIGestureRecognizer = item
            if gesture.isKind(of: UITapGestureRecognizer.self) {
                self.removeGestureRecognizer(gesture)
            }
        }
        return self.addTapGestureWithNumberOfTapsRequired(1, block: block)
    }
    
    func addSingleTapGestureTarget(target: AnyObject, action: Selector) -> UITapGestureRecognizer {
        self.isUserInteractionEnabled = true
        for item in self.gestureRecognizers! {
            let gesture: UIGestureRecognizer = item
            if gesture.isKind(of: UITapGestureRecognizer.self) {
                self.removeGestureRecognizer(gesture)
            }
        }
        let recognizer: UITapGestureRecognizer = UITapGestureRecognizer.init(target: target, action: action)
        self.addGestureRecognizer(recognizer)
        return recognizer
    }

    /**
    *  设置UIView的顶部和底部边线，一般用在设置界面
    */
    var topLineLayer: CALayer? {
        get { objc_getAssociatedObject(self, &topLineLayerKey) as? CALayer }
        set { objc_setAssociatedObject(self, &topLineLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var bottomLineLayer: CALayer? {
        get { objc_getAssociatedObject(self, &bottomLineLayerKey) as? CALayer }
        set { objc_setAssociatedObject(self, &bottomLineLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /**
     *  添加一个SubLayer
     */
    func addSubLayerWithFrame(_ frame: CGRect, color: UIColor) -> CALayer {
        let layer: CALayer = CALayer()
        layer.frame = frame
        layer.backgroundColor = color.cgColor
        self.layer.addSublayer(layer)
        return layer
    }

    func setTopFillLineWithColor(_ color: UIColor) -> Void {
        self.setTopLineWithColor(color, paddingLeft: 0, paddingRight: 0)
    }

    func setTopLineWithColor(_ color: UIColor, paddingLeft: CGFloat, paddingRight: CGFloat) -> Void {
        let frame: CGRect = CGRect(x: paddingLeft, y: 0, width: UIScreen.width-paddingLeft-paddingRight, height: UIScreen.onePixel)
        if self.topLineLayer == nil {
            self.topLineLayer = self.addSubLayerWithFrame(frame, color: color)
        }else {
            self.topLineLayer?.frame = frame
            self.topLineLayer?.backgroundColor = color.cgColor
        }
        
    }

    func setBottomFillLineWithColor(_ color: UIColor) -> Void {
        self.setBottomLineWithColor(color, paddingLeft: 0, paddingRight: 0)
    }

    
    func setBottomLineWithColor(_ color: UIColor, paddingLeft: CGFloat, paddingRight: CGFloat) -> Void {
        let frame: CGRect = CGRect(x: paddingLeft, y: self.frame.height-UIScreen.onePixel, width: UIScreen.width-paddingLeft-paddingRight, height: UIScreen.onePixel)
        if self.bottomLineLayer == nil {
            self.bottomLineLayer = self.addSubLayerWithFrame(frame, color: color)
        }else {
            self.bottomLineLayer?.frame = frame
            self.bottomLineLayer?.backgroundColor = color.cgColor
        }
        
    }

    func setTopAndBottomLineWithColor(_ color: UIColor) -> Void {
        self.setTopFillLineWithColor(color)
        self.setBottomFillLineWithColor(color)
    }

    /**
    *  设置UIView的顶部和底部边线，一般用在设置界面，当界面采用AutoLayout时使用
    */
    func setTopLineViewWithColor(_ color: UIColor, paddingLeft: CGFloat, paddingRight: CGFloat) -> UIView {
        var frame: CGRect = self.frame
        frame.origin = CGPoint(x: 0, y: 0)
        frame.x += paddingLeft
        frame.width -= paddingLeft + paddingRight
        frame.y = frame.height - UIScreen.onePixel
        frame.height = UIScreen.onePixel
        return self.addSubviewWithColor(color, frame: frame)
    }

    func setBottomLineViewWithColor(_ color: UIColor, paddingLeft: CGFloat, paddingRight: CGFloat) -> UIView {
        var frame: CGRect = self.frame
        frame.origin = CGPoint(x: 0, y: 0)
        frame.x += paddingLeft
        frame.width -= paddingLeft + paddingRight
        frame.y = frame.height - UIScreen.onePixel
        frame.height = UIScreen.onePixel
        return self.addSubviewWithColor(color, frame: frame)
    }

    func addSubviewWithColor(_ color: UIColor, frame: CGRect) -> UIView {
        let line: UIView = UIView()
        line.frame = frame
        line.backgroundColor = color
        self.addSubview(line)
        return line
    }

    
    var userInfo: AnyObject? {
        get { objc_getAssociatedObject(self, &userInfoAddressKey) as? CALayer }
        set { objc_setAssociatedObject(self, &userInfoAddressKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /**
    *  返回它所在的ViewController
    */
    var viewController: UIViewController? {
        var next = self.next
        var controller: UIViewController?
        while next?.isKind(of: UIViewController.self) == false {
            next = next?.next
            if next == nil {
                break
            }
        }
        if next?.isKind(of: UIViewController.self) == true {
            controller = next as? UIViewController
        }
        return controller
    }

    /**
    *  设置边框宽度和颜色
    */
    func setBoarderWith(_ width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }

    func setCornerRadius(_ cornerRadius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
    }

    /**
    *  设置圆角
    */
    var cornerRadius: CGFloat {
        return self.layer.cornerRadius
    }
        

    /**
    *  主要用于UITableView，UIScrollView，UICollectionView等列表类的View，
    *  在数据为空时，显示一个提示性的图像和文字
    */
    func setTipsViewWithImageName(_ imageName: String, text: String, textColor: UIColor) -> Void {
        var imageView: UIImageView? = self.viewWithTag(TIPS_IMAGE_VIEW_TAG) as? UIImageView
        if imageView == nil {
            imageView = UIImageView(image: UIImage(named: imageName))
        }
        imageView?.center = CGPoint(x: self.width/2, y: self.height/2-40)
        imageView?.contentMode = .center
        imageView?.tag = TIPS_IMAGE_VIEW_TAG
        self.addSubview(imageView!)
        
        var label: UILabel? = self.viewWithTag(TIPS_IMAGE_VIEW_TAG) as? UILabel
        if label == nil {
            label = UILabel(frame: CGRect(x: 0, y: imageView!.maxY+10, width: UIScreen.width, height: 20))
        }
        label?.font = UIFont.systemFont(ofSize: 16)
        label?.textColor = textColor
        label?.text = text
        label?.textAlignment = .center
        label?.tag = TIPS_LABEL_TAG
        self.addSubview(label!)
    }

    func removeTipsView() -> Void {
        self.viewWithTag(TIPS_IMAGE_VIEW_TAG)?.removeFromSuperview()
        self.viewWithTag(TIPS_LABEL_TAG)?.removeFromSuperview()
    }


    ///设置视图上边角幅度
    func setCornerRadiiOnTop(_ radii: CGFloat) {
        self.setGivenCorner([.topLeft, .topRight], radii: radii)
    }

    ///设置视图下边角幅度
    func setCornerRadiiOnBottom(_ radii: CGFloat) {
        self.setGivenCorner([.bottomLeft, .bottomRight], radii: radii)
    }
    
    ///设置指定角的角幅度
    func setGivenCorner(_ corners: UIRectCorner, radii: CGFloat) {
        let maskPath: UIBezierPath = UIBezierPath.init(roundedRect: self.bounds,
                                                       byRoundingCorners: corners,
                                                       cornerRadii: CGSize.init(width: radii, height: radii))
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }

    ///设置视图所有角幅度
    func setAllCornerRadii(_ radii: CGFloat) {
        let maskPath: UIBezierPath = UIBezierPath.init(roundedRect: self.bounds,
                                                       cornerRadius: radii)
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    ///去掉视图所有角幅度
    func setNoneCorner() {
        self.layer.mask = nil
    }

    /**
    *  生成快照图像
    */
    func snapshotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let snap: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return snap
    }

    func snapshotImageWithFrame(_ frame: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, self.isOpaque, 0.0)
        let context: CGContext  = UIGraphicsGetCurrentContext()!
        context.translateBy(x: -frame.origin.x, y: -frame.origin.y)
        self.layer.render(in: context)
        context.translateBy(x: frame.origin.x, y: frame.origin.y);
        let theImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return theImage
    }
    
}
