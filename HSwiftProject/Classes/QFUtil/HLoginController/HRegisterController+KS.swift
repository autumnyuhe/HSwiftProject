//
//  HRegisterController+KS.swift
//  HSwiftProject
//
//  Created by wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension HRegisterController {

    @objc func tuple0_numberOfSectionsInTupleView() -> NSInt {
        return NSInt(value: 3)
    }
    @objc func tuple0_numberOfItemsInSection(_ section: NSInt) -> NSInt {
        switch (section.intValue) {
            case 1: return NSInt(value: 6)
            case 2: return NSInt(value: 1)
            default: return NSInt(value: 0)
        }
    }
    @objc func tuple0_sizeForHeaderInSection(_ section: NSInt) -> NSSize {
        switch (section.intValue) {
            case 1: return CGSizeMake(self.tupleView.width, 5).sizeValue
            case 2: return CGSizeZero.sizeValue
            default: return CGSizeZero.sizeValue
        }
    }
    @objc func tuple0_sizeForFooterInSection(_ section: NSInt) -> NSSize {
        switch (section.intValue) {
            case 1: return CGSizeMake(tupleView.width, 15).sizeValue
            case 2: return CGSizeZero.sizeValue
            default:return CGSizeZero.sizeValue
        }
    }
    @objc func tuple0_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> NSSize {
        switch (indexPath.section) {
            case 1: return CGSizeMake(tupleView.width, 55).sizeValue
            case 2: return CGSizeMake(tupleView.width, 55).sizeValue
            default: return CGSizeZero.sizeValue
        }
    }

    @objc func tuple0_edgeInsetsForHeaderInSection(_ section: NSInt) -> NSEdgeInsets {
        return UIEdgeInsetsZero.edgeInsetsValue
    }
    @objc func tuple0_edgeInsetsForFooterInSection(_ section: NSInt) -> NSEdgeInsets {
        return UIEdgeInsetsZero.edgeInsetsValue
    }
    @objc func tuple0_edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> NSEdgeInsets {
        switch (indexPath.section) {
            case 2: return UIEdgeInsetsMake(0, 60, 0, 60).edgeInsetsValue
            default: return UIEdgeInsetsZero.edgeInsetsValue
        }
    }

    @objc func tuple0_insetForSection(_ section: NSInt) -> NSEdgeInsets {
        return UIEdgeInsetsZero.edgeInsetsValue
    }

    @objc func tuple0_tupleHeader(_ headerObject: NSTupleHeader, inSection section: NSInt) {
        _ = headerObject.headerBlock(nil, HTupleBaseApex.self, nil, false)
    }
    @objc func tuple0_tupleFooter(_ footerObject: NSTupleFooter, inSection section: NSInt) {
        _ = footerObject.footerBlock(nil, HTupleBaseApex.self, nil, false)
    }
    @objc func tuple0_tupleItem(_ itemObject: NSTupleItem, atIndexPath indexPath: IndexPath) {
        let cell = itemObject.itemBlock(nil, HTupleTextFieldCell.self, "tuple0", true) as! HTupleTextFieldCell
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
