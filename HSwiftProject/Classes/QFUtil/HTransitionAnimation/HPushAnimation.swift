//
//  HPushAnimation.swift
//  HSwiftProject
//
//  Created by Wind on 23/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

class HPushAnimation : HTransitionAnimation {
    
    var pushAnimationType: HPushAnimationType = .ocdoor

    // 重写父类方法
    override func startPushAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        switch (pushAnimationType) {
        case .ocdoor:
            self.animationForPushView(transitionContext)
            break;
        }
    }
    override func startPopAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        switch (pushAnimationType) {
        case .ocdoor:
            self.animationForPopView(transitionContext)
            break;
        }
    }

    override func endPushAnimation() {
        if (self.transitionCompletion != nil) {
            self.transitionCompletion!(.push)
        }
    }
    override func endPopAnimation() {
        if (self.transitionCompletion != nil) {
            self.transitionCompletion!(.pop)
        }
    }

    // 自定义动画实现方法
    //弹出动画，开关门动画
    func animationForPushView(_ transitionContext: UIViewControllerContextTransitioning) {
        //取出转场前后视图控制器上的视图view
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        let containerView = transitionContext.containerView
        //左侧动画视图
        let leftView: UIView = UIView.init(frame: CGRectMake(-toView!.width/2, 0, toView!.width/2, toView!.height))
        leftView.clipsToBounds = true
        leftView.addSubview(toView!)
        //右侧动画视图
        // 使用系统自带的snapshotViewAfterScreenUpdates:方法，参数为YES，代表视图的属性改变渲染完毕后截屏，参数为NO代表立刻将当前状态的视图截图
        let rightToView: UIView = toView!.snapshotView(afterScreenUpdates: true)!
        rightToView.frame = CGRectMake(-toView!.width/2, 0, toView!.width, toView!.height);
        let rightView: UIView = UIView.init(frame: CGRectMake(toView!.width, 0, toView!.width/2, toView!.height))
        rightView.clipsToBounds = true
        rightView.addSubview(rightToView)
        
        //加入动画视图
        containerView.addSubview(fromView!)
        containerView.addSubview(leftView)
        containerView.addSubview(rightView)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .transitionFlipFromRight) {
            leftView.frame = CGRectMake(0, 0, toView!.width/2, toView!.height);
            rightView.frame = CGRectMake(toView!.width/2, 0, toView!.width/2, toView!.height);
        } completion: { finished in
            //由于加入了手势交互转场，所以需要根据手势动作是否完成/取消来做操作
            transitionContext.completeTransition(transitionContext.transitionWasCancelled)
            if (transitionContext.transitionWasCancelled) {
                //手势取消
            }else {
                //手势完成
                containerView.addSubview(toView!)
            }
            leftView.removeFromSuperview()
            rightView.removeFromSuperview()
            toView!.isHidden = false
        }
    }

    // 弹框消失
    func animationForPopView(_ transitionContext: UIViewControllerContextTransitioning) {
        //取出转场前后视图控制器上的视图view
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)

        let containerView = transitionContext.containerView

        //左侧动画视图
        let leftFromView = fromView!.snapshotView(afterScreenUpdates: false)
        let leftView = UIView.init(frame: CGRectMake(0, 0, fromView!.width/2, fromView!.height))
        leftView.clipsToBounds = true
        leftView.addSubview(leftFromView!)
        //右侧动画视图
        let rightFromView = fromView!.snapshotView(afterScreenUpdates: false)
        rightFromView!.frame = CGRectMake(-fromView!.width/2, 0, fromView!.width, fromView!.height);
        let rightView = UIView.init(frame: CGRectMake(fromView!.width/2, 0, fromView!.width/2, fromView!.height))
        rightView.clipsToBounds = true
        rightView.addSubview(rightFromView!)

        containerView.addSubview(toView!)
        containerView.addSubview(leftView)
        containerView.addSubview(rightView)

        fromView!.isHidden = true
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .transitionFlipFromRight) {
            leftView.frame = CGRectMake(-fromView!.width/2, 0, fromView!.width/2, fromView!.height);
            rightView.frame = CGRectMake(fromView!.width, 0, fromView!.width/2, fromView!.height);
        } completion: { finished in
            fromView!.isHidden = false
            leftView.removeFromSuperview()
            rightView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }

}
