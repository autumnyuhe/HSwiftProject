//
//  HPresentationController.swift
//  HSwiftProject
//
//  Created by Wind on 22/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

class HPresentationController : UIPresentationController {
    //蒙层
    private var _contentCoverView: UIView?
    var contentCoverView: UIView {
        if (_contentCoverView == nil) {
            _contentCoverView = UIView.init(frame: self.containerView?.bounds ?? CGRectZero)
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismissAction))
            _contentCoverView!.addGestureRecognizer(tap)
        }
        return _contentCoverView!
    }
    //蒙层颜色
    private var _shadowColor: UIColor?
    var shadowColor: UIColor? {
        get {
            return _shadowColor!
        }
        set {
            _shadowColor = newValue
            if (_shadowColor == nil) {
                _shadowColor = UIColor.init(white: 0.1, alpha: 0.2)
            }
            _contentCoverView?.backgroundColor = _shadowColor
        }
    }
    //弹出框类型
    private var _presentType: HTransitionStyle = .alert
    var presentType: HTransitionStyle {
        get {
            return _presentType
        }
        set {
            _presentType = newValue
        }
    }
    //内容层大小
    private var _contentSize: CGSize = CGSizeZero
    @objc var contentSize: CGSize {
        get {
            return _contentSize
        }
        set {
            _contentSize = newValue
        }
    }
    ///点击阴影是否关闭页面
    private var _isShadowDismiss: Bool = false
    @objc var isShadowDismiss: Bool {
        get {
            return _isShadowDismiss
        }
        set {
            _isShadowDismiss = newValue
        }
    }

    // 重写UIPresentationController的方法
    //重写构造方法
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        // 在自定义动画效果的情况下，苹果强烈建议设置为 UIModalPresentationCustom自定义
        presentedViewController.modalPresentationStyle = .custom;
    }

    // 呈现过渡即将开始的时候被调用的
    // 可以在此方法创建和设置自定义动画所需的view
    override func presentationTransitionWillBegin() {
        //将蒙版插入最下面
        self.containerView?.insertSubview(self.contentCoverView, at: 0)
        // 获取presentingViewController 的转换协调器，应该动画期间的一个类？上下文？之类的，负责动画的一个东西
        let transitionCoordinator = self.presentingViewController.transitionCoordinator
       // 动画期间，背景View的动画方式
        self.contentCoverView.alpha = 0.0
        transitionCoordinator?.animateAlongsideTransition(in: nil, animation: { context in
            self.contentCoverView.alpha = 1.0
        }, completion: nil)
    }

    // 在呈现过渡结束时被调用的，并且该方法提供一个布尔变量来判断过渡效果是否完成
    override func presentationTransitionDidEnd(_ completed: Bool) {
        //NSLog(@"过渡结束");
    }

    // 消失过渡即将开始的时候被调用的
    override func dismissalTransitionWillBegin() {
        self.contentCoverView.alpha = 0.0
    }

    // 消失过渡完成之后调用，此时应该将视图移除
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if (completed) {
            self.presentedView?.removeFromSuperview()
            //去掉蒙版
            self.contentCoverView.removeFromSuperview()
            self._contentCoverView = nil
        }
    }

    //设置要显示的view的frame(布局）
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        self.presentedView?.frame = self.frameOfPresentedViewInContainerView
        self.contentCoverView.frame = self.containerView?.bounds ?? CGRectZero
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        var makeRect = CGRectZero;
        if (self.presentType == HTransitionStyle.alert) {
            makeRect = CGRectMake(self.containerView!.center.x - self.contentSize.width * 0.5,
                                  self.containerView!.center.y - self.contentSize.height * 0.5,
                                  self.contentSize.width,
                                  self.contentSize.height);
            
        }else if (self.presentType == HTransitionStyle.sheet) {
            if (self.contentSize.equalTo(CGSizeZero)) {
                self.contentSize = self.containerView!.size
            }
            if (self.contentSize.width == 0 && self.contentSize.height > 0) {
                self.contentSize = CGSizeMake(self.containerView!.bounds.width, self.contentSize.height);
            }
            makeRect = CGRectMake(self.containerView!.bounds.size.width - self.contentSize.width,
                                  self.containerView!.bounds.size.height - self.contentSize.height,
                                  self.contentSize.width,
                                  self.contentSize.height);
        }
        return makeRect;
    }

    override var shouldPresentInFullscreen: Bool {
        return false
    }

    override var shouldRemovePresentersView: Bool {
        return false
    }

    @objc private func dismissAction() {
        if (self.isShadowDismiss) {
            self.presentedViewController.dismiss(animated: true, completion: nil)
        }
    }

}
