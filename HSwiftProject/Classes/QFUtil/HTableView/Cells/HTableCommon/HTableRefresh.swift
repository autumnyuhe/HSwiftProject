//
//  HTableRefresh.swift
//  HSwiftProject
//
//  Created by wind on 2019/12/25.
//  Copyright © 2019 wind. All rights reserved.
//

import MJRefresh

enum HTableRefreshHeaderStyle : Int {
    case gray = 0
    case white = 1
}

enum HTableRefreshFooterStyle : Int {
    case style1 = 0
    case style2 = 1
}

class HTableRefresh : NSObject {
    static func refreshHeaderWithStyle(_ style: HTableRefreshHeaderStyle, refreshingBlock: @escaping MJRefreshComponentAction) -> MJRefreshHeader {
        switch (style) {
        case HTableRefreshHeaderStyle.gray:
            let header: MJRefreshNormalHeader = MJRefreshNormalHeader(refreshingBlock: refreshingBlock)
            header.isAutomaticallyChangeAlpha = true
            header.lastUpdatedTimeLabel?.isHidden = true
            header.stateLabel?.isHidden = true
            header.activityIndicatorViewStyle = UIActivityIndicatorView.Style.gray
            return header
        case HTableRefreshHeaderStyle.white:
            let header: MJRefreshNormalHeader = MJRefreshNormalHeader(refreshingBlock: refreshingBlock)
            header.isAutomaticallyChangeAlpha = true
            header.lastUpdatedTimeLabel?.isHidden = true
            header.stateLabel?.isHidden = true
            header.activityIndicatorViewStyle = UIActivityIndicatorView.Style.white
            return header
        }
    }
    
    static func refreshFooterWithStyle(_ style: HTableRefreshFooterStyle, refreshingBlock: @escaping MJRefreshComponentAction) -> MJRefreshFooter {
        switch (style) {
        case HTableRefreshFooterStyle.style1:
            let footer: MJRefreshAutoNormalFooter = MJRefreshAutoNormalFooter(refreshingBlock: refreshingBlock)
            footer.setTitle("暂无更多数据", for: MJRefreshState.noMoreData)
            footer.setTitle("", for: MJRefreshState.idle)
            footer.isRefreshingTitleHidden = true
            return footer
        case HTableRefreshFooterStyle.style2:
            let footer: MJRefreshAutoNormalFooter = MJRefreshAutoNormalFooter(refreshingBlock: refreshingBlock)
            footer.setTitle("我们也是有底线的", for: MJRefreshState.noMoreData)
            footer.setTitle("", for: MJRefreshState.idle)
            footer.isRefreshingTitleHidden = true
            return footer
        }
    }
}
