//
//  HMainController3+HSection0.swift
//  HSwiftProject
//
//  Created by wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension HMainController3 {

    @objc func tupleExa0_numberOfItemsInSection(_ section: Int) -> NSInt {
        return NSInt(value: 1)
    }
    @objc func tupleExa0_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> NSSize {
        return CGSizeMake(self.tupleView.width, 65).sizeValue
    }
    @objc func tupleExa0_edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> NSEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10).edgeInsetsValue
    }
    @objc func tupleExa0_tupleItem(_ itemObject: NSTupleItem, atIndexPath indexPath: IndexPath) {
        let cell = itemObject.itemBlock(nil, HTupleViewCell.self, nil, true) as! HTupleViewCell
        cell.backgroundColor = UIColor.gray
        cell.isShouldShowSeparator = true
        cell.separatorInset = UILREdgeInsetsMake(10, 10)
        
        let frame: CGRect = cell.layoutViewBounds
        
        var tmpFrame: CGRect = frame
        tmpFrame.size.width = tmpFrame.height
        cell.imageView.frame = tmpFrame
        cell.imageView.backgroundColor = UIColor.red
        cell.imageView.setImageWithName("icon_no_server")
        
        var tmpFrame2: CGRect = frame
        tmpFrame2.origin.x += tmpFrame.maxX+10
        tmpFrame2.size.width = frame.width-tmpFrame2.minX
        tmpFrame2.size.height = tmpFrame.height/3
        cell.label.frame = tmpFrame2
        cell.label.backgroundColor = UIColor.red
        
        var tmpFrame3: CGRect = tmpFrame2
        tmpFrame3.origin.y += tmpFrame2.maxY
        cell.detailLabel.frame = tmpFrame3
        cell.detailLabel.backgroundColor = UIColor.yellow
        
        var tmpFrame4: CGRect = tmpFrame2
        tmpFrame4.origin.y += tmpFrame3.maxY
        cell.accessoryLabel.frame = tmpFrame4
        cell.accessoryLabel.backgroundColor = UIColor.green
    }

}
