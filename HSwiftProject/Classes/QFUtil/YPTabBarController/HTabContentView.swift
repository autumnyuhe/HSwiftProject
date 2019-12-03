//
//  HTabContentView.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/30.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import SwizzleSwift

private let kContentOffset = "contentOffset"
private var h_hasBeenDisplayedKey = "h_hasBeenDisplayedKey"
private var h_hasAddedContentOffsetObserverKey = "h_hasAddedContentOffsetObserverKey"
private var h_willAppearInjectBlockKey = "h_willAppearInjectBlockKey"

typealias _HViewControllerWillAppearInjectBlock = (_ viewController: UIViewController, _ animated: Bool) -> Void

extension UIViewController {
    
    var h_hasBeenDisplayed: Bool {
        get {
            self.getAssociatedValueForKey(&h_hasBeenDisplayedKey) as? Bool ?? false
        }
        set {
            self.setAssociateWeakValue(newValue, key: &h_hasBeenDisplayedKey)
        }
    }
    var h_hasAddedContentOffsetObserver: Bool {
        get {
            self.getAssociatedValueForKey(&h_hasAddedContentOffsetObserverKey) as? Bool ?? false
        }
        set {
            self.setAssociateWeakValue(newValue, key: &h_hasAddedContentOffsetObserverKey)
        }
    }
    var h_willAppearInjectBlock: _HViewControllerWillAppearInjectBlock? {
        get {
            self.getAssociatedValueForKey(&h_willAppearInjectBlockKey) as? _HViewControllerWillAppearInjectBlock ?? nil
        }
        set {
            self.setAssociateValue(newValue, key: &h_willAppearInjectBlockKey)
        }
    }
    
    //以下逻辑移动到HTabBarController
//    @objc class func swizzle() {
//        Swizzle(UIViewController.self) {
//            #selector(viewWillAppear(_:)) <-> #selector(h_viewWillAppear(_:))
//        }
//    }
//
//    @objc open func h_viewWillAppear(_ animated: Bool) {
//        self.h_viewWillAppear(animated)
//        if self.h_willAppearInjectBlock != nil {
//            self.h_willAppearInjectBlock!(self, animated)
//        }
//    }
    
}

@objc protocol HTabContentViewDelegate : NSObjectProtocol {

    /**
     *  是否能切换到指定index
     */
    @objc optional func tabContentView(_ tabConentView: HTabContentView, shouldSelectTabAtIndex index: Int) -> Bool

    /**
     *  将要切换到指定index
     */
    @objc optional func tabContentView(_ tabConentView: HTabContentView, willSelectTabAtIndex index: Int)

    /**
     *  已经切换到指定index
     */
    @objc optional func tabContentView(_ tabConentView: HTabContentView, didSelectedTabAtIndex index: Int)

    /**
     *  重复点击到指定index
     */
    @objc optional func tabContentView(_ tabConentView: HTabContentView, reSelectedTabAtIndex index: Int)

    /**
     *  当设置headerView时，内容视图竖向滚动时的y坐标偏移量
     */
    @objc optional func tabContentView(_ tabConentView: HTabContentView, didChangedContentOffsetY offsetY: CGFloat)

}

class HTabContentView : UIView, UIScrollViewDelegate, HTabBarDelegate, _HTabContentScrollViewDelegate {

    private var _tabBar: HTabBar = HTabBar()
    var tabBar: HTabBar {
        get {
            return _tabBar
        }
        set {
            _tabBar = newValue
            _tabBar.delegate = self
        }
    }
    
    private var _viewControllers: NSArray?
    var viewControllers: NSArray? {
        get {
            return _viewControllers
        }
        set {
            if _viewControllers != nil {
                for item in _viewControllers! {
                    let vc = item as! UIViewController
                    if vc.h_hasAddedContentOffsetObserver {
                        vc.h_displayView.removeObserver(self, forKeyPath: kContentOffset)
                        vc.h_hasAddedContentOffsetObserver = false
                    }
                    vc.removeFromParent()
                    if vc.isViewLoaded {
                        vc.h_displayView.removeFromSuperview()
                    }
                }
            }

            _viewControllers = newValue
            
            let containerVC: UIViewController? = self.contarinerViewController

            let items = NSMutableArray()
            for item in _viewControllers! {
                let vc = item as! UIViewController
                if containerVC != nil {
                    containerVC!.addChild(vc)
                }
                
                let item = HTabItem()
                item.image = vc.h_tabItemImage
                item.selectedImage = vc.h_tabItemSelectedImage
                item.title = vc.h_tabItemTitle
                items.add(item)
            }
            self.tabBar.items = items

            // 更新scrollView的content size
            if self.contentScrollEnabled {
                self.contentScrollView.h_contentSize = CGSizeMake(self.contentScrollView.bounds.size.width * CGFloat(_viewControllers!.count),
                        self.contentScrollView.bounds.size.height)
            }
            
            if _isDefaultSelectedTabIndexSetuped {
                _selectedTabIndex = NSNotFound
                self.tabBar.selectedItemIndex = 0
            }
        }
    }
    
    weak var delegate: HTabContentViewDelegate?
    
    var headerView: UIView?

    /**
     *  第一次显示时，默认被选中的Tab的Index，在viewWillAppear方法被调用前设置有效
     */
    var defaultSelectedTabIndex: Int = 0

    /**
     *  设置被选中的Tab的Index，界面会自动切换
     */
    private var _selectedTabIndex: Int = NSNotFound
    var selectedTabIndex: Int {
        get {
            return _selectedTabIndex
        }
        set {
            self.tabBar.selectedItemIndex = newValue
        }
    }

    /**
     *  此属性仅在内容视图支持滑动时有效，它控制child view controller调用viewDidLoad方法的时机
     *  1. 值为YES时，拖动内容视图，一旦拖动到该child view controller所在的位置，立即加载其view
     *  2. 值为NO时，拖动内容视图，拖动到该child view controller所在的位置，不会立即展示其view，而是要等到手势结束，scrollView停止滚动后，再加载其view
     *  3. 默认值为NO
     */
    var loadViewOfChildContollerWhileAppear: Bool = false

    /**
     *  在此属性仅在内容视图支持滑动时有效，它控制chile view controller未选中时，是否将其从父view上面移除
     *  默认为YES
     */
    var removeViewOfChildContollerWhileDeselected: Bool = true

    private var _interceptRightSlideGuetureInFirstPage: Bool = false
    /**
    *  鉴于有些项目集成了左侧或者右侧侧边栏，当内容视图支持滑动切换时，不能实现在第一页向右滑动和最后一页向左滑动呼出侧边栏的功能，
    *  此2个属性则可以拦截第一页向右滑动和最后一页向左滑动的手势，实现呼出侧边栏的功能
    */
    var interceptRightSlideGuetureInFirstPage: Bool {
        get {
            return _interceptRightSlideGuetureInFirstPage
        }
        set {
            _interceptRightSlideGuetureInFirstPage = newValue
            self.contentScrollView.interceptRightSlideGuetureInFirstPage = newValue
        }
    }
    
    private var _interceptLeftSlideGuetureInLastPage: Bool = false
    var interceptLeftSlideGuetureInLastPage: Bool {
        get {
            return _interceptLeftSlideGuetureInLastPage
        }
        set {
            _interceptLeftSlideGuetureInLastPage = newValue
            self.contentScrollView.interceptLeftSlideGuetureInLastPage = newValue
        }
    }

    /**
     *  设置HeaderView
     *  @param headerView UIView
     *  @param needStretch 内容视图向下滚动时，headerView是否拉伸
     *  @param headerHeight headerView的默认高度
     *  @param tabBarHeight tabBar的高度
     *  @param contentViewHeight 内容视图的高度
     *  @param tabBarStopOnTopHeight 当内容视图向上滚动时，TabBar停止移动的位置
     */
    func setHeaderView(_ headerView: UIView?, needStretch: Bool, headerHeight: CGFloat, tabBarHeight: CGFloat, contentViewHeight: CGFloat, tabBarStopOnTopHeight: CGFloat) {

        if headerView == nil {
            return
        }
        self.headerView = headerView
        
        let screenSize = UIScreen.main.bounds.size
        self.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        self.headerView!.frame = CGRectMake(0, 0, self.frame.size.width, headerHeight)
        self.addSubview(self.headerView!)

        self.headerViewNeedStretch = needStretch
        self.headerViewDefaultHeight = headerHeight

        self.tabBar.frame = CGRectMake(0,
                                       self.headerView!.maxY,
                                       self.frame.size.width,
                                       tabBarHeight)

        self.contentScrollView.frame = CGRectMake(0,
                                                  0,
                                                  self.frame.size.width,
                                                  headerHeight + tabBarHeight + contentViewHeight)

        self.tabBarStopOnTopHeight = tabBarStopOnTopHeight

        let gesture1 = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let gesture2 = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        
        self.headerView!.addGestureRecognizer(gesture1)
        self.tabBar.addGestureRecognizer(gesture2)
    }

    /**
     *  设置内容视图支持滑动切换，以及点击item切换时是否有动画
     *
     *  @param enabled   是否支持滑动切换
     *  @param animated  点击切换时是否支持动画
     */
    func setContentScrollEnabled(_ enabled: Bool, tapSwitchAnimated animated: Bool) {
        if !self.contentScrollEnabled && enabled {
            self.contentScrollEnabled = enabled
            self.updateContentViewsFrame()
        }
        self.contentScrollView.isScrollEnabled = enabled
        self.contentSwitchAnimated = animated
    }

    /**
     *  获取被选中的ViewController
     */
    var selectedController: UIViewController? {
        if self.selectedTabIndex != NSNotFound {
            return self.viewControllers![self.selectedTabIndex] as? UIViewController
        }
        return nil
    }

    private var _isDefaultSelectedTabIndexSetuped: Bool = false
    private var _lastContentScrollViewOffsetX: CGFloat = 0.0
    private var _currentScrollViewOffsetY: CGFloat = 0.0

    private var _contentScrollView: _HTabContentScrollView = _HTabContentScrollView()
    private var contentScrollView: _HTabContentScrollView {
        get {
            return _contentScrollView
        }
        set {
            _contentScrollView = newValue
        }
    }

    private var headerViewDefaultHeight: CGFloat = 0.0
    private var tabBarStopOnTopHeight: CGFloat = 0.0
    private var headerViewNeedStretch: Bool = false
    
    private var contentScrollEnabled: Bool = false
    private var contentSwitchAnimated: Bool = false
    
        
    required init() {
        super.init(frame: CGRectZero)
        self._setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self._setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self._setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self._setup()
    }

    private func _setup() {
        self.backgroundColor = UIColor.white
        self.clipsToBounds = true

        _tabBar.delegate = self
        
        _contentScrollView.frame = self.frame
        _contentScrollView.isPagingEnabled = true
        _contentScrollView.isScrollEnabled = false
        _contentScrollView.showsHorizontalScrollIndicator = false
        _contentScrollView.showsVerticalScrollIndicator = false
        _contentScrollView.scrollsToTop = false
        _contentScrollView.delegate = self
        _contentScrollView.h_delegate = self
        _contentScrollView.interceptRightSlideGuetureInFirstPage = self.interceptRightSlideGuetureInFirstPage
        _contentScrollView.interceptLeftSlideGuetureInLastPage = self.interceptLeftSlideGuetureInLastPage
        self.addSubview(_contentScrollView)
    }

    override open var frame: CGRect {
        get {
            return super.frame
        }
        set {
            super.frame = newValue
            if newValue == CGRectZero {
                return
            }
            self.contentScrollView.frame = self.bounds
            self.updateContentViewsFrame()
        }
    }

    deinit {
        if self.viewControllers != nil {
            for item in self.viewControllers! {
                let controller = item as! UIViewController
                if controller.h_hasAddedContentOffsetObserver {
                    // 如果vc注册了contentOffset的观察者，需移除
                    controller.h_displayView.removeObserver(self, forKeyPath: kContentOffset)
                    controller.h_hasAddedContentOffsetObserver = false
                }
            }
        }
    }

    private func updateContentViewsFrame() {
        if self.contentScrollEnabled {
            self.contentScrollView.h_contentSize = CGSizeMake(self.contentScrollView.bounds.size.width * CGFloat(self.viewControllers!.count), self.contentScrollView.bounds.size.height)
            self.viewControllers?.enumerateObjects({ (item, idx, stop) in
                let controller = item as! UIViewController
                if controller.isViewLoaded {
                    controller.h_displayView.frame = self.frameForControllerAtIndex(idx)
                }
            })
            self.contentScrollView.scrollRectToVisible(self.selectedController!.h_displayView.frame, animated: false)
        } else {
            self.contentScrollView.h_contentSize = self.contentScrollView.bounds.size
            self.selectedController?.h_displayView.frame = self.contentScrollView.bounds
        }
    }

    private func frameForControllerAtIndex(_ index: Int) -> CGRect {
        return CGRectMake(CGFloat(index) * self.contentScrollView.bounds.size.width,
                          0,
                          self.contentScrollView.bounds.size.width,
                          self.contentScrollView.bounds.size.height)
    }

    private var contarinerViewController: UIViewController? {
        var view: UIView? = self
        while view != nil {
            let nextResponder: UIResponder? = view!.next
            if nextResponder != nil && nextResponder!.isKind(of: UIViewController.self) {
                return nextResponder as? UIViewController
            }
            view = view!.superview ?? nil
        }
        return nil
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if _isDefaultSelectedTabIndexSetuped { return }
            
        let vc: UIViewController? = self.contarinerViewController
        if #available(iOS 11.0, *) {
            if vc != nil && vc!.view.isKind(of: UIScrollView.self) {
                let scrollView = vc!.view as! UIScrollView
                scrollView.contentInsetAdjustmentBehavior = .never
            }
        }else {
            vc?.automaticallyAdjustsScrollViewInsets = false
        }
        vc?.h_willAppearInjectBlock = { [weak vc] (_ viewController: UIViewController, _ animated: Bool) in
            self.selectedTabIndex = self.defaultSelectedTabIndex
            self._isDefaultSelectedTabIndexSetuped = true
            vc?.h_willAppearInjectBlock = nil
        }
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {

        let scrollView = self.selectedController!.h_displayView as! UIScrollView
        
        if !scrollView.isKind(of: UIScrollView.self) {
            return
        }
        if gesture.state == .began {
            _currentScrollViewOffsetY = scrollView.contentOffset.y
        }
        
        let point = gesture.translation(in: self)
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: _currentScrollViewOffsetY - point.y)
        if gesture.state == .ended {
            let defaultOffsetY: CGFloat = -(self.headerViewDefaultHeight + self.tabBar.frame.size.height)
            if scrollView.contentOffset.y < defaultOffsetY {
                scrollView.scrollRectToVisible(CGRectMake(0, scrollView.frame.size.height + defaultOffsetY - 1, scrollView.frame.size.width, 1), animated:true)
            }
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if kContentOffset == keyPath {
            let value = change![NSKeyValueChangeKey.newKey] as! NSValue
            let offsetY: CGFloat = value.cgPointValue.y + self.headerViewDefaultHeight + self.tabBar.frame.size.height
            var headerFrame: CGRect = CGRectZero
            let minHeaderY: CGFloat = self.headerViewDefaultHeight - self.tabBarStopOnTopHeight
            if (offsetY > minHeaderY) {
                headerFrame = CGRectMake(0, -minHeaderY, self.frame.size.width, self.headerViewDefaultHeight)
            } else if (offsetY >= 0 && offsetY <= minHeaderY) {
                headerFrame = CGRectMake(0, -offsetY, self.frame.size.width, self.headerViewDefaultHeight)
            } else {
                let height: CGFloat = self.headerViewDefaultHeight - (self.headerViewNeedStretch ? offsetY : 0)
                headerFrame = CGRectMake(0, 0, self.frame.size.width, height)
            }
            self.headerView!.frame = headerFrame

            var tabBarFrame: CGRect = self.tabBar.frame
            tabBarFrame.origin.y = headerFrame.maxY
            self.tabBar.frame = tabBarFrame
            
            let selector = #selector(self.delegate!.tabContentView(_:didChangedContentOffsetY:))
            if self.delegate != nil &&  self.delegate!.responds(to: selector){
                self.delegate!.tabContentView?(self, didChangedContentOffsetY: offsetY)
            }
        }
    }

    private func updateContentOffsetOfDisplayScrollView(_ scrollView: UIScrollView) {
        let tabBarY: CGFloat = self.tabBar.frame.origin.y
        if (tabBarY > self.tabBarStopOnTopHeight ||
                scrollView.contentOffset.y == 0 ||
                scrollView.contentOffset.y <= -self.tabBar.frame.maxY) {
            scrollView.contentOffset = CGPoint(x: 0, y: -(tabBarY + self.tabBar.frame.size.height))
        }
    }

    // HTabBarDelegate
    func h_tabBar(_ tabBar: HTabBar, shouldSelectItemAtIndex index: Int) -> Bool {
        return self.shouldSelectItemAtIndex(index)
    }

    func h_tabBar(_ tabBar: HTabBar, willSelectItemAtIndex index: Int) {
        let selector = #selector(self.delegate!.tabContentView(_:willSelectTabAtIndex:))
        if self.delegate != nil && self.delegate!.responds(to: selector) {
            self.delegate!.tabContentView!(self, willSelectTabAtIndex: index)
        }
    }

    func h_tabBar(_ tabBar: HTabBar, didSelectedItemAtIndex index: Int) {
        if index == self.selectedTabIndex {
            return
        }
        var oldController: UIViewController?
        if self.selectedTabIndex != NSNotFound {
            oldController = self.viewControllers![self.selectedTabIndex] as? UIViewController
            oldController?.h_tabItemDidDeselected()
            let selector = #selector(oldController!.h_tabItemDidDeselected)
            if oldController!.responds(to: selector) {
                oldController!.perform(selector)
            }
            if (!self.contentScrollEnabled ||
                    (self.contentScrollEnabled && self.removeViewOfChildContollerWhileDeselected)) {
                self.viewControllers!.enumerateObjects { (item, idx, stop) in
                    let controller = item as! UIViewController
                    if (idx != index && controller.isViewLoaded && controller.h_displayView.superview != nil) {
                        controller.h_displayView.removeFromSuperview()
                    }
                }
            }
        }
        let curController = self.viewControllers![index] as! UIViewController
        if self.contentScrollEnabled {
            // contentView支持滚动
            if !curController.isViewLoaded {
                let frame: CGRect = self.frameForControllerAtIndex(index)
                if curController.view != curController.h_displayView {
                    curController.view.frame = frame
                }
                curController.h_displayView.frame = frame
            }

            self.contentScrollView.addSubview(curController.h_displayView)
            // 切换到curController
            self.contentScrollView.scrollRectToVisible(curController.h_displayView.frame, animated: self.contentSwitchAnimated)

        } else {
            // contentView不支持滚动
            self.contentScrollView.addSubview(curController.h_displayView)
            // 设置curController.view的frame
            if curController.h_displayView.frame != self.contentScrollView.bounds {
                if curController.view != curController.h_displayView {
                    curController.view.frame = self.contentScrollView.bounds
                }
                curController.h_displayView.frame = self.contentScrollView.bounds
            }
        }

        // 获取是否是第一次被选中的标识
        if curController.h_hasBeenDisplayed {
            curController.h_tabItemDidSelected(false)
        } else {
            curController.h_tabItemDidSelected(true)
            curController.h_hasBeenDisplayed = true
        }

        if curController.responds(to: #selector(curController.h_tabItemDidSelected(_:))) {
            curController.perform(#selector(curController.h_tabItemDidSelected(_:)))
        }

        // 当contentView为scrollView及其子类时，设置它支持点击状态栏回到顶部
        if oldController != nil && oldController!.h_displayView.isKind(of: UIScrollView.self) {
            let scrollView = oldController!.h_displayView as! UIScrollView
            scrollView.scrollsToTop = false
        }
        if curController.h_displayView.isKind(of: UIScrollView.self) {
            let curScrollView = curController.h_displayView as! UIScrollView
            curScrollView.scrollsToTop = false
            if self.headerView != nil {
                var insets: UIEdgeInsets = curScrollView.contentInset
                insets.top = self.headerViewDefaultHeight + self.tabBar.frame.size.height
                curScrollView.contentInset = insets
                curScrollView.scrollIndicatorInsets = insets
                if !curController.h_disableMinContentHeight {
                    curScrollView.minContentSizeHeight = self.contentScrollView.frame.size.height - self.tabBar.frame.size.height - self.tabBarStopOnTopHeight
                }

                if oldController != nil && oldController!.h_hasAddedContentOffsetObserver {
                    // 移除oldController的h_displayView注册的观察者
                    oldController!.h_displayView.removeObserver(self, forKeyPath: kContentOffset)
                    oldController!.h_hasAddedContentOffsetObserver = false
                }
                if !curController.h_hasAddedContentOffsetObserver {
                    // 注册curScrollView的观察者
                    curScrollView.addObserver(self, forKeyPath: kContentOffset, options: .new, context: nil)
                    curController.h_hasAddedContentOffsetObserver = true
                }
                self.updateContentOffsetOfDisplayScrollView(curScrollView)
            }
        }

        _selectedTabIndex = index

        let selecotr = #selector(self.delegate!.tabContentView(_:didSelectedTabAtIndex:))
        if self.delegate != nil && self.delegate!.responds(to: selecotr) {
            self.delegate!.tabContentView?(self, didSelectedTabAtIndex: index)
        }
    }

    func h_tabBar(_ tabBar: HTabBar, reSelectedTabAtIndex index: Int) {
        let selector = #selector(self.delegate!.tabContentView(_:reSelectedTabAtIndex:))
        if self.delegate != nil && self.delegate!.responds(to: selector) {
            self.delegate!.tabContentView!(self, reSelectedTabAtIndex: index)
        }
    }

    // _HTabContentScrollViewDelegate
    fileprivate func scrollView(_ scrollView: _HTabContentScrollView, shouldScrollToPageIndex index: Int) -> Bool {
        return self.shouldSelectItemAtIndex(index)
    }

    private func shouldSelectItemAtIndex(_ index: Int) -> Bool {
        let selector = #selector(self.delegate!.tabContentView(_:shouldSelectTabAtIndex:))
        if self.delegate != nil && self.delegate!.responds(to: selector) {
            return self.delegate!.tabContentView!(self, shouldSelectTabAtIndex: index)
        }
        return true
    }

    // UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page: Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.tabBar.selectedItemIndex = page
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // 如果不是手势拖动导致的此方法被调用，不处理
        if !(scrollView.isDragging || scrollView.isDecelerating) {
            if (scrollView.contentOffset.x == 0) {
                // 解决有时候滑动冲突后scrollView跳动导致的item颜色显示错乱的问题
                self.tabBar.updateSubViewsWhenParentScrollViewScroll(self.contentScrollView)
            }
            return
        }

        // 滑动越界不处理
        let offsetX: CGFloat = scrollView.contentOffset.x
        let scrollViewWidth: CGFloat = scrollView.frame.size.width

        if (offsetX < 0) {
            return
        }
        if (offsetX > scrollView.h_contentSize.width - scrollViewWidth) {
            return
        }

        let leftIndex: Int = Int(offsetX / scrollViewWidth)
        var rightIndex: Int = leftIndex + 1

        // 这里处理shouldSelectItemAtIndex方法
        let selector = #selector(self.delegate!.tabContentView(_:shouldSelectTabAtIndex:))
        if self.delegate != nil && self.delegate!.responds(to: selector) && !scrollView.isDecelerating {
            var targetIndex: Int = 0
            if (_lastContentScrollViewOffsetX < offsetX) {
                // 向左
                targetIndex = rightIndex
            } else {
                // 向右
                targetIndex = leftIndex
            }
            if (targetIndex != self.selectedTabIndex) {
                if !self.shouldSelectItemAtIndex(targetIndex) {
                    scrollView.setContentOffset(CGPoint(x: CGFloat(self.selectedTabIndex) * scrollViewWidth, y: 0), animated: false)
                }
            }
        }
        _lastContentScrollViewOffsetX = offsetX

        // 刚好处于能完整显示一个child view的位置
        if (leftIndex == Int(offsetX / scrollViewWidth)) {
            rightIndex = leftIndex
        }
        // 将需要显示的child view放到scrollView上
        for index in leftIndex..<rightIndex+1 {

            let controller = self.viewControllers![index] as! UIViewController

            if (!controller.isViewLoaded && self.loadViewOfChildContollerWhileAppear) {
                let frame: CGRect = self.frameForControllerAtIndex(index)
                if controller.view != controller.h_displayView {
                    controller.view.frame = frame
                }
                controller.h_displayView.removeFromSuperview()
                controller.h_displayView.frame = frame
            }
            if (controller.isViewLoaded && controller.h_displayView.superview == nil) {
                self.contentScrollView.addSubview(controller.h_displayView)

                if self.headerView != nil {
                    let scrollView = controller.h_displayView as! UIScrollView
                    // 如果有headerView，需要更新contentOffset
                    var insets: UIEdgeInsets = scrollView.contentInset
                    insets.top = self.headerViewDefaultHeight + self.tabBar.frame.size.height
                    scrollView.contentInset = insets
                    scrollView.scrollIndicatorInsets = insets
                    if (!controller.h_disableMinContentHeight) {
                        scrollView.minContentSizeHeight = self.contentScrollView.frame.size.height - self.tabBar.frame.size.height - self.tabBarStopOnTopHeight
                    }
                    self.updateContentOffsetOfDisplayScrollView(scrollView)
                }
            }
        }

        // 同步修改tarBar的子视图状态
        self.tabBar.updateSubViewsWhenParentScrollViewScroll(self.contentScrollView)
    }

}

//自定义UIScrollView，在需要时可以拦截其滑动手势
@objc private protocol _HTabContentScrollViewDelegate : NSObjectProtocol {
    @objc optional func scrollView(_ scrollView: _HTabContentScrollView, shouldScrollToPageIndex index: Int) -> Bool
}

private class _HTabContentScrollView : UIScrollView {
    
    weak var h_delegate: _HTabContentScrollViewDelegate?
    var interceptLeftSlideGuetureInLastPage: Bool = false
    var interceptRightSlideGuetureInFirstPage: Bool = false
        
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view?.isKind(of: UISlider.self) ?? false {
            self.isScrollEnabled = false
        } else {
            self.isScrollEnabled = true
        }
        return view
    }

    /**
     *  重写此方法，在需要的时候，拦截UIPanGestureRecognizer
     */
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIPanGestureRecognizer) -> Bool {
        
        if !gestureRecognizer.responds(to: #selector(gestureRecognizer.translation(in:))) {
            return true
        }
        // 计算可能切换到的index
        let currentIndex: Int = Int(self.contentOffset.x / self.frame.size.width)
        var targetIndex: Int = currentIndex
        
        let translation = gestureRecognizer.translation(in: self)
        if (translation.x > 0) {
            targetIndex = currentIndex - 1
        } else {
            targetIndex = currentIndex + 1
        }
        
        // 第一页往右滑动
        if (self.interceptRightSlideGuetureInFirstPage && targetIndex < 0) {
            return false
        }
        
        // 最后一页往左滑动
        if (self.interceptLeftSlideGuetureInLastPage) {
            let numberOfPage: Int = Int(self.h_contentSize.width / self.frame.size.width)
            if (targetIndex >= numberOfPage) {
                return false
            }
        }
        
        // 其他情况
        let selector = #selector(self.h_delegate!.scrollView(_:shouldScrollToPageIndex:))
        if (self.h_delegate != nil && self.h_delegate!.responds(to: selector)) {
            return self.h_delegate!.scrollView!(self, shouldScrollToPageIndex: targetIndex)
        }
        
        return true
    }

}

