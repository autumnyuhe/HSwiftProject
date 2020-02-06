//
//  HRegisterController+SJ.swift
//  HSwiftProject
//
//  Created by wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension HRegisterController {

    @objc func tuple1_numberOfSectionsInTupleView() -> Any {
        return 3
    }
    @objc func tuple1_numberOfItemsInSection(_ section: Any) -> Any {
        switch (section as! Int) {
            case 1: return 5
            case 2: return 1
            default: return 0
        }
    }
    @objc func tuple1_sizeForHeaderInSection(_ section: Any) -> Any {
        switch (section as! Int) {
            case 1: return CGSizeMake(self.tupleView.width, 5)
            case 2: return CGSizeZero
            default: return CGSizeZero
        }
    }
    @objc func tuple1_sizeForFooterInSection(_ section: Any) -> Any {
        switch (section as! Int) {
            case 1: return CGSizeMake(tupleView.width, 15)
            case 2: return CGSizeZero
            default:return CGSizeZero
        }
    }
    @objc func tuple1_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.section) {
            case 1:
                if (indexPath.row == 0) {
                    return CGSizeMake(tupleView.width, 55)
                }else if (indexPath.row == 3) {
                    return CGSizeMake(tupleView.width-100, 55)
                }else if (indexPath.row == 4) {
                    return CGSizeMake(100, 55)
                }
                return CGSizeMake(tupleView.width, 55)
            case 2: return CGSizeMake(tupleView.width, 55)
            default: return CGSizeZero
        }
    }

    @objc func tuple1_edgeInsetsForHeaderInSection(_ section: Any) -> Any {
        return UIEdgeInsetsZero
    }
    @objc func tuple1_edgeInsetsForFooterInSection(_ section: Any) -> Any {
        return UIEdgeInsetsZero
    }
    @objc func tuple1_edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.section) {
            case 2: return UIEdgeInsetsMake(0, 30, 0, 30)
            default: return UIEdgeInsetsZero
        }
    }

    @objc func tuple1_insetForSection(_ section: Any) -> Any {
        return UIEdgeInsetsZero
    }

    @objc func tuple1_tupleHeader(_ headerBlock: Any, inSection section: Any) {
        _ = (headerBlock as! HTupleHeader)(nil, HTupleBaseApex.self, nil, false)
    }
    @objc func tuple1_tupleFooter(_ footerBlock: Any, inSection section: Any) {
        _ = (footerBlock as! HTupleFooter)(nil, HTupleBaseApex.self, nil, false)
    }
    @objc func tuple1_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let cell = (itemBlock as! HTupleItem)(nil, HTupleTextFieldCell.self, "tuple1", true) as! HTupleTextFieldCell
        cell.textField.backgroundColor = UIColor.init(hex: "#F2F2F2")

        cell.textField.leftWidth = 80
        cell.textField.leftLabel.textAlignment = .center
        cell.textField.leftLabel.text = "+86"

        cell.textField.textColor = UIColor.init(hex: "#BABABF")
        cell.textField.font = UIFont.systemFont(ofSize: 14)
        
        cell.textField.text = self.tupleView.objectForKey("state", state: 1) as? String

        cell.signalBlock = { ( target, signal) in
            let cell = target as! HTupleTextFieldCell
            NSLog("选中%d",cell)
        }
    }

}
