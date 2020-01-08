//
//  HRegisterController+KS.swift
//  HSwiftProject
//
//  Created by wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension HRegisterController {

    @objc func tuple0_numberOfSectionsInTupleView() -> Any {
        return 3
    }
    @objc func tuple0_numberOfItemsInSection(_ section: Any) -> Any {
        switch (section as! Int) {
            case 1: return 6
            case 2: return 1
            default: return 0
        }
    }
    @objc func tuple0_sizeForHeaderInSection(_ section: Any) -> Any {
        switch (section as! Int) {
            case 1: return CGSizeMake(self.tupleView.width, 5)
            case 2: return CGSizeZero
            default: return CGSizeZero
        }
    }
    @objc func tuple0_sizeForFooterInSection(_ section: Any) -> Any {
        switch (section as! Int) {
            case 1: return CGSizeMake(tupleView.width, 15)
            case 2: return CGSizeZero
            default:return CGSizeZero
        }
    }
    @objc func tuple0_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.section) {
            case 1: return CGSizeMake(tupleView.width, 55)
            case 2: return CGSizeMake(tupleView.width, 55)
            default: return CGSizeZero
        }
    }

    @objc func tuple0_edgeInsetsForHeaderInSection(_ section: Any) -> Any {
        return UIEdgeInsetsZero
    }
    @objc func tuple0_edgeInsetsForFooterInSection(_ section: Any) -> Any {
        return UIEdgeInsetsZero
    }
    @objc func tuple0_edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.section) {
            case 2: return UIEdgeInsetsMake(0, 60, 0, 60)
            default: return UIEdgeInsetsZero
        }
    }

    @objc func tuple0_insetForSection(_ section: Any) -> Any {
        return UIEdgeInsetsZero
    }

    @objc func tuple0_tupleHeader(_ headerBlock: Any, inSection section: Any) {
        _ = (headerBlock as! HTupleHeader)(nil, HTupleBaseApex.self, nil, false)
    }
    @objc func tuple0_tupleFooter(_ footerBlock: Any, inSection section: Any) {
        _ = (footerBlock as! HTupleFooter)(nil, HTupleBaseApex.self, nil, false)
    }
    @objc func tuple0_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let cell = (itemBlock as! HTupleItem)(nil, HTupleTextFieldCell.self, "tuple0", true) as! HTupleTextFieldCell
        cell.textField.backgroundColor = UIColor.init(hex: "#F2F2F2")

        cell.textField.leftWidth = 80
        cell.textField.leftLabel.textAlignment = .center
        cell.textField.leftLabel.text = "昵称"

        cell.textField.textColor = UIColor.init(hex: "#BABABF")
        cell.textField.font = UIFont.systemFont(ofSize: 14)
        cell.textField.text = self.tupleView.objectForKey("state", state: 0) as? String

        cell.signalBlock = { ( cell: HTupleTextFieldCell, signal: HTupleSignal) in

        } as? HTupleCellSignalBlock
    }

}
