//
//  HLiveRoomCell+HSection1.swift
//  HSwiftProject
//
//  Created by Wind on 20/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

class HLiveRoomMiddleBarView : UIView, HTupleViewDelegate {
    
    var mutableArr: NSMutableArray = NSMutableArray.init()
    var timer: Timer?
    
    private var _tupleView: HTupleView?
    var tupleView: HTupleView {
        if (_tupleView == nil) {
            _tupleView = HTupleView.init(frame: self.bounds)
            _tupleView!.backgroundColor = UIColor.clear
            _tupleView!.verticalBounceEnabled()
            //将tupleView倒置
            _tupleView!.transform = CGAffineTransform (scaleX: 1, y: -1)
        }
        return _tupleView!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tupleView.delegate = self
        self.addSubview(self.tupleView)
        //设置tupleView release key
        self.tupleView.releaseTupleKey = KLiveRoomReleaseTupleKey
        for i in 0..<5 {
            let string = "黑客帝国".appendingFormat("%d", i)
            self.mutableArr.add(string)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(liveRoomReleaseTuple), name: NSNotification.Name.init(KLiveRoomReleaseTupleKey), object: nil)
        self.timer = Timer.init(timeInterval: 2, repeats: true) { timer in
            let string = "黑客帝国".appendingFormat("%lu", self.mutableArr.count)
            self.mutableArr.add(string)
            self.tupleView.reloadData()
            DispatchQueue.main.async { [weak self] in
                self!.scrollViewToBottom()
            }
        }
        RunLoop.current.add(self.timer!, forMode: .common)
    }
    
    @objc func liveRoomReleaseTuple() {
        self.timer?.invalidate()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func numberOfItemsInSection(_ section: Any) -> Any {
        return self.mutableArr.count
    }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSizeMake(self.tupleView.width, 25)
    }
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        
//        let cell = itemBlock(nil, HTupleNoteCell.self, nil, true) as! HTupleNoteCell
        let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
        //将cell.contentView倒置
        cell.layoutView.transform = CGAffineTransform (scaleX: 1, y: -1)
        cell.setTopLineWithColor(UIColor.init(white: 0.1, alpha: 0.2), paddingLeft: 0, paddingRight: 20)
        cell.label.textColor = UIColor.white
        cell.label.font = UIFont.systemFont(ofSize: 12)
        //此处数据源需要倒着加载
        let index = self.mutableArr.count - 1 - indexPath.row
        let string = self.mutableArr[index] as! String
        cell.label.text = string
    }
    private func scrollViewToBottom() {
        self.tupleView.setContentOffset(CGPointMake(0, 0), animated: true)
    }

}

extension HLiveRoomCell {
    @objc func tupleExa1_insetForSection(_ section: Any) -> Any {
        return UIEdgeInsetsMake(0, 10, 0, 10)
    }
    @objc func tupleExa1_numberOfItemsInSection(_ section: Any) -> Any {
        return 3
    }
    @objc func tupleExa1_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
            case 0:
                return CGSizeMake(self.liveRightView.width-20, 60)
            case 1:
                return CGSizeMake(self.liveRightView.width-20, 60)
            case 2:
                var height = UIScreen.height
                height -= (UIScreen.statusBarHeight+5)+35*3+18;//section0的高度
                height -= 60+60;//section1的row0和row1高度
                height -= (UIScreen.bottomBarHeight+5)+40;//section2的高度
                return CGSizeMake(self.liveRightView.width, height);
            default:
                break;
        }
        return CGSizeZero;
    }
    @objc func tupleExa1_edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
            case 0:
                return UIEdgeInsetsMake(10, 0, 5, 0)
            case 1:
                return UIEdgeInsetsMake(5, 0, 10, 0)
            case 2:
                return UIEdgeInsetsZero
            default:
                break;
        }
        return UIEdgeInsetsZero
    }
    @objc func tupleExa1_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        switch (indexPath.row) {
            case 0:
                let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
                var buttonView = cell.viewWithTag(123456) as? HWebButtonView
                if (buttonView == nil) {
                    var tmpFrame = cell.layoutViewBounds
                    tmpFrame.x = tmpFrame.width - tmpFrame.height;
                    tmpFrame.width = tmpFrame.height;
                    buttonView = HWebButtonView.init(frame: tmpFrame)
                    buttonView!.backgroundColor = UIColor.red
                    buttonView!.cornerRadius = buttonView!.width/2
                    buttonView!.setImageWithName("icon_no_server")
//                    buttonView! setFillet:YES];
                    buttonView!.tag = 123456
                    cell.addSubview(buttonView!)
//                    [buttonView setPressed:^(id sender, id data) {
//                        [[self viewController] presentController:HAlertController.new completion:^(HTransitionType transitionType) {
//                            NSLog(@"");
//                        }];
//                    }];
                }
                var honorLabel = cell.viewWithTag(234567) as? UILabel
                if (honorLabel == nil) {
                    let frame = CGRectMake(self.width, 10, 80, 25)
                    honorLabel = UILabel.init(frame: frame)
                    honorLabel!.text = "恭喜中奖!!!"
                    honorLabel!.font = UIFont.systemFont(ofSize: 12)
                    honorLabel!.textColor = UIColor.white
                    honorLabel!.backgroundColor = UIColor.red
                    honorLabel!.textAlignment = .center
                    honorLabel!.cornerRadius = honorLabel!.height/2
                    honorLabel!.tag = 234567
                    cell.addSubview(honorLabel!)
                    
                    let honorTimer = Timer.init(timeInterval: 5, repeats: true) { timer in
                        honorLabel!.frame = CGRectMake(cell.width, 10, 80, 25)
                        UIView.animate(withDuration: 0.7) {
                            honorLabel!.frame = CGRectMake(0, 10, 80, 25)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now()+3.0, execute: {
                            UIView.animate(withDuration: 0.3) {
                                honorLabel!.frame = CGRectMake(-100, 10, 80, 25)
                            }
                        });
                    }
                    RunLoop.current.add(honorTimer, forMode: .common)
                }
                break;
            case 1:
                let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
                var buttonView = cell.viewWithTag(123456) as? HWebButtonView
                if (buttonView == nil) {
                    var tmpFrame = cell.layoutViewBounds
                    tmpFrame.x = tmpFrame.width - tmpFrame.height;
                    tmpFrame.width = tmpFrame.height;
                    buttonView = HWebButtonView.init(frame: tmpFrame)
                    buttonView!.backgroundColor = UIColor.red
                    buttonView!.cornerRadius = buttonView!.width/2
                    buttonView!.setImageWithName("icon_no_server")
//                    buttonView! setFillet:YES];
                    buttonView!.tag = 123456
                    cell.addSubview(buttonView!)
//                    [buttonView setPressed:^(id sender, id data) {
//                        [[self viewController] presentController:HAlertController.new completion:^(HTransitionType transitionType) {
//                            NSLog(@"");
//                        }];
//                    }];
                }
                break;
            case 2:
                let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
                var bottomBarView = cell.viewWithTag(123456) as? HLiveRoomMiddleBarView
                if (bottomBarView == nil) {
                    bottomBarView = HLiveRoomMiddleBarView.init(frame: cell.bounds)
                    bottomBarView!.tag = 123456
                    cell.addSubview(bottomBarView!)
                }
                break;
            default:
                break;
        }
    }
}
