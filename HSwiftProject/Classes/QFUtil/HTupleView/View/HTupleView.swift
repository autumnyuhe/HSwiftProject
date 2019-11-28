//
//  HTupleView.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

enum HTupleDirection: Int {
    case vertical   = 0
    case horizontal = 1
}

private enum HTupleStyle: Int {
    case `default`  //单体式设计
    case split //分体式设计
}

///自定义类型
typealias HTupleState = NSInteger

private let KDefaultPageSize   = 20
private let KTupleDesignKey    = "tuple"
private let KTupleExaDesignKey = "tupleExa"

private let UICollectionElementKindSectionHeader = "UICollectionElementKindSectionHeader"
private let UICollectionElementKindSectionFooter = "UICollectionElementKindSectionFooter"

///refresh & loadMore block
typealias HTupleRefreshBlock = () -> Void
typealias HTupleLoadMoreBlock = () -> Void

///tuple header & footer & item block
typealias HTupleHeader = (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject
typealias HTupleFooter = (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject
typealias HTupleItem   = (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject

///split design exclusive sections block
typealias HTupleSectionExclusiveBlock = () -> NSArray

///此类用于全工程刷新tupleView
class HTupleAppearance : NSObject {
    
    private static var hashTuples = NSHashTable<AnyObject>.weakObjects()
    
    static func addTuple(_ anTuple: AnyObject) -> Void {
        self.hashTuples.add(anTuple)
    }
    static func enumerateTuples(_ completion: @escaping () -> Void) -> Void {
        DispatchQueue.main.async {
            //倒序执行
            for item in self.hashTuples.allObjects.reversed() {
                let tuple = item as! HTupleView
                tuple.reloadData()
            }
            completion()
        }
    }
}

@objc protocol HTupleViewDelegate : NSObjectProtocol {
    @objc optional func numberOfSectionsInTupleView() -> NSInt
    @objc optional func numberOfItemsInSection(_ section: Int) -> NSInt
    ///layout == HCollectionViewFlowLayout
    @objc optional func colorForSectionAt(_ section: Int) -> UIColor

    @objc optional func sizeForHeaderInSection(_ section: Int) -> NSSize
    @objc optional func sizeForFooterInSection(_ section: Int) -> NSSize
    @objc optional func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> NSSize

    @objc optional func edgeInsetsForHeaderInSection(_ section: Int) -> NSEdgeInsets
    @objc optional func edgeInsetsForFooterInSection(_ section: Int) -> NSEdgeInsets
    @objc optional func edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> NSEdgeInsets

    @objc optional func insetForSection(_ section: Int) -> NSInt

    @objc optional func tupleForHeader(_ headerObject: NSHeader, inSection section: Int)
    @objc optional func tupleForFooter(_ footerObject: NSFooter, inSection section: Int)
    @objc optional func tupleForItem(_ itemObject: NSItem, atIndexPath indexPath: IndexPath)

    @objc optional func willDisplayCell(_ cell: UICollectionViewCell, atIndexPath indexPath: IndexPath)
    @objc optional func didSelectItemAtIndexPath(_ indexPath: IndexPath)
}

class HTupleView : UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, HCollectionViewDelegateFlowLayout {

    private var flowLayout: UICollectionViewFlowLayout?

    private var tupleStyle: HTupleStyle = .default

    private var allReuseIdentifiers: NSMutableSet = NSMutableSet()
    private var allSectionInsets = NSMapTable<NSString, AnyObject>.strongToStrongObjects()
    private var allReuseCells    = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
    private var allReuseHeaders  = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
    private var allReuseFooters  = NSMapTable<NSString, AnyObject>.strongToWeakObjects()

    private var sectionPaths: NSArray?
    
    var tupleDelegate: HTupleViewDelegate?
    
    ///默认layout为HCollectionViewFlowLayout
    ///默认为垂直滚动方向
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor.clear
    }
    
    convenience init(frame: CGRect) {
        let flowLayout = HCollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        self.init(frame: frame, collectionViewLayout: flowLayout)
    }
    
    convenience init(frame: CGRect, scrollDirection direction: HTupleDirection) {
        let flowLayout = HCollectionViewFlowLayout()
        if direction == .horizontal {
            flowLayout.scrollDirection = .horizontal
        }else {
            flowLayout.scrollDirection = .vertical
        }
        self.init(frame: frame, collectionViewLayout: flowLayout)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        flowLayout = layout as? UICollectionViewFlowLayout
        self.setup()
    }
    
    ///split设计初始化方法
    static func tupleFrame(_ frame: () -> CGRect, exclusiveSections sections: HTupleSectionExclusiveBlock) -> HTupleView {
        return HTupleView.init(frame(), exclusiveSections: sections())
    }
    
    private convenience init(_ frame: CGRect, exclusiveSections sectionPaths: NSArray) {
        let flowLayout = HCollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        self.init(frame: UIRectIntegral(frame), collectionViewLayout: flowLayout)
        self.flowLayout = flowLayout
        self.tupleStyle = .split
        self.sectionPaths = sectionPaths
        self.setup()
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            let frame = UIRectIntegral(newValue)
            if frame != super.frame {
                super.frame = frame
                self.reloadData()
            }
        }
    }
    
    private func setup() -> Void {
        //保存tupleView用于全局刷新
        HTupleAppearance.addTuple(self)
        
        if self.flowLayout!.scrollDirection == .vertical {
            self.verticalBounceEnabled()
        }else {
            self.horizontalBounceEnabled()
        }
        self.backgroundColor = UIColor.clear
        self.keyboardDismissMode = .onDrag
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false

        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        self.delegate = self
        self.dataSource = self
    }

    private var _pageNo: Int = 1
    /// page number, default 1
    var pageNo: Int {
        get {
            if _pageNo <= 0 {
                return 1
            }
            return _pageNo
        }
        set {
            _pageNo = newValue
        }
    }
    
    private var _pageSize: Int = KDefaultPageSize
    /// page size, default 20
    var pageSize: Int {
        get {
            if _pageSize <= 0 {
                return KDefaultPageSize
            }
            return _pageSize
        }
        set {
            _pageSize = newValue
        }
    }
    
    private var _totalNo: Int = 10000
    /// total number.
    var totalNo: Int {
        get {
            if _totalNo <= 0 {
                return 10000
            }
            return _totalNo
        }
        set {
            _totalNo = newValue
        }
    }
    
    private var _refreshBlock: HTupleRefreshBlock?
    /// block to refresh data
    var refreshBlock: HTupleRefreshBlock? {
        get {
            return _refreshBlock
        }
        set {
            _refreshBlock = newValue
//            if _refreshBlock != nil {
//                @www
//                self.mj_header = [HTupleRefresh refreshHeaderWithStyle:_refreshHeaderStyle andBlock:^{
//                    @sss
//                    [self setPageNo:1];
//                    self->_refreshBlock();
//                }];
//            }else {
//                self.mj_header = nil
//            }
        }
    }
        
    private var _loadMoreBlock: HTupleLoadMoreBlock?
    /// block to load more data
    var loadMoreBlock: HTupleLoadMoreBlock? {
        get {
            return _loadMoreBlock
        }
        set {
            _loadMoreBlock = newValue
//            if _loadMoreBlock != nil {
//                self.pageNo = 1
//                @www
//                self.mj_footer = [HTupleRefresh refreshFooterWithStyle:_refreshFooterStyle andBlock:^{
//                    @sss
//                    self.pageNo += 1;
//                    if (self.pageSize*self.pageNo < self.totalNo) {
//                        self->_loadMoreBlock();
//                    }else {
//                        [self.mj_footer endRefreshing];
//                    }
//                }];
//            }else {
//                self.mj_footer = nil;
//            }
        }
    }
    
    private var _releaseTupleKey: String?
    ///设置释放的key值
    var releaseTupleKey: String? {
        get {
            return _releaseTupleKey
        }
        set {
            if _releaseTupleKey != newValue {
                if _releaseTupleKey != nil && newValue != nil {
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(_releaseTupleKey!), object: nil)
                }
                _releaseTupleKey = newValue
                if _releaseTupleKey != nil {
                    NotificationCenter.default.addObserver(self, selector: #selector(releaseTupleBlock), name: NSNotification.Name.init(_releaseTupleKey!), object: nil)
                }
            }
        }
    }

    private var _reloadTupleKey: String?
    ///设置reload的key值
    var reloadTupleKey: String? {
        get {
            return _reloadTupleKey
        }
        set {
            if _reloadTupleKey != newValue {
                if _reloadTupleKey != nil && reloadTupleKey != nil {
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(_reloadTupleKey!), object: nil)
                }
                _reloadTupleKey = newValue
                if _reloadTupleKey != nil {
                    NotificationCenter.default.addObserver(self, selector: #selector(reloadTupleData), name: NSNotification.Name.init(_reloadTupleKey!), object: nil)
                }
            }
        }
    }

    ///block refresh & loadMore
    func beginRefreshing(_ completion: () -> Void) {
        if self.refreshBlock != nil {
            self.pageNo = 1
//            [self.mj_header beginRefreshingWithCompletionBlock:completion];
        }
    }

    ///stop refresh
    func endRefreshing(_ completion: () -> Void) {
//        [self.mj_header endRefreshingWithCompletionBlock:completion];
    }
    
    func endLoadMore(_ completion: () -> Void) {
//        [self.mj_footer endRefreshingWithCompletionBlock:completion];
    }
    
    ///bounce method
    func horizontalBounceEnabled() -> Void {
        self.bounces = true
        self.alwaysBounceHorizontal = true
        self.alwaysBounceVertical = false
    }

    func verticalBounceEnabled() -> Void {
        self.bounces = true
        self.alwaysBounceHorizontal = false
        self.alwaysBounceVertical = true
    }

    func bounceEnabled() -> Void {
        self.bounces = true
        self.alwaysBounceHorizontal = true
        self.alwaysBounceVertical = true
    }

    func bounceDisenable() -> Void {
        self.bounces = false
    }

    @objc private func reloadTupleData() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }

    /// release method
    @objc func releaseTupleBlock() -> Void {
        DispatchQueue.global().async {
            self.releaseAllSignal()
            self.clearTupleState()

            if self.tupleDelegate != nil { self.tupleDelegate = nil }
            if self.refreshBlock != nil { self.refreshBlock = nil }
            if self.loadMoreBlock != nil { self.loadMoreBlock = nil }
        }
    }

    private var addressValue: String {
        return String(format: "%p", self)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /// register class
    func dequeueReusableHeaderWithClass(_ cls: AnyClass, iblk: AnyObject?, pre: String?, idx: Bool, idxPath: IndexPath) -> AnyObject {
        var cell: HTupleBaseApex
        var identifier: String = NSStringFromClass(cls)
        identifier = identifier+self.addressValue
        identifier = identifier+"HeaderCell"
        if self.tupleStyle == .split && self.sectionPaths?.contains(idxPath.section) == false {
            identifier = identifier+"\(self.tupleState)"
        }
        if (pre != nil) { identifier = identifier+pre! }
        if idx { identifier = identifier+(idxPath.stringValue as String) }
        if self.allReuseIdentifiers.contains(identifier) == false {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier)
            cell = self.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier, for: idxPath) as! HTupleBaseApex
            cell.tuple = self
            cell.indexPath = idxPath
            cell.isHeader = true
            //init method
            if iblk != nil {
                let initHeaderBlock: HTupleCellInitBlock = iblk as! HTupleCellInitBlock
                initHeaderBlock(cell)
            }
        }else {
            cell = self.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier, for: idxPath) as! HTupleBaseApex
        }
        //保存cell
        self.allReuseHeaders.setObject(cell, forKey: idxPath.stringValue as NSString)
        //调用代理方法
        var edgeInsets: UIEdgeInsets = UIEdgeInsetsZero
        let prefix: String = self.prefixWithSection(idxPath.section)
        let selector: Selector = #selector(self.tupleDelegate!.edgeInsetsForHeaderInSection(_:))
        if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
            edgeInsets = (self.tupleDelegate!.performWithUnretainedValue(selector, with: idxPath.section, withPre: prefix) as! NSEdgeInsets).edgeInsetsValue
        }
        //设置属性
        if cell.responds(to: #selector(setter: cell.edgeInsets)) {
            cell.edgeInsets = edgeInsets
        }
        return cell
    }
    
    func dequeueReusableFooterWithClass(_ cls: AnyClass, iblk: AnyObject?, pre: String?, idx: Bool, idxPath: IndexPath) -> AnyObject {
        var cell: HTupleBaseApex
        var identifier: String = NSStringFromClass(cls)
        identifier = identifier+self.addressValue
        identifier = identifier+"FooterCell"
        if self.tupleStyle == .split && self.sectionPaths?.contains(idxPath.section) == false {
            identifier = identifier+"\(self.tupleState)"
        }
        if (pre != nil) { identifier = identifier+pre! }
        if idx { identifier = identifier+idxPath.stringValue }
        if self.allReuseIdentifiers.contains(identifier) == false {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: identifier)
            cell = self.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: identifier, for: idxPath) as! HTupleBaseApex
            cell.tuple = self
            cell.indexPath = idxPath
            cell.isHeader = true
            //init method
            if iblk != nil {
                let initFooterBlock: HTupleCellInitBlock = iblk as! HTupleCellInitBlock
                initFooterBlock(cell)
            }
        }else {
            cell = self.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: identifier, for: idxPath) as! HTupleBaseApex
        }
        //保存cell
        self.allReuseFooters.setObject(cell, forKey: idxPath.stringValue as NSString)
        //调用代理方法
        var edgeInsets: UIEdgeInsets = UIEdgeInsetsZero
        let prefix = self.prefixWithSection(idxPath.section)
        let selector = #selector(self.tupleDelegate!.edgeInsetsForFooterInSection(_:))
        if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
            edgeInsets = (self.tupleDelegate!.performWithUnretainedValue(selector, with: idxPath.section, withPre: prefix) as! NSEdgeInsets).edgeInsetsValue
        }
        //设置属性
        if cell.responds(to: #selector(setter: cell.edgeInsets)) {
            cell.edgeInsets = edgeInsets
        }
        return cell
    }

    func dequeueReusableCellWithClass(_ cls: AnyClass, iblk: AnyObject?, pre: String?, idx: Bool, idxPath: IndexPath) -> AnyObject {
        var cell: HTupleBaseCell
        var identifier: String = NSStringFromClass(cls)
        identifier = identifier+self.addressValue
        identifier = identifier+"ItemCell"
        if self.tupleStyle == .split && self.sectionPaths?.contains(idxPath.section) == false {
            identifier = identifier+"\(self.tupleState)"
        }
        if (pre != nil) { identifier = identifier+pre! }
        if idx { identifier = identifier+idxPath.stringValue }
        if self.allReuseIdentifiers.contains(identifier) == false {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forCellWithReuseIdentifier: identifier)
            cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: idxPath) as! HTupleBaseCell
            cell.tuple = self
            cell.indexPath = idxPath
            //init method
            if iblk != nil {
                let initCellBlock: HTupleCellInitBlock = iblk as! HTupleCellInitBlock
                initCellBlock(cell)
            }
        }else {
            cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: idxPath) as! HTupleBaseCell
        }
        //保存cell
        self.allReuseCells.setObject(cell, forKey: idxPath.stringValue as NSString)
        //调用代理方法
        var edgeInsets: UIEdgeInsets = UIEdgeInsetsZero
        let prefix = self.prefixWithSection(idxPath.section)
        let selector = #selector(self.tupleDelegate!.edgeInsetsForItemAtIndexPath(_:))
        if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
            edgeInsets = (self.tupleDelegate!.performWithUnretainedValue(selector, with: idxPath, withPre: prefix) as! NSEdgeInsets).edgeInsetsValue
        }
        //设置属性
        if cell.responds(to: #selector(setter: cell.edgeInsets)) {
            cell.edgeInsets = edgeInsets
        }
        return cell
    }
    
    /// UICollectionViewDatasource  & delegate
    private func prefixWithSection(_ section: Int) -> String {
        var prefix = ""
        if self.tupleStyle == .split {
            if (self.sectionPaths?.contains(section))! {
                let idx: Int = self.sectionPaths!.index(of: section)
                prefix = KTupleExaDesignKey+"\(idx)"+"_"
            }else {
                prefix = KTupleExaDesignKey+"\(self.tupleState)"+"_"
            }
        }
        return prefix
    }
    
    ///以下为UICollectionView的代理方法
    @available(iOS 6.0, *)
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.allSectionInsets.count > 0 {
            self.allSectionInsets.removeAllObjects()
        }
        switch self.tupleStyle {
        case .default:
            var sections = 0
            let prefix = ""
            let selector = #selector(self.tupleDelegate!.numberOfSectionsInTupleView)
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                sections = (self.tupleDelegate!.performWithUnretainedValue(selector, withPre: prefix) as! NSInt).intValue
            }
            return sections
        case .split:
            var sections = 0
            let prefix = KTupleDesignKey+"\(self.tupleState)"+"_"
            let selector = #selector(self.tupleDelegate!.numberOfSectionsInTupleView)
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                sections = (self.tupleDelegate!.performWithUnretainedValue(selector, withPre: prefix) as! NSInt).intValue
            }
            return sections
        }
    }
    
    @available(iOS 6.0, *)
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var items = 0
        let prefix = self.prefixWithSection(section)
        let selector: Selector = #selector(self.tupleDelegate!.numberOfItemsInSection(_:))
        if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
            items = (self.tupleDelegate!.performWithUnretainedValue(selector, with: section, withPre: prefix) as! NSInt).intValue
        }
        let edgeInsets = self.collectionView(self, layout: self.flowLayout!, insetForSectionAt: section)
        self.allSectionInsets.setObject(NSStringFromUIEdgeInsets(edgeInsets) as AnyObject, forKey: "\(section)" as NSString)
        return items
    }

    ///layout == HCollectionViewFlowLayout
    internal func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, colorForSectionAt section: NSInteger) -> UIColor {
        let prefix = self.prefixWithSection(section)
        let selector = #selector(self.tupleDelegate!.colorForSectionAt(_:))
        if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
            return self.tupleDelegate!.performWithUnretainedValue(selector, with: section, withPre: prefix) as! UIColor
        }
        return UIColor.clear
    }

    @available(iOS 6.0, *)
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    @available(iOS 6.0, *)
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    @available(iOS 6.0, *)
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let prefix = self.prefixWithSection(section)
        let selector = #selector(self.tupleDelegate!.insetForSection(_:))
        if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
            return (self.tupleDelegate!.performWithUnretainedValue(selector, with: section, withPre: prefix) as! NSEdgeInsets).edgeInsetsValue
        }
        return UIEdgeInsetsZero
    }
    
    @available(iOS 6.0, *)
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var size: CGSize = CGSizeZero
        let prefix = self.prefixWithSection(section)
        let selector = #selector(self.tupleDelegate!.sizeForHeaderInSection(_:))
        if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
            size = (self.tupleDelegate!.performWithUnretainedValue(selector, with: section, withPre: prefix) as! NSSize).sizeValue
        }
        return UISizeIntegral(size)
    }

    @available(iOS 6.0, *)
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        var size: CGSize = CGSizeZero
        let prefix = self.prefixWithSection(section)
        let selector = #selector(self.tupleDelegate!.sizeForFooterInSection(_:))
        if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
            size = (self.tupleDelegate!.performWithUnretainedValue(selector, with: section, withPre: prefix) as! NSSize).sizeValue
        }
        return UISizeIntegral(size)
    }
    
    @available(iOS 6.0, *)
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize = CGSizeZero
        let prefix = self.prefixWithSection(indexPath.section)
        let selector = #selector(self.tupleDelegate!.sizeForItemAtIndexPath(_:))
        if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
            size = (self.tupleDelegate!.performWithUnretainedValue(selector, with: indexPath, withPre: prefix) as! NSSize).sizeValue
        }
        //不能为CGSizeZero，否则会崩溃
        if CGSizeZero == size {
            size = CGSizeMake(1.0, 1.0)
        }
        return UISizeIntegral(size)
    }
    
    @available(iOS 6.0, *)
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //调用代理方法
        let prefix: String = self.prefixWithSection(indexPath.section)
        let selector: Selector = #selector(self.tupleDelegate!.tupleForItem(_:atIndexPath:))
        let cellObject = NSItem()
        cellObject.itemBlock =  { (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) in
            return self.dequeueReusableCellWithClass(cls, iblk: iblk, pre: pre, idx: idx, idxPath: indexPath)
        }
        if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
            self.tupleDelegate!.performWithUnretainedValue(selector, with: cellObject, with: indexPath, withPre: prefix)
        }
        //调用cell
        let cell = self.allReuseCells.object(forKey: indexPath.stringValue as NSString) as! HTupleBaseCell
        //更新布局
        if cell.responds(to: #selector(cell.relayoutSubviews)) {
            cell.relayoutSubviews()
        }
        return cell
    }
    
    @available(iOS 6.0, *)
    internal func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var cell: HTupleBaseApex?
        if kind == UICollectionElementKindSectionHeader {
            //调用代理方法
            let prefix: String = self.prefixWithSection(indexPath.section)
            let selector: Selector = #selector(self.tupleDelegate!.tupleForHeader(_:inSection:))
            let cellObject = NSHeader()
            cellObject.headerBlock = { (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject in
                return self.dequeueReusableHeaderWithClass(cls, iblk: iblk, pre: pre, idx: idx, idxPath: indexPath)
            }
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.performWithUnretainedValue(selector, with: cellObject, with: indexPath, withPre: prefix)
            }
            //调用cell
            cell = self.allReuseHeaders.object(forKey: indexPath.stringValue as NSString) as? HTupleBaseApex
        }else if (kind == UICollectionElementKindSectionFooter) {
            //调用代理方法
            let prefix: String = self.prefixWithSection(indexPath.section)
            let selector: Selector = #selector(self.tupleDelegate!.tupleForFooter(_:inSection:))
            let cellObject = NSFooter()
            cellObject.footerBlock = { (_ iblk: AnyObject?, _ cls: AnyClass, _ pre: String?, _ idx: Bool ) -> AnyObject in
                return self.dequeueReusableFooterWithClass(cls, iblk: iblk, pre: pre, idx: idx, idxPath: indexPath)
            }
            if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
                self.tupleDelegate!.performWithUnretainedValue(selector, with: cellObject, with: indexPath, withPre: prefix)
            }
            //调用cell
            cell = self.allReuseFooters.object(forKey: indexPath.stringValue as NSString) as? HTupleBaseApex
        }
        //更新布局
        if cell!.responds(to: #selector(cell!.relayoutSubviews)) {
            cell!.relayoutSubviews()
        }
        return cell!
    }
    
    @available(iOS 8.0, *)
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let prefix = self.prefixWithSection(indexPath.section)
        let selector = #selector(self.tupleDelegate!.willDisplayCell(_:atIndexPath:))
        if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
            self.tupleDelegate!.performWithUnretainedValue(selector, with: cell, with: indexPath, withPre: prefix)
        }
    }

    @available(iOS 6.0, *)
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let prefix = self.prefixWithSection(indexPath.section)
        let selector = #selector(self.tupleDelegate!.didSelectItemAtIndexPath(_:))
        if self.tupleDelegate!.responds(to: selector, withPre: prefix) {
            self.tupleDelegate!.performWithUnretainedValue(selector, with: indexPath, withPre: prefix)
        }
    }
    
}

/// 信号机制分类
extension HTupleView {

    ///tupleView持有的信号block
    var signalBlock: HTupleCellSignalBlock? {
        get {
            return self.getAssociatedValueForKey(#function) as? HTupleCellSignalBlock
        }
        set {
            self.setAssociateCopyValue(newValue, key: #function)
        }
    }
    
    ///给tupleView发送信号
    func signalToTupleView(_ signal: HTupleSignal) {
        if self.signalBlock != nil {
            DispatchQueue.main.async {
                self.signalBlock!(self, signal)
            }
        }
    }

    ///给所有item、某个section下的item或单独某个item发送信号
    func signalToAllItems(_ signal: HTupleSignal) {
        DispatchQueue.main.async {
            for object in self.allReuseCells.objectEnumerator()!.allObjects {
                let cell = object as! HTupleBaseCell
                if cell.signalBlock != nil {
                    cell.signalBlock!(cell, signal)
                }
            }
        }
    }

    func signal(_ signal: HTupleSignal, itemSection section: Int) {
        DispatchQueue.main.async {
            let items = self.numberOfItems(inSection: section)
            for i in 0..<items {
                let cell: HTupleBaseCell = self.allReuseCells.object(forKey: NSIndexPath.stringValue(i, section)) as! HTupleBaseCell
                if cell.signalBlock != nil {
                    cell.signalBlock!(cell, signal)
                }
            }
        }
    }

    func signal(_ signal: HTupleSignal, indexPath idxPath: NSIndexPath) {
        let cell: HTupleBaseCell = self.allReuseCells.object(forKey: idxPath.stringValue) as! HTupleBaseCell
        if cell.signalBlock != nil {
            DispatchQueue.main.async {
                cell.signalBlock!(cell, signal)
            }
        }
    }

    ///给所有header或单独某个header发送信号
    func signalToAllHeader(_ signal: HTupleSignal) {
        DispatchQueue.main.async {
            let sections = self.numberOfSections
            for i in 0..<sections {
                let header: HTupleBaseApex = self.allReuseCells.object(forKey: NSIndexPath.stringValue(0, i)) as! HTupleBaseApex
                if header.signalBlock != nil {
                    header.signalBlock!(header, signal)
                }
            }
        }
    }

    func signal(_ signal: HTupleSignal, headerSection section: Int) {
        let header: HTupleBaseApex = self.allReuseCells.object(forKey: NSIndexPath.stringValue(0, section)) as! HTupleBaseApex
        if header.signalBlock != nil {
            DispatchQueue.main.async {
                header.signalBlock!(header, signal)
            }
        }
    }

    ///给所有footer或单独某个footer发送信号
    func signalToAllFooter(_ signal: HTupleSignal) {
        DispatchQueue.main.async {
            let sections = self.numberOfSections
            for i in 0..<sections {
                let footer: HTupleBaseApex = self.allReuseCells.object(forKey: NSIndexPath.stringValue(0, i)) as! HTupleBaseApex
                if footer.signalBlock != nil {
                    footer.signalBlock!(footer, signal)
                }
            }
        }
    }

    func signal(_ signal: HTupleSignal, footerSection section: Int) {
        let footer: HTupleBaseApex = self.allReuseCells.object(forKey: NSIndexPath.stringValue(0, section)) as! HTupleBaseApex
        if footer.signalBlock != nil {
            DispatchQueue.main.async {
                footer.signalBlock!(footer, signal)
            }
        }
    }

    ///释放所有信号block
    func releaseAllSignal() {
        DispatchQueue.global().async {
            if self.signalBlock != nil {
                self.signalBlock = nil
            }
            //release all cell
            for object in self.allReuseCells.objectEnumerator()!.allObjects {
                let cell = object as! HTupleBaseCell
                if cell.signalBlock != nil {
                    cell.signalBlock = nil
                }
            }
            //release all header
            for object in self.allReuseHeaders.objectEnumerator()!.allObjects {
                let header = object as! HTupleBaseApex
                if header.signalBlock != nil {
                    header.signalBlock = nil
                }
            }
            //release all footer
            for object in self.allReuseFooters.objectEnumerator()!.allObjects {
                let footer = object as! HTupleBaseApex
                if footer.signalBlock != nil {
                    footer.signalBlock = nil
                }
            }
        }
    }

    ///根据传入的row和section获取cell或indexPath
    func cell(_ row: Int, _ section: Int) -> AnyObject {
        return self.allReuseCells.object(forKey: NSIndexPath.stringValue(row, section))!
    }
    func indexPath(_ row: Int, _ section: Int) -> NSIndexPath {
        return NSIndexPath(row: row, section: section)
    }

    ///获取某个section的宽高和大小
    func widthWithSection(_ section: Int) -> CGFloat {
        var width: CGFloat = self.width
        let edgeInsetsString: String = self.allSectionInsets.object(forKey: "\(section)" as NSString) as! String
        if edgeInsetsString.length > 0 {
            let edgeInsets = UIEdgeInsetsFromString(edgeInsetsString)
            width -= edgeInsets.left + edgeInsets.right
        }
        return width
    }

    func heightWithSection(_ section: Int) -> CGFloat {
        var height: CGFloat = self.height
        let edgeInsetsString: String = self.allSectionInsets.object(forKey: "\(section)" as NSString) as! String
        if edgeInsetsString.length > 0 {
            let edgeInsets = UIEdgeInsetsFromString(edgeInsetsString)
            height -= edgeInsets.top + edgeInsets.bottom
        }
        return height
    }
    
    func sizeWithSection(_ section: Int) -> CGSize {
        var size: CGSize = self.size
        let edgeInsetsString: String = self.allSectionInsets.object(forKey: "\(section)" as NSString) as! String
        if edgeInsetsString.length > 0 {
            let edgeInsets = UIEdgeInsetsFromString(edgeInsetsString)
            size.width  -= edgeInsets.left + edgeInsets.right
            size.height -= edgeInsets.top  + edgeInsets.bottom
        }
        return size
    }

    ///根据传入的个数和序号计算该item的宽度
    func fixSlitWith(_ width: CGFloat, colCount: Int, index: Int) -> CGFloat {
        let itemWidth: CGFloat = width/CGFloat(colCount)
        var realItemWidth: CGFloat = CGFloat(floorf(Float(itemWidth)))
        let idxCount: Int = colCount-1
        if index == idxCount {
            realItemWidth = width-CGFloat(Int(realItemWidth)*idxCount)
        }
        return realItemWidth
    }

}

private let KTupleStateKey = "_tuple_"

/// split设计数据存储分类
extension HTupleView {

    private var tupleStateSource: NSMutableDictionary {
        get {
            var dict: NSMutableDictionary? = self.getAssociatedValueForKey(#function) as? NSMutableDictionary
            if dict == nil {
                dict = NSMutableDictionary()
                self.setAssociateValue(dict, key: #function)
            }
            return dict!
        }
    }
    
    ///tupleView分体式设计所表示的状态
    private var tupleState: HTupleState {
        get {
            return self.getAssociatedValueForKey(#function) as? HTupleState ?? 0
        }
        set {
            if newValue != self.tupleState {
                self.setAssociateWeakValue(newValue, key: #function)
                self.reloadData()
            }
        }
    }

    ///向某个状态或当前状态添加一个值
    func setObject(_ anObject: AnyObject, forKey aKey: String) -> Void {
        self.setObject(anObject, forKey: aKey, state: self.tupleState)
    }
    
    func setObject(_ anObject: AnyObject, forKey aKey: String, state tupleState: HTupleState) -> Void {
        let key: NSString = aKey+KTupleStateKey+"\(tupleState)" as NSString
        self.tupleStateSource.setObject(anObject, forKey: key)
    }

    ///获取某个状态或当前状态的一个值
    func objectForKey(_ aKey: String) -> Any? {
        return self.objectForKey(aKey, state: self.tupleState)
    }
    
    func objectForKey(_ aKey: String, state tupleState: HTupleState) -> Any? {
        let key: NSString = aKey+KTupleStateKey+"\(tupleState)" as NSString
        return self.tupleStateSource.object(forKey: key)
    }

    ///删除某个状态或当前状态下的一个值
    func removeObjectForKey(_ aKey: String) -> Void {
        self.removeObjectForKey(aKey, state: self.tupleState)
    }
    
    func removeObjectForKey(_ aKey: String, state tupleState: HTupleState) -> Void {
        let key: NSString = aKey+KTupleStateKey+"\(tupleState)" as NSString
        self.tupleStateSource.removeObject(forKey: key)
    }

    ///删除某个状态或当前状态的值
    func removeStateObject() -> Void {
        self.removeObjectForState(self.tupleState)
    }
    
    func removeObjectForState(_ tupleState: HTupleState) -> Void {
        let key = KTupleStateKey+"\(tupleState)"
        for (aKey, _) in self.tupleStateSource.reversed() {
            let aKey: String = aKey as! String
            if key == aKey {
                self.tupleStateSource.removeObject(forKey: aKey)
            }
        }
        
    }

    ///删除所有状态的值
    func clearTupleState() -> Void {
        if self.tupleStateSource.count > 0 {
            self.tupleStateSource.removeAllObjects()
        }
    }

}
