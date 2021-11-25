//
//  NSString+HSize.swift
//  HSwiftProject
//
//  Created by Wind on 25/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

extension NSString {
    /**
     *  @brief 计算文字的高度
     *
     *  @param font  字体(默认为系统字体)
     *  @param width 约束宽度
     */
    func heightWithFont(_ font: UIFont?, constrainedToWidth width: CGFloat) -> CGFloat {
        
        var textFont: UIFont? = font
        if (font == nil) {
            textFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }
        
        let paragraph = NSMutableParagraphStyle.init()
        paragraph.lineBreakMode = .byWordWrapping
        
        let textSize = self.boundingRect(with: CGSizeMake(width, CGFloat.greatestFiniteMagnitude),
                                         options: .usesLineFragmentOrigin,
                                         attributes: [NSAttributedString.Key.font : textFont!, NSAttributedString.Key.paragraphStyle : paragraph],
                                         context: nil).size
        
        return ceil(textSize.height)
    }

    /**
     *  @brief 计算文字的宽度
     *
     *  @param font   字体(默认为系统字体)
     *  @param height 约束高度
     */
    func widthWithFont(_ font: UIFont?, constrainedToHeight height: CGFloat) -> CGFloat {

        var textFont: UIFont? = font
        if (font == nil) {
            textFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }
        
        let paragraph = NSMutableParagraphStyle.init()
        paragraph.lineBreakMode = .byWordWrapping
        
        let textSize = self.boundingRect(with: CGSizeMake(CGFloat.greatestFiniteMagnitude, height),
                                         options: .usesLineFragmentOrigin,
                                         attributes: [NSAttributedString.Key.font : textFont!, NSAttributedString.Key.paragraphStyle : paragraph],
                                         context: nil).size
        
        return ceil(textSize.width)
    }

    /**
     *  @brief 计算文字的大小
     *
     *  @param font  字体(默认为系统字体)
     *  @param width 约束宽度
     */
    func sizeWithFont(_ font: UIFont?, constrainedToWidth width: CGFloat) -> CGSize {

        var textFont: UIFont? = font
        if (font == nil) {
            textFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }
        
        let paragraph = NSMutableParagraphStyle.init()
        paragraph.lineBreakMode = .byWordWrapping
        
        let textSize = self.boundingRect(with: CGSizeMake(width, CGFloat.greatestFiniteMagnitude),
                                         options: .usesLineFragmentOrigin,
                                         attributes: [NSAttributedString.Key.font : textFont!, NSAttributedString.Key.paragraphStyle : paragraph],
                                         context: nil).size
        
        return CGSizeMake(ceil(textSize.width), ceil(textSize.height))
    }

    /**
     *  @brief 计算文字的大小
     *
     *  @param font   字体(默认为系统字体)
     *  @param height 约束高度
     */
    func sizeWithFont(_ font: UIFont?, constrainedToHeight height: CGFloat) -> CGSize {

        var textFont: UIFont? = font
        if (font == nil) {
            textFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }
        
        let paragraph = NSMutableParagraphStyle.init()
        paragraph.lineBreakMode = .byWordWrapping
        
        let textSize = self.boundingRect(with: CGSizeMake(CGFloat.greatestFiniteMagnitude, height),
                                         options: .usesLineFragmentOrigin,
                                         attributes: [NSAttributedString.Key.font : textFont!, NSAttributedString.Key.paragraphStyle : paragraph],
                                         context: nil).size
        
        return CGSizeMake(ceil(textSize.width), ceil(textSize.height))
    }


    /**
     *  @brief  反转字符串
     *
     *  @param strSrc 被反转字符串
     *
     *  @return 反转后字符串
     */
    static func reverseString(_ strSrc: NSString) -> NSString {

        let reverseString = NSMutableString.init()
        var charIndex = strSrc.length
        
        while (charIndex > 0) {
            charIndex -= 1
            reverseString.append(strSrc.substring(with: NSMakeRange(charIndex, 1)))
        }
        return reverseString
    }
    
}
