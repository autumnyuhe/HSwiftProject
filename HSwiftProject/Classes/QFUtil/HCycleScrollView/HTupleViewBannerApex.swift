//
//  HTupleViewBannerApex.swift
//  HSwiftProject
//
//  Created by wind on 2020/2/21.
//  Copyright © 2020 wind. All rights reserved.
//

import UIKit

typealias HTupleViewBannerApexBlock = (_ index: Int) -> Void

class HTupleViewBannerApex : HTupleBaseApex, HCycleScrollViewDelegate {
    
    private var _cycleScrollView: HCycleScrollView?
    private var cycleScrollView: HCycleScrollView {
        if _cycleScrollView == nil {
            _cycleScrollView = HCycleScrollView.cycleScrollViewWithFrame(self.bounds, delegate: self, placeholderImage: UIImage(named: "HCyclePlaceholder")!)
            _cycleScrollView!.pageControlAliment = .Center
            _cycleScrollView!.currentPageDotColor = UIColor.white
        }
        return _cycleScrollView!
    }
    
    private var _imageUrlArr: NSArray?
    var imageUrlArr: NSArray? {
        get {
            return _imageUrlArr
        }
        set {
            if (_imageUrlArr != newValue) {
                _imageUrlArr = nil
                _imageUrlArr = newValue
                self.cycleScrollView.imageURLStringsGroup = newValue
            }
        }
    }
    var selectedBannerBlock: HTupleViewBannerApexBlock?


    override func relayoutSubviews() {
        HLayoutTupleApex(self.cycleScrollView)
    }

    override func initUI() {
        self.layoutView.addSubview(self.cycleScrollView)
    }

    /// HCycleScrollViewDelegate
    
    func cycleScrollView(_ cycleScrollView: HCycleScrollView, didSelectItemAtIndex index: Int) {
        if (self.selectedBannerBlock != nil) {
            self.selectedBannerBlock!(index)
        }
    }

}

