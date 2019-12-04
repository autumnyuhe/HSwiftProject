//
//  HMainViewController.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/14.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HMainViewController: HTupleController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional.tup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.leftNaviButton.isHidden = true
        self.title = "第一页"
        self.tupleView.tupleDelegate = self
    }

    func numberOfSectionsInTupleView() -> NSInt {
        return NSInt(value: 1)
    }
    func numberOfItemsInSection(_ section: Int) -> NSInt {
        return NSInt(value: 8)
    }
    func insetForSection(_ section: Int) -> NSEdgeInsets {
        return UIEdgeInsetsMake(0, 10, 0, 10).edgeInsetsValue
    }
    func colorForSection(_ section: Int) -> UIColor {
        return UIColor.red
    }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> NSSize {
        switch indexPath.row {
        case 0:
            return CGSizeMake(self.tupleView.widthWithSection(indexPath.section), 65).sizeValue
        case 1:
            return CGSizeMake(self.tupleView.widthWithSection(indexPath.section), 65).sizeValue
        case 2:
            return CGSizeMake(self.tupleView.widthWithSection(indexPath.section), 65).sizeValue
        case 3:
            var width: CGFloat = self.tupleView.widthWithSection(indexPath.section)
            width = self.tupleView.fixSlitWith(width, colCount: 3, index: indexPath.row-3)
            return CGSizeMake(width, 120).sizeValue
        case 4:
            var width: CGFloat = self.tupleView.widthWithSection(indexPath.section)
            width = self.tupleView.fixSlitWith(width, colCount: 3, index: indexPath.row-3)
            return CGSizeMake(width, 120).sizeValue
        case 5:
            var width: CGFloat = self.tupleView.widthWithSection(indexPath.section)
            width = self.tupleView.fixSlitWith(width, colCount: 3, index: indexPath.row-3)
            return CGSizeMake(width, 120).sizeValue
        default:
            return CGSizeMake(self.tupleView.widthWithSection(indexPath.section), 65).sizeValue
        }
    }
    func edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> NSEdgeInsets {
        switch (indexPath.row) {
            case 3:
                return UIEdgeInsetsMake(10, 10, 10, 5).edgeInsetsValue
            case 4:
                return UIEdgeInsetsMake(10, 5, 10, 5).edgeInsetsValue
            case 5:
                return UIEdgeInsetsMake(10, 5, 10, 10).edgeInsetsValue
            default:
                return UIEdgeInsetsMake(10, 10, 10, 10).edgeInsetsValue
        }
    }
    func tupleForItem(_ itemObject: NSTupleItem, atIndexPath indexPath: IndexPath) {
        switch indexPath.row {
            case 0:
                let cell = itemObject.itemBlock(nil, HTupleViewCellHoriValue4.self, nil, true) as! HTupleViewCellHoriValue4
                cell.backgroundColor = UIColor.gray
                cell.shouldShowSeparator = true
                cell.separatorInset = UILREdgeInsetsMake(10, 10)

                cell.imageView.backgroundColor = UIColor.red
                cell.imageView.setImageWithName("icon_no_server")

                cell.detailView.backgroundColor = UIColor.red
                cell.detailView.setImageWithName("icon_no_server")

    //            cell.detailWidth = 100
    //            cell.accessoryWidth = 100

                cell.showAccessoryArrow = true

    //            cell.labelInterval = 0

                cell.label.backgroundColor = UIColor.red
                cell.label.text = "wwwwwwwwwwwwww"
    //            cell.label.text:"wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww"
    //            cell.label.text:"wwwwwwwwwwwwwwwwwwww"
    //            cell.label.text:"wwwwwwwwwwwwwwwwwww"

                cell.detailLabel.backgroundColor = UIColor.yellow
                cell.detailLabel.text = "qqqqqqqqqqqqq"
    //            cell.detailLabel.text:"qqqqqqqqqqqqqqqqqqqqqqqq"

    //            cell.accessoryLabel.backgroundColor = UIColor.green

                //接收信号
                cell.signalBlock = { ( cell: HTupleViewCellHoriValue4, signal: HTupleSignal) in

                } as? HTupleCellSignalBlock
            case 1:
                let cell = itemObject.itemBlock(nil, HTupleViewCellHoriValue4.self, nil, true) as! HTupleViewCellHoriValue4
                cell.backgroundColor = UIColor.gray
                cell.shouldShowSeparator = true
                cell.separatorInset = UILREdgeInsetsMake(10, 10)

                cell.imageView.backgroundColor = UIColor.red
                cell.imageView.setImageWithName("icon_no_server")

                cell.label.backgroundColor = UIColor.red

                cell.detailLabel.backgroundColor = UIColor.yellow

                //接收信号
                cell.signalBlock = { ( cell: HTupleViewCellHoriValue4, signal: HTupleSignal) in

                } as? HTupleCellSignalBlock

                //发送信号
                //self.tupleView signal:nil indexPath:NSIndexPath.getValue(0, 0)
            case 2:
                let cell = itemObject.itemBlock(nil, HTupleViewCellHoriValue4.self, nil, true) as! HTupleViewCellHoriValue4
                cell.backgroundColor = UIColor.gray
                cell.shouldShowSeparator = true
                cell.separatorInset = UILREdgeInsetsMake(10, 10)

    //            cell.showAccessoryArrow = true

                cell.imageView.backgroundColor = UIColor.red
                cell.imageView.setImageWithName("icon_no_server")

                cell.detailView.backgroundColor = UIColor.red
                cell.detailView.setImageWithName("icon_no_server")

                cell.label.backgroundColor = UIColor.red

                cell.detailLabel.backgroundColor = UIColor.yellow
            case 3:
                let cell = itemObject.itemBlock(nil, HTupleViewCellVertValue1.self, nil, true) as! HTupleViewCellVertValue1
                cell.backgroundColor = UIColor.gray
                cell.shouldShowSeparator = true
                cell.separatorInset = UILREdgeInsetsMake(10, 0)

                cell.imageView.backgroundColor = UIColor.red
                cell.imageView.setImageWithName("icon_no_server")
                cell.imageView.fillet = true

                cell.labelHeight = 25
                cell.label.textAlignment = .center
                cell.label.text = "黑客帝国"
            case 4:
                let cell = itemObject.itemBlock(nil, HTupleViewCellVertValue1.self, nil, true) as! HTupleViewCellVertValue1
                cell.backgroundColor = UIColor.gray
                cell.shouldShowSeparator = true

                cell.imageView.backgroundColor = UIColor.red
                cell.imageView.setImageWithName("icon_no_server")
                cell.imageView.fillet = true

                cell.labelHeight = 25
                cell.label.textAlignment = .center
                cell.label.text = "黑客帝国"
            case 5:
                let cell = itemObject.itemBlock(nil, HTupleViewCellVertValue1.self, nil, true) as! HTupleViewCellVertValue1
                cell.backgroundColor = UIColor.gray
                cell.shouldShowSeparator = true
                cell.separatorInset = UILREdgeInsetsMake(0, 10)

                cell.imageView.backgroundColor = UIColor.red
                cell.imageView.setImageWithName("icon_no_server")
                cell.imageView.fillet = true

                cell.labelHeight = 25
                cell.label.textAlignment = .center
                cell.label.text = "黑客帝国"
            case 6:
                let cell = itemObject.itemBlock(nil, HTupleViewCellHoriValue3.self, nil, true) as! HTupleViewCellHoriValue3
                cell.backgroundColor = UIColor.gray
                cell.shouldShowSeparator = true
                cell.separatorInset = UILREdgeInsetsMake(10, 10)

                cell.detailWidth  = cell.layoutViewBounds.width/3
                cell.accessoryWidth = cell.layoutViewBounds.width/3
                cell.label.backgroundColor = UIColor.green
                cell.label.text = "label"
                cell.label.textAlignment = .center

                cell.detailLabel.backgroundColor = UIColor.red
                cell.detailLabel.text = "detailLabel"
                cell.detailLabel.textAlignment = .center

                cell.accessoryLabel.backgroundColor = UIColor.yellow
                cell.accessoryLabel.text = "accessoryLabel"
                cell.accessoryLabel.textAlignment = .center
            case 7:
                let cell = itemObject.itemBlock(nil, HTupleTextFieldCell.self, nil, true) as! HTupleTextFieldCell
                cell.backgroundColor = UIColor.gray
                cell.textField.backgroundColor = UIColor.red

                cell.textField.leftWidth = 50
                cell.textField.leftLabel.textAlignment = .center
                cell.textField.leftLabel.text = "验证码"
                cell.textField.leftLabel.backgroundColor = UIColor.green

                cell.textField.placeholder = "请输入验证码"
                cell.textField.placeholderColor = UIColor.white
                cell.textField.textColor = UIColor.white

                cell.textField.rightWidth = 90
                cell.textField.rightButton.text = "获取验证码"
                cell.textField.rightButton.backgroundColor = UIColor.green
                cell.textField.rightButton.pressed = { (sender: AnyObject, data: AnyObject) in

                } as? callback
            default: break
        }
    }
    func didSelectItemAtIndexPath(_ indexPath: NSIndexPath) {

    }

    
}
