//
//  HRegisterController+SJ.swift
//  HSwiftProject
//
//  Created by wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension HRegisterController {

    @objc func tuple1_numberOfSectionsInTupleView() -> NSInt {
        return NSInt(value: 3)
    }
    @objc func tuple1_numberOfItemsInSection(_ section: NSInt) -> NSInt {
        switch (section.intValue) {
            case 1: return NSInt(value: 5)
            case 2: return NSInt(value: 1)
            default: return NSInt(value: 0)
        }
    }
    @objc func tuple1_sizeForHeaderInSection(_ section: NSInt) -> NSSize {
        switch (section.intValue) {
            case 1: return CGSizeMake(self.tupleView.width, 5).sizeValue
            case 2: return CGSizeZero.sizeValue
            default: return CGSizeZero.sizeValue
        }
    }
    @objc func tuple1_sizeForFooterInSection(_ section: NSInt) -> NSSize {
        switch (section.intValue) {
            case 1: return CGSizeMake(tupleView.width, 15).sizeValue
            case 2: return CGSizeZero.sizeValue
            default:return CGSizeZero.sizeValue
        }
    }
    @objc func tuple1_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> NSSize {
        switch (indexPath.section) {
            case 1:
                if (indexPath.row == 0) {
                    return CGSizeMake(tupleView.width, 55).sizeValue
                }else if (indexPath.row == 3) {
                    return CGSizeMake(tupleView.width-100, 55).sizeValue
                }else if (indexPath.row == 4) {
                    return CGSizeMake(100, 55).sizeValue
                }
                return CGSizeMake(tupleView.width, 55).sizeValue
            case 2: return CGSizeMake(tupleView.width, 55).sizeValue
            default: return CGSizeZero.sizeValue
        }
    }

    @objc func tuple1_edgeInsetsForHeaderInSection(_ section: NSInt) -> NSEdgeInsets {
        return UIEdgeInsetsZero.edgeInsetsValue
    }
    @objc func tuple1_edgeInsetsForFooterInSection(_ section: NSInt) -> NSEdgeInsets {
        return UIEdgeInsetsZero.edgeInsetsValue
    }
    @objc func tuple1_edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> NSEdgeInsets {
        switch (indexPath.section) {
            case 2: return UIEdgeInsetsMake(0, 30, 0, 30).edgeInsetsValue
            default: return UIEdgeInsetsZero.edgeInsetsValue
        }
    }

    @objc func tuple1_insetForSection(_ section: NSInt) -> NSEdgeInsets {
        return UIEdgeInsetsZero.edgeInsetsValue
    }

    @objc func tuple1_tupleHeader(_ headerObject: NSTupleHeader, inSection section: NSInt) {
        headerObject.headerBlock(nil, HTupleBaseApex.self, nil, false)
    }
    @objc func tuple1_tupleFooter(_ footerObject: NSTupleFooter, inSection section: NSInt) {
        footerObject.footerBlock(nil, HTupleBaseApex.self, nil, false)
    }
    @objc func tuple1_tupleItem(_ itemObject: NSTupleItem, atIndexPath indexPath: IndexPath) {
        let cell = itemObject.itemBlock(nil, HTupleTextFieldCell.self, "tuple1", true) as! HTupleTextFieldCell
        cell.textField.backgroundColor = UIColor.init(hex: "#F2F2F2")

        cell.textField.leftWidth = 80
        cell.textField.leftLabel.textAlignment = .center
        cell.textField.leftLabel.text = "+86"

        cell.textField.textColor = UIColor.init(hex: "#BABABF")
        cell.textField.font = UIFont.systemFont(ofSize: 14)
        
        cell.textField.text = self.tupleView.objectForKey("state", state: 1) as? String

        cell.signalBlock = { ( cell: HTupleTextFieldCell, signal: HTupleSignal) in

        } as? HTupleCellSignalBlock
    }

}
