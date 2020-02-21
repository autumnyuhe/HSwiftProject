////
////  HCycleScrollView.swift
////  HSwiftProject
////
////  Created by wind on 2020/2/20.
////  Copyright © 2020 wind. All rights reserved.
////
//
//import UIKit
//import Kingfisher
//
//enum HCycleScrollViewPageContolAliment: Int {
//    case Right
//    case Center
//}
//
//enum HCycleScrollViewPageContolStyle: Int {
//    case Classic        // 系统自带经典样式
//    case Animated       // 动画效果pagecontrol
//    case None           // 不显示pagecontrol
//}
//
//private let kCycleScrollViewInitialPageControlDotSize = CGSizeMake(10, 10)
//private let KCycleID = "HCycleScrollViewCell"
//
//typealias HClickItemOperationBlock = (_ currentIndex: Int) -> Void
//typealias HItemDidScrollOperationBlock = (_ currentIndex: Int) -> Void
//
//@objc protocol HCycleScrollViewDelegate : NSObjectProtocol {
//
//    @objc optional
//
//    /** 点击图片回调 */
//    func cycleScrollView(_ cycleScrollView: HCycleScrollView, didSelectItemAtIndex index: Int)
//
//    /** 图片滚动回调 */
//    func cycleScrollView(_ cycleScrollView: HCycleScrollView, didScrollToIndex index: Int)
//
//
//    // 不需要自定义轮播cell的请忽略以下两个的代理方法
//
//    // ========== 轮播自定义cell ==========
//
//    /** 如果你需要自定义cell样式，请在实现此代理方法返回你的自定义cell的class。 */
//    func customCollectionViewCellClassForCycleScrollView(_ view: HCycleScrollView) -> AnyClass
//
//    /** 如果你需要自定义cell样式，请在实现此代理方法返回你的自定义cell的Nib。 */
//    func customCollectionViewCellNibForCycleScrollView(_ view: HCycleScrollView) -> UINib
//
//    /** 如果你自定义了cell样式，请在实现此代理方法为你的cell填充数据以及其它一系列设置 */
//    func setupCustomCell(_ cell: UICollectionViewCell, forIndex index: Int, cycleScrollView view: HCycleScrollView)
//
//}
//
//class HCycleScrollView : UIView, UICollectionViewDataSource, UICollectionViewDelegate {
//
//    weak private var mainView: UICollectionView? // 显示图片的collectionView
//    weak private var flowLayout: UICollectionViewFlowLayout?
//
//    private var _imagePathsGroup: NSArray?
//    private var imagePathsGroup: NSArray? {
//        get {
//            return _imagePathsGroup
//        }
//        set {
//            self.invalidateTimer()
//
//            _imagePathsGroup = newValue
//
//            totalItemsCount = self.infiniteLoop ? _imagePathsGroup.count * 100 : _imagePathsGroup.count
//
//            if (imagePathsGroup.count > 1) { // 由于 !=1 包含count == 0等情况
//                self.mainView.scrollEnabled = true
//                self.setAutoScroll(_autoScroll)
//            } else {
//                self.mainView.scrollEnabled = false
//                self.invalidateTimer()
//            }
//
//            self.setupPageControl()
//            self.mainView.reloadData()
//        }
//    }
//    weak private var timer: Timer?
//    private var totalItemsCount: Int
//    weak private var pageControl: UIControl?
//    private var backgroundImageView: UIImageView? // 当imageURLs为空时的背景图
//
//
//    /** 初始轮播图（推荐使用） */
//    static func cycleScrollViewWithFrame(_ frame: CGRect, delegate: HCycleScrollViewDelegate, placeholderImage: UIImage) -> HCycleScrollView {
//        let cycleScrollView = HCycleScrollView(frame: frame)
//        cycleScrollView.delegate = delegate
//        cycleScrollView.placeholderImage = placeholderImage
//        return cycleScrollView
//    }
////    + (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<HCycleScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage
//
//    static func cycleScrollViewWithFrame(_ frame: CGRect, imageURLStringsGroup: NSArray) -> HCycleScrollView {
//        let cycleScrollView = HCycleScrollView(frame: frame)
//        cycleScrollView.imageURLStringsGroup = imageURLStringsGroup
//        return cycleScrollView
//    }
////    + (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageURLStringsGroup:(NSArray *)imageURLStringsGroup
//
//
//    /** 本地图片轮播初始化方式 */
//    static func cycleScrollViewWithFrame(_ frame: CGRect, imageNamesGroup: NSArray) -> HCycleScrollView {
//        let cycleScrollView = HCycleScrollView(frame: frame)
//        cycleScrollView.localizationImageNamesGroup = imageNamesGroup
//        return cycleScrollView
//    }
////    + (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageNamesGroup:(NSArray *)imageNamesGroup
//
//    /** 本地图片轮播初始化方式2,infiniteLoop:是否无限循环 */
//    static func cycleScrollViewWithFrame(_ frame: CGRect, shouldInfiniteLoop infiniteLoop: Bool, imageNamesGroup: NSArray) -> HCycleScrollView {
//        let cycleScrollView = HCycleScrollView(frame: frame)
//        cycleScrollView.infiniteLoop = infiniteLoop
//        cycleScrollView.localizationImageNamesGroup = imageNamesGroup
//        return cycleScrollView
//    }
////    + (instancetype)cycleScrollViewWithFrame:(CGRect)frame shouldInfiniteLoop:(Bool)infiniteLoop imageNamesGroup:(NSArray *)imageNamesGroup
////    + (instancetype)cycleScrollViewWithFrame:(CGRect)frame shouldInfiniteLoop:(Bool)infiniteLoop imageNamesGroup:(NSArray *)imageNamesGroup {
////        HCycleScrollView *cycleScrollView = [self.alloc] initWithFrame:frame]
////        cycleScrollView.infiniteLoop = infiniteLoop
////        cycleScrollView.localizationImageNamesGroup = [NSMutableArray arrayWithArray:imageNamesGroup]
////        return cycleScrollView
////    }
//
////    + (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageURLStringsGroup:(NSArray *)imageURLsGroup {
////        HCycleScrollView *cycleScrollView = [self.alloc] initWithFrame:frame]
////        cycleScrollView.imageURLStringsGroup = [NSMutableArray arrayWithArray:imageURLsGroup]
////        return cycleScrollView
////    }
//
////    + (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<HCycleScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage {
////        HCycleScrollView *cycleScrollView = [self.alloc] initWithFrame:frame]
////        cycleScrollView.delegate = delegate
////        cycleScrollView.placeholderImage = placeholderImage
////
////        return cycleScrollView
////    }
//
//
//    //////////////////////  数据源API //////////////////////
//
//    /** 网络图片 url string 数组 */
//    var imageURLStringsGroup: NSArray?
//
//    /** 每张图片对应要显示的文字数组 */
//    var titlesGroup: NSArray?
//
//    /** 本地图片数组 */
//    var localizationImageNamesGroup: NSArray?
//
//
//
//
//
//    //////////////////////  滚动控制API //////////////////////
//
//    private var _autoScrollTimeInterval: TimeInterval = 2.0
//    /** 自动滚动间隔时间,默认2s */
//    var autoScrollTimeInterval: TimeInterval {
//        get {
//            return _autoScrollTimeInterval
//        }
//        set {
//            _autoScrollTimeInterval = newValue
//            self.autoScroll = _autoScroll
//        }
//    }
//
//    private var _infiniteLoop: Bool = true
//    /** 是否无限循环,默认true */
//    var infiniteLoop: Bool {
//        get {
//            return _infiniteLoop
//        }
//        set {
//            _infiniteLoop = newValue
//            if self.imagePathsGroup!.count > 0 {
//                self.imagePathsGroup = _imagePathsGroup
//            }
//        }
//    }
//
//    private var _autoScroll: Bool = true
//    /** 是否自动滚动,默认true */
//    var autoScroll: Bool {
//        get {
//            return _autoScroll
//        }
//        set {
//            _autoScroll = newValue
//            self.invalidateTimer()
//            if (_autoScroll) {
//                self.setupTimer()
//            }
//        }
//    }
//
//    private var _scrollDirection: UICollectionView.ScrollDirection = .horizontal
//    /** 图片滚动方向，默认为水平滚动 */
//    var scrollDirection: UICollectionView.ScrollDirection {
//        get {
//            return _scrollDirection
//        }
//        set {
//            _scrollDirection = newValue
//            flowLayout!.scrollDirection = newValue
//        }
//    }
//
//    private weak var _delegate: HCycleScrollViewDelegate?
//    weak var delegate: HCycleScrollViewDelegate? {
//        get {
//            return _delegate
//        }
//        set {
//            _delegate = newValue
//            if _delegate != nil {
//                if _delegate!.responds(to: #selector(_delegate!.customCollectionViewCellClassForCycleScrollView(_:))) {
//                    let nib: AnyClass = _delegate!.customCollectionViewCellClassForCycleScrollView(self)
//                    self.mainView?.register(nib, forCellWithReuseIdentifier: KCycleID)
//                }else if _delegate!.responds(to: #selector(_delegate!.customCollectionViewCellNibForCycleScrollView(_:))) {
//                    let nib: UINib = _delegate!.customCollectionViewCellNibForCycleScrollView(self)
//                    self.mainView?.register(nib, forCellWithReuseIdentifier: KCycleID)
//                }
//            }
//        }
//    }
//
//    /** block方式监听点击 */
//    var clickItemOperationBlock: HClickItemOperationBlock?
//
//    /** block方式监听滚动 */
//    var itemDidScrollOperationBlock: HItemDidScrollOperationBlock?
//
//    /** 可以调用此方法手动控制滚动到哪一个index */
//    func makeScrollViewScrollToIndex(_ index: Int) {
//        if (self.autoScroll) {
//            self.invalidateTimer()
//        }
//        if (0 == totalItemsCount) { return }
//
//        self.scrollToIndex(Int(CGFloat(totalItemsCount) * 0.5) + index)
//
//        if (self.autoScroll) {
//            self.setupTimer()
//        }
//    }
//
//    /** 解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法 */
//    func adjustWhenControllerViewWillAppera() {
//        let targetIndex = self.currentIndex()
//        if (targetIndex < totalItemsCount) {
//            mainView!.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: UICollectionView.ScrollPosition.top, animated: false)
//        }
//    }
//
//    //////////////////////  自定义样式API  //////////////////////
//
//    /** 轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill */
//    var bannerImageViewContentMode: UIView.ContentMode = .scaleToFill
//
//    private var _placeholderImage: UIImage?
//    /** 占位图，用于网络未加载到图片时 */
//    var placeholderImage: UIImage? {
//        get {
//            return _placeholderImage
//        }
//        set {
//            _placeholderImage = newValue
//            if self.backgroundImageView == nil {
//                let bgImageView = UIImageView()
//                bgImageView.contentMode = .scaleAspectFit
//                self.insertSubview(bgImageView, belowSubview: self.mainView!)
//                self.backgroundImageView = bgImageView
//            }
//            self.backgroundImageView!.image = _placeholderImage
//        }
//    }
//
//    private var _showPageControl: Bool = false
//    /** 是否显示分页控件 */
//    var showPageControl: Bool {
//        get {
//            return _showPageControl
//        }
//        set {
//            _showPageControl = newValue
//            self.pageControl?.isHidden = !newValue
//        }
//    }
//
//    /** 是否在只有一张图时隐藏pagecontrol，默认为true */
//    var hidesForSinglePage: Bool = true
//
//    /** 只展示文字轮播 */
//    var onlyDisplayText: Bool = false
//
//    private var _pageControlStyle: HCycleScrollViewPageContolStyle = .Animated
//    /** pagecontrol 样式，默认为动画样式 */
//    var pageControlStyle: HCycleScrollViewPageContolStyle {
//        get {
//            return _pageControlStyle
//        }
//        set {
//            _pageControlStyle = newValue
//            self.setupPageControl()
//        }
//    }
//
//    /** 分页控件位置 */
//    var pageControlAliment: HCycleScrollViewPageContolAliment = .Center
//
//    /** 分页控件距离轮播图的底部间距（在默认间距基础上）的偏移量 */
//    var pageControlBottomOffset: CGFloat = 0.0
//
//    /** 分页控件距离轮播图的右边间距（在默认间距基础上）的偏移量 */
//    var pageControlRightOffset: CGFloat = 0.0
//
//    private var _pageControlDotSize: CGSize = CGSizeZero
//    /** 分页控件小圆标大小 */
//    var pageControlDotSize: CGSize {
//        get {
//            return _pageControlDotSize
//        }
//        set {
//            _pageControlDotSize = newValue
//            self.setupPageControl()
//            if self.pageControl!.isKind(of: HPageControl.self) {
//                let pageContol = self.pageControl as! HPageControl
//                pageContol.dotSize = newValue
//            }
//        }
//    }
//
//    private var _currentPageDotColor: UIColor?
//    /** 当前分页控件小圆标颜色 */
//    var currentPageDotColor: UIColor? {
//        get {
//            return _currentPageDotColor
//        }
//        set {
//            _currentPageDotColor = newValue
//            if self.pageControl!.isKind(of: HPageControl.self) {
//                let pageContol = self.pageControl as! HPageControl
//                pageContol.dotColor = currentPageDotColor
//            }else {
//                let pageContol = self.pageControl as! UIPageControl
//                pageContol.currentPageIndicatorTintColor = newValue
//            }
//        }
//    }
//
//    private var _pageDotColor: UIColor?
//    /** 其他分页控件小圆标颜色 */
//    var pageDotColor: UIColor? {
//        get {
//            return _pageDotColor
//        }
//        set {
//            _pageDotColor = newValue
//            if self.pageControl!.isKind(of: UIPageControl.self) {
//                let pageContol = self.pageControl as! UIPageControl
//                pageContol.pageIndicatorTintColor = newValue
//            }
//        }
//    }
//
//    private var _currentPageDotImage: UIImage?
//    /** 当前分页控件小圆标图片 */
//    var currentPageDotImage: UIImage? {
//        get {
//            return _currentPageDotImage
//        }
//        set {
//            _currentPageDotImage = newValue
//            if self.pageControlStyle != .Animated {
//                self.pageControlStyle = .Animated
//            }
//            self.setCustomPageControlDotImage(newValue, isCurrentPageDot: true)
//        }
//    }
//
//    private var _pageDotImage: UIImage?
//    /** 其他分页控件小圆标图片 */
//    var pageDotImage: UIImage? {
//        get {
//            return _pageDotImage
//        }
//        set {
//            _pageDotImage = newValue
//        }
//    }
//
//    /** 轮播文字label字体颜色 */
//    var titleLabelTextColor: UIColor?
//
//    /** 轮播文字label字体大小 */
//    var titleLabelTextFont: UIFont?
//
//    /** 轮播文字label背景颜色 */
//    var titleLabelBackgroundColor: UIColor?
//
//    /** 轮播文字label高度 */
//    var titleLabelHeight: CGFloat = 0.0
//
//    /** 轮播文字label对齐方式 */
//    var titleLabelTextAlignment: NSTextAlignment
//
//    /** 滚动手势禁用（文字轮播较实用） */
//    func disableScrollGesture() {
//
//    }
//
//
//    //////////////////////  清除缓存API  //////////////////////
//
//    /** 清除图片缓存（此次升级后统一使用SDWebImage管理图片加载和缓存）  */
//    static func clearImagesCache() {
//
//    }
//
//    /** 清除图片缓存（兼容旧版本方法） */
//    func clearCache() {
//
//    }
//
//
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.initialization()
//        self.setupMainView()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        self.initialization()
//        self.setupMainView()
//    }
//    //    - (instancetype)initWithFrame:(CGRect)frame {
////        if (self = [super initWithFrame:frame]) {
////            self.initialization]
////            self.setupMainView]
////        }
////        return self
////    }
//
////    func awakeFromNib {
////        [super awakeFromNib]
////        self.initialization]
////        self.setupMainView]
////    }
//
//    private func initialization() {
//        pageControlAliment = .Center
//        autoScrollTimeInterval = 2.0
//        titleLabelTextColor = UIColor.white
//        titleLabelTextFont = UIFont.systemFont(ofSize: 14.0)
//        titleLabelBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//        titleLabelHeight = 30
//        titleLabelTextAlignment = .left
//        autoScroll = true
//        infiniteLoop = true
//        showPageControl = true
//        pageControlDotSize = kCycleScrollViewInitialPageControlDotSize
//        pageControlBottomOffset = 0
//        pageControlRightOffset = 0
//        pageControlStyle = .Classic
//        hidesForSinglePage = true
//        currentPageDotColor = UIColor.white
//        pageDotColor = UIColor.lightGray
//        bannerImageViewContentMode = .scaleToFill
//
//        self.backgroundColor = UIColor.lightGray
//
//    }
//
//
//
//    // 设置显示图片的collectionView
//    private func setupMainView() {
//        let flowLayout = UICollectionViewFlowLayout()
////        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init]
//        flowLayout.minimumLineSpacing = 0
//        flowLayout.scrollDirection = .horizontal
//        self.flowLayout = flowLayout
//
//        let mainView = UICollectionView.init(frame: self.bounds, collectionViewLayout: flowLayout)
//
////        UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout]
//        mainView.backgroundColor = UIColor.clear
//        mainView.isPagingEnabled = true
//        mainView.showsHorizontalScrollIndicator = false
//        mainView.showsVerticalScrollIndicator = false
//        mainView.register(HCollectionViewCell.self, forCellWithReuseIdentifier: KCycleID)
////        [mainView registerClass:[HCollectionViewCell class] forCellWithReuseIdentifier:KCycleID]
//
//        mainView.dataSource = self
//        mainView.delegate = self
//        mainView.scrollsToTop = false
//        self.addSubview(mainView)
//        self.mainView = mainView
//    }
//
//    func setCustomPageControlDotImage(_ image: UIImage?, isCurrentPageDot: Bool) {
//
//        if (image == nil || self.pageControl == nil) { return }
//
//        if self.pageControl!.isKind(of: HPageControl.self) {
//            let pageControl = self.pageControl as! HPageControl
//            if isCurrentPageDot {
//                pageControl.currentDotImage = image
//            } else {
//                pageControl.dotImage = image
//            }
//        }
//    }
//
//    func setImageURLStringsGroup(_ imageURLStringsGroup: NSArray) {
//        _imageURLStringsGroup = imageURLStringsGroup
//
//        NSMutableArray *temp = [NSMutableArray new]
//        [_imageURLStringsGroup enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, Bool * stop) {
//            NSString *urlString
//            if ([obj isKindOfClass:[NSString class]]) {
//                urlString = obj
//            } else if ([obj isKindOfClass:[NSURL class]]) {
//                NSURL *url = (NSURL *)obj
//                urlString = [url absoluteString]
//            }
//            if (urlString) {
//                [temp addObject:urlString]
//            }
//        }]
//        self.imagePathsGroup = [temp copy]
//    }
//
//    func setLocalizationImageNamesGroup(_ localizationImageNamesGroup: NSArray) {
//        _localizationImageNamesGroup = localizationImageNamesGroup
//        self.imagePathsGroup = [localizationImageNamesGroup copy]
//    }
//
//    func setTitlesGroup(_ titlesGroup: NSArray) {
//        _titlesGroup = titlesGroup
//        if (self.onlyDisplayText) {
//            NSMutableArray *temp = [NSMutableArray new]
//            for (int i = 0 i < _titlesGroup.count i++) {
//                [temp addObject:@""]
//            }
//            self.backgroundColor = [UIColor clearColor]
//            self.imageURLStringsGroup = [temp copy]
//        }
//    }
//
//    func disableScrollGesture() {
//        self.mainView.canCancelContentTouches = false
//        for (UIGestureRecognizer *gesture in self.mainView.gestureRecognizers) {
//            if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
//                [self.mainView removeGestureRecognizer:gesture]
//            }
//        }
//    }
//
//    /// actions
//    func setupTimer() {
//        self.invalidateTimer() // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
//
//        timer = Timer.scheduledTimer(timeInterval: self.autoScrollTimeInterval, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
//        RunLoop.main.add(timer!, forMode: .common)
//    }
//
//    func invalidateTimer() {
//        timer?.invalidate()
//        timer = nil
//    }
//
//    func setupPageControl() {
//        if pageControl != nil {
//            pageControl?.removeFromSuperview()// 重新加载数据时调整
//        }
//
//        if (self.imagePathsGroup!.count == 0 || self.onlyDisplayText) { return }
//
//        if ((self.imagePathsGroup!.count == 1) && self.hidesForSinglePage) { return }
//
//        let indexOnPageControl = self.pageControlIndexWithCurrentCellIndex(self.currentIndex())
//
//        switch (self.pageControlStyle) {
//        case .Animated:
//            let pageControl = HPageControl()
//            pageControl.numberOfPages = self.imagePathsGroup!.count
//            pageControl.dotColor = self.currentPageDotColor
//            pageControl.isUserInteractionEnabled = false
//            pageControl.currentPage = indexOnPageControl
//            self.addSubview(pageControl)
//            self.pageControl = pageControl
//            break
//        case .Classic:
//            let pageControl = UIPageControl()
//            pageControl.numberOfPages = self.imagePathsGroup!.count
//            pageControl.currentPageIndicatorTintColor = self.currentPageDotColor
//            pageControl.pageIndicatorTintColor = self.pageDotColor
//            pageControl.isUserInteractionEnabled = false
//            pageControl.currentPage = indexOnPageControl
//            self.addSubview(pageControl)
//            self.pageControl = pageControl
//            break
//        default:
//            break
//        }
//
//        // 重设pagecontroldot图片
//        if (_currentPageDotImage != nil) {
//            self.currentPageDotImage = _currentPageDotImage
//        }
//        if (_pageDotImage != nil) {
//            self.pageDotImage = _pageDotImage
//        }
//    }
//
//
//    @objc func automaticScroll() {
//        if (0 == totalItemsCount) { return }
//        let currentIndex = self.currentIndex()
//        let targetIndex = currentIndex + 1
//        self.scrollToIndex(targetIndex)
//    }
//
//    func scrollToIndex(_ targetIndex: Int) {
//        if (targetIndex >= totalItemsCount) {
//            if (self.infiniteLoop) {
//                let targetIndex = CGFloat(totalItemsCount) * 0.5
//
//                //UICollectionViewScrollPositionNone
//                //UICollectionView.ScrollPosition.init(rawValue: 0)
//                mainView!.scrollToItem(at: IndexPath(item: Int(targetIndex), section: 0), at: UICollectionView.ScrollPosition.top, animated: false)
//            }
//            return
//        }
//        mainView!.scrollToItem(at: IndexPath(item: Int(targetIndex), section: 0), at: UICollectionView.ScrollPosition.top, animated: true)
//    }
//
//    func currentIndex() -> Int {
//        if (mainView!.hc_width == 0 || mainView!.hc_height == 0) {
//            return 0
//        }
//
//        int index = 0
//        if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
//            index = (_mainView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width
//        } else {
//            index = (_mainView.contentOffset.y + _flowLayout.itemSize.height * 0.5) / _flowLayout.itemSize.height
//        }
//
//        return MAX(0, index)
//    }
//
//    func pageControlIndexWithCurrentCellIndex(_ index: Int) -> Int {
//        return index % self.imagePathsGroup!.count
//    }
//
//    func clearCache() {
//        self.class.clearImagesCache()
//    }
//
//    static func clearImagesCache() {
////        [[[SDWebImageManager sharedManager] imageCache] clearDiskOnCompletion:nil]
//    }
//
//    /// life circles
//
//    override func layoutSubviews() {
//        self.delegate = _delegate
//
//        super.layoutSubviews()
//
//        flowLayout!.itemSize = self.frame.size
//
//        mainView!.frame = self.bounds
//        if (mainView!.contentOffset.x == 0 && totalItemsCount > 0) {
//            var targetIndex = 0
//            if (self.infiniteLoop) {
//                targetIndex = totalItemsCount/2
//            }else{
//                targetIndex = 0
//            }
//            mainView!.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: UICollectionView.ScrollPosition.top, animated: false)
//        }
//
//        let size = CGSizeZero
////        self.pageControl.isKindOfClass
//        if ([self.pageControl isKindOfClass:[HPageControl class]]) {
//            HPageControl *pageControl = (HPageControl *)_pageControl
//            if (!(self.pageDotImage && self.currentPageDotImage && CGSizeEqualToSize(kCycleScrollViewInitialPageControlDotSize, self.pageControlDotSize))) {
//                pageControl.dotSize = self.pageControlDotSize
//            }
//            size = [pageControl sizeForNumberOfPages:self.imagePathsGroup.count]
//        } else {
//            size = CGSizeMake(self.imagePathsGroup.count * self.pageControlDotSize.width * 1.5, self.pageControlDotSize.height)
//        }
//        CGFloat x = (self.hc_width - size.width) * 0.5
//        if (self.pageControlAliment == Right) {
//            x = self.mainView.hc_width - size.width - 10
//        }
//        CGFloat y = self.mainView.hc_height - size.height - 10
//
//        if ([self.pageControl isKindOfClass:[HPageControl class]]) {
//            HPageControl *pageControl = (HPageControl *)_pageControl
//            [pageControl sizeToFit]
//        }
//
//        CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height)
//        pageControlFrame.origin.y -= self.pageControlBottomOffset
//        pageControlFrame.origin.x -= self.pageControlRightOffset
//        self.pageControl.frame = pageControlFrame
//        self.pageControl.hidden = !_showPageControl
//
//        if (self.backgroundImageView) {
//            self.backgroundImageView.frame = self.bounds
//        }
//
//    }
//
//    //解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
//    override func willMove(toSuperview newSuperview: UIView?) {
//        if newSuperview == nil {
//            self.invalidateTimer()
//        }
//    }
//
//    //解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
//    deinit {
//        mainView!.delegate = nil
//        mainView!.dataSource = nil
//    }
//
//    /// public actions
//
//
//    /// UICollectionViewDataSource
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return totalItemsCount
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KCycleID, for: indexPath) as! HCollectionViewCell
//
//        let itemIndex = self.pageControlIndexWithCurrentCellIndex(indexPath.item)
//
//        if (self.delegate!.responds(to: #selector(self.delegate!.setupCustomCell(_:forIndex:cycleScrollView:))) &&
//            self.delegate!.responds(to: #selector(self.delegate!.customCollectionViewCellClassForCycleScrollView(_:)))) {
//            self.delegate!.setupCustomCell(cell, forIndex: itemIndex, cycleScrollView: self)
//            return cell
//        }else if (self.delegate!.responds(to: #selector(self.delegate!.setupCustomCell(_:forIndex:cycleScrollView:))) &&
//                  self.delegate!.responds(to: #selector(self.delegate!.customCollectionViewCellNibForCycleScrollView(_:)))) {
//            self.delegate!.setupCustomCell(cell, forIndex: itemIndex, cycleScrollView: self)
//            return cell
//        }
//
//        let imagePath = self.imagePathsGroup![itemIndex] as? NSString
//
//        if (!self.onlyDisplayText && imagePath!.isKind(of: NSString.self)) {
//            if imagePath!.hasPrefix("http") {
//                cell.imageView.placeHoderImage = self.placeholderImage
//                cell.imageView.setImageUrlString(imagePath! as String)
//            } else {
//                var image: UIImage? = UIImage(named: imagePath! as String)
//                if image == nil {
//                    image = UIImage(contentsOfFile: imagePath! as String)
//                }
//                cell.imageView.setImage(image)
//            }
//        } else if (!self.onlyDisplayText && imagePath!.isKind(of: UIImage.self)) {
//            let image = self.imagePathsGroup![itemIndex] as? UIImage
//            cell.imageView.setImage(image)
//        }
//
//        if (titlesGroup != nil && titlesGroup!.count > 0 && itemIndex < titlesGroup!.count) {
//            cell.title = titlesGroup![itemIndex] as? String
//        }
//
//        if (!cell.hasConfigured) {
//            cell.titleLabelBackgroundColor = self.titleLabelBackgroundColor
//            cell.titleLabelHeight = self.titleLabelHeight
//            cell.titleLabelTextAlignment = self.titleLabelTextAlignment
//            cell.titleLabelTextColor = self.titleLabelTextColor
//            cell.titleLabelTextFont = self.titleLabelTextFont
//            cell.hasConfigured = true
//            cell.imageView.contentMode = self.bannerImageViewContentMode
//            cell.clipsToBounds = true
//            cell.onlyDisplayText = self.onlyDisplayText
//        }
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if self.delegate != nil && self.delegate!.responds(to: #selector(self.delegate!.cycleScrollView(_:didSelectItemAtIndex:))) {
//            self.delegate!.cycleScrollView?(self, didSelectItemAtIndex: self.pageControlIndexWithCurrentCellIndex(indexPath.item))
//        }
//        if (self.clickItemOperationBlock != nil) {
//            self.clickItemOperationBlock!(self.pageControlIndexWithCurrentCellIndex(indexPath.item))
//        }
//    }
//
//
//    /// UIScrollViewDelegate
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (self.imagePathsGroup!.count == 0) { return } // 解决清除timer时偶尔会出现的问题
//        let itemIndex = self.currentIndex()
//        let indexOnPageControl = self.pageControlIndexWithCurrentCellIndex(itemIndex)
//
//        if self.pageControl != nil && self.pageControl!.isKind(of: HPageControl.self) {
//            let pageControl = self.pageControl! as! HPageControl
//            pageControl.currentPage = indexOnPageControl
//        } else {
//            let pageControl = self.pageControl! as! UIPageControl
//            pageControl.currentPage = indexOnPageControl
//        }
//    }
//
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        if (self.autoScroll) {
//            self.invalidateTimer()
//        }
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if (self.autoScroll) {
//            self.setupTimer()
//        }
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        self.scrollViewDidEndScrollingAnimation(self.mainView!)
//    }
//
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        if (self.imagePathsGroup!.count == 0) { return } // 解决清除timer时偶尔会出现的问题
//        let itemIndex = self.currentIndex()
//        let indexOnPageControl = self.pageControlIndexWithCurrentCellIndex(itemIndex)
//
//        if self.delegate != nil && self.delegate!.responds(to: #selector(self.delegate?.cycleScrollView(_:didScrollToIndex:))) {
//            self.delegate!.cycleScrollView(self, didScrollToIndex: indexOnPageControl)
//        } else if (self.itemDidScrollOperationBlock != nil) {
//            self.itemDidScrollOperationBlock!(indexOnPageControl)
//        }
//    }
//
//}
