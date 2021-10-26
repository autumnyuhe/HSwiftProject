//
//  HMainController3+HSection1.swift
//  HSwiftProject
//
//  Created by wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension HMainController3 {

    @objc func tupleExa1_numberOfItemsInSection(_ section: Any) -> Any {
        return 1
    }
    @objc func tupleExa1_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSizeMake(self.tupleView.width, 65)
    }
    @objc func tupleExa1_edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    @objc func tupleExa1_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(nil, HTupleViewCell.self, nil, true) as! HTupleViewCell
        cell.backgroundColor = UIColor.gray
        cell.isShouldShowSeparator = true
        cell.separatorInset = UILREdgeInsetsMake(10, 10)
        
        let frame: CGRect = cell.layoutViewBounds
        
        var tmpFrame: CGRect = frame
        tmpFrame.size.width = tmpFrame.height
        cell.imageView.frame = tmpFrame
        cell.imageView.backgroundColor = UIColor.red
        cell.imageView.setImageWithName("icon_no_server")
        
        var tmpFrame2: CGRect = CGRectMake(0, 0, 7, 13)
        tmpFrame2.origin.x = frame.width-tmpFrame2.width
        tmpFrame2.origin.y = frame.height/2-tmpFrame2.height/2
        cell.accessoryImageView.frame = tmpFrame2
        cell.accessoryImageView.setImageWithName("icon_tuple_arrow_right")
        
        var tmpFrame3: CGRect = frame
        tmpFrame3.origin.x += tmpFrame.maxY+10
        tmpFrame3.size.width = tmpFrame2.minX-tmpFrame3.minX-10
        tmpFrame3.size.height = tmpFrame.size.height/2
        cell.label.frame = tmpFrame3
        cell.label.backgroundColor = UIColor.red
        
        var tmpFrame4: CGRect = tmpFrame3
        tmpFrame4.origin.y += tmpFrame3.maxY
        cell.detailLabel.frame = tmpFrame4
        cell.detailLabel.backgroundColor = UIColor.yellow
    }

}
