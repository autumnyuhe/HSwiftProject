//
//  HCollectionViewFlowLayout.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private let HCollectionViewSectionColor = "com.dqf.HCollectionElementKindSectionColor"

private class HCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes {
    var backgroundColor: UIColor? //背景色
}

private class HCollectionReusableView : UICollectionReusableView {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let attr = layoutAttributes as! HCollectionViewLayoutAttributes
    }
}

/// 扩展section的背景色
protocol HCollectionViewDelegateFlowLayout : UICollectionViewDelegateFlowLayout {
    @objc func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, colorForSectionAtIndex: NSInteger) -> UIColor
}

class HCollectionViewFlowLayout : UICollectionViewFlowLayout {
    
    private var decorationViewAttrs = NSMutableArray()
    
    override func prepare() {
        super.prepare()
        
        let sections: Int = self.collectionView!.numberOfSections
        let delegate: HCollectionViewDelegateFlowLayout = self.collectionView!.delegate as! HCollectionViewDelegateFlowLayout
        if delegate.responds(to: #selector(collectionView(_:layout:colorForSectionAtIndex:))) == false {
            return
        }
        
        //1.初始化
        self.register(HCollectionReusableView.self, forDecorationViewOfKind: HCollectionViewSectionColor)
        self.decorationViewAttrs.removeAllObjects()
        
        for section in 0..<sections {
            let numberOfItems = self.collectionView?.numberOfItems(inSection: section)
            if numberOfItems > 0 {
                let firstAttr: UICollectionViewLayoutAttributes = self.layoutAttributesForItem(at: NSIndexPath(row: 0, section: section))
                let lastAttr: UICollectionViewLayoutAttributes = self.layoutAttributesForItem(at: NSIndexPath(row: numberOfItems-1, section: section))
                
                let sectionInset = self.sectionInset
                if delegate.responds(to: #selector(collectionView(_:layout:insetForSectionAtIndex:))) {
                    let inset: UIEdgeInsets = delegate.collectionView(self.collectionView, layout: self, insetForSectionAtIndex: section)
                    if inset !=  sectionInset {
                        sectionInset = inset
                    }
                }
                
                let sectionFrame: CGRect = firstAttr.frame.union(lastAttr.frame)
                sectionFrame.origin.x -= sectionInset.left
                sectionFrame.origin.y -= sectionInset.top
                
                if (self.scrollDirection == .horizontal) {
                    sectionFrame.size.width += sectionInset.left + sectionInset.right
                    sectionFrame.size.height = self.collectionView.frame.size.height
                }else {
                    sectionFrame.size.width = self.collectionView.frame.size.width
                    sectionFrame.size.height += sectionInset.top + sectionInset.bottom
                }
                
                //2. 定义
                
                let attr: HCollectionViewLayoutAttributes = HCollectionViewLayoutAttributes.init(forDecorationViewOfKind: HCollectionViewSectionColor, with: NSIndexPath(row: 0, section: section))
//                HCollectionViewLayoutAttributes *attr = [HCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:HCollectionViewSectionColor withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
                attr.frame = sectionFrame
                attr.zIndex = -1
                attr.backgroundColor = delegate.collectionView(self.collectionView, layout: self, colorForSectionAtIndex: section)
                self.decorationViewAttrs.add(attr)
            }else {
                continue
            }
        }
        
    }

    //此类原有方法 并加上 去掉Cell之间的间隔线
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attrs: NSMutableArray = super.layoutAttributesForElements(in: rect)
        for attr: UICollectionViewLayoutAttributes in self.decorationViewAttrs {
            if rect == attr.frame {
                attrs.add(attr)
            }
        }
    }
    
}
