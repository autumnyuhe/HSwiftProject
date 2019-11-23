//
//  HGeometry.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

public struct UITBEdgeInsets {

    public var top: CGFloat

    public var bottom: CGFloat

    public init()

    public init(top: CGFloat, bottom: CGFloat)
}

public struct UILREdgeInsets {

    public var left: CGFloat

    public var right: CGFloat

    public init()

    public init(left: CGFloat, right: CGFloat)
}

extension UITBEdgeInsets : Equatable {
    public static func == (lhs: UITBEdgeInsets, rhs: UITBEdgeInsets) -> Bool
}

extension UILREdgeInsets : Equatable {
    public static func == (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> Bool
}

func  UIRectIntegral(_ rect: CGRect) -> CGRect {
    let x: CGFloat = floorf(rect.x)
    let y: CGFloat = floorf(rect.y)
    let width: CGFloat = floorf(rect.x + rect.width - x)
    let height: CGFloat = floorf(rect.y + rect.height - y)
    return CGRect(x: x, y: y, width: width, height: height)
}

func UISizeIntegral(_ size: CGSize) -> CGSize {
    return CGSize(width: floorf(size.width), height: floorf(size.height))
}

public let UITBEdgeInsetsZero = UITBEdgeInsets(top: 0.0, bottom: 0.0)
public let UILREdgeInsetsZero = UILREdgeInsets(left: 0.0, right: 0.0)
public let UIEdgeInsetsZero = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
public let CGSizeZero = CGSize(width: 0.0, height: 0.0)

func UITBEdgeInsetsMake(_ top: CGFloat, _ bottom: CGFloat) -> UITBEdgeInsets { return UITBEdgeInsets(top: top, bottom: bottom) }
func UILREdgeInsetsMake(_ left: CGFloat, _ right: CGFloat) -> UILREdgeInsets { return UILREdgeInsets(left: left, right: right) }
func UIEdgeInsetsMake(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) -> UIEdgeInsets { return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right) }
func CGSizeMake(_ width: CGFloat, _ height: CGFloat) -> CGSize { return CGSize(width: width, height: height) }


public func NSStringFromUIEdgeInsets(_ edgeInsets: UIEdgeInsets) -> String {
    return "top:\(edgeInsets.top),"+"left:\(edgeInsets.left),"+"bottom:\(edgeInsets.bottom),"+"right:\(edgeInsets.right)"
}
public func UIEdgeInsetsFromString(_ namestr: NSString) -> UIEdgeInsets {
    let arr = namestr.components(separatedBy: ",")
    let edgeInsets = UIEdgeInsetsZero
    for name in arr {
        let arr = namestr.components(separatedBy: ":")
        if arr.count == 2 {
            let first = arr[0]
            let last  = CGFloat(arr[1])
            if first == "top"         { edgeInsets.top = last }
            else if first == "left"   { edgeInsets.left = last }
            else if first == "bottom" { edgeInsets.bottom = last }
            else if first == "right"  { edgeInsets.right = last }
        }
    }
    return edgeInsets
}
