//
//  String+Crypto.swift
//  FNXP
//
//  Created by 荣恒 on 2017/8/31.
//  Copyright © 2017年 荣恒. All rights reserved.
//

import Foundation
import UIKit


// MARK: - 字符串截取
extension String {
    
    /// 从开始到index
    func subStringStart(to index: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    
    /// 从index到结束
    func subStringEnd(from index: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
    
    func subStringStart(to sub: String) -> String {
        let s = self.range(of: sub)?.lowerBound.encodedOffset
        let start = self.index(startIndex, offsetBy: s!)
        return String(self[..<start])
    }

    func subStringEnd(from sub: String) -> String {
        let e = self.range(of: sub)?.upperBound.encodedOffset
        let end = self.index(startIndex, offsetBy: e!)
        return String(self[end...])
    }
    
    /// 范围截取字符串
    func subString(_ start : Int, _ end : Int) -> String {
        let s = self.index(startIndex, offsetBy: start)
        let e = self.index(s, offsetBy: end)
        return String(self[s ..< e])
    }
    
    /// 根据字符 来 截取字符串。获取两字符间的内容
    func subStringRange(_ start : String, _ end : String) -> String {
        let s = self.range(of: start)?.upperBound.encodedOffset
        let e = self.range(of: end)?.lowerBound.encodedOffset
        return String(self[s! ..< e!])
    }
}

// MARK: - 富文本
extension String {
    // MARK: - 创建富文本字符串
    func attributeString(_ subString : String,
                         _ color : UIColor,
                         _ font : UIFont?) -> NSMutableAttributedString {
        
        var start = 0
        var ranges: [NSRange] = []
        while true {
            let range = (self as NSString).range(
                of: subString,
                options: NSString.CompareOptions.literal,
                range: NSRange(location: start,
                               length: (self as NSString).length - start))
            if range.location == NSNotFound {
                break
            } else {
                ranges.append(range)
                start = range.location + range.length
            }
        }
        let attrText = NSMutableAttributedString(string: self)
        for range in ranges {
            /// 给自字符串设置颜色和字体
            attrText
                .addAttribute(NSAttributedString.Key
                .foregroundColor,
                                  value: color,
                                  range: range)
            if let font = font {
                attrText
                    .addAttribute(NSAttributedString.Key.font,
                                  value: font,
                                  range: range)
            }
        }
        return attrText
    }
    
}


// MARK: - 字符串Size
extension String {
    
    /// 根据宽度和字体计算高度
    func height(_ width: CGFloat, font: UIFont) -> CGFloat {
        let attrib: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: font]
        let size = CGSize(width: width, height: CGFloat(Double.greatestFiniteMagnitude))
        
        return ceil((self as NSString).boundingRect(with: size,
                                                    options: .usesLineFragmentOrigin,
                                                    attributes:attrib, context: nil).height)
    }
    
    func height(max width: CGFloat, fontSize: CGFloat) -> CGFloat {
        let attrib: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
        let size = CGSize(width: width, height: CGFloat(Double.greatestFiniteMagnitude))
        
        return ceil((self as NSString).boundingRect(with: size,
                                                    options: .usesLineFragmentOrigin,
                                                    attributes:attrib, context: nil).height)
    }
    
    func width(_ height : CGFloat, font : UIFont) -> CGFloat {
        let attrib: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: font]
        let size = CGSize(width: CGFloat(Double.greatestFiniteMagnitude), height: height)
        return ceil((self as NSString).boundingRect(with: size,
                                                    options: .usesLineFragmentOrigin,
                                                    attributes:attrib, context: nil).width)
    }
    
    func width(_ height : CGFloat, fontSize : CGFloat) -> CGFloat {
        let attrib: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
        let size = CGSize(width: CGFloat(Double.greatestFiniteMagnitude), height: height)
        return ceil((self as NSString).boundingRect(with: size,
                                                    options: .usesLineFragmentOrigin,
                                                    attributes:attrib, context: nil).width)
    }
    
}

// MARK: - 时间官
extension String {
    /// 格式字符串转时间
    func toDate(_ type : Date.FormatType = .day) -> Date? {
        switch type {
        case .day:
            return Date.dayDate.date(from: self)
        case .second:
            return Date.secondDate.date(from: self)
        }
        
    }
    
    /// 时间格式字符串间隔当前时间 结果为分钟
    func intervalCurrent() -> Int {
        let current = Date()
        guard let start = self.toDate(.second) else { return 0 }
        let result = current.timeIntervalSince(start) / 60
        return Int(result)
    }
    
    /// 转时间字符串，只能时间戳使用(毫秒)
    func toDateString() -> String {
        guard let interval = TimeInterval(self) else { return "" }
        let date = Date(timeIntervalSince1970: interval * 0.001)
        return Date.secondDate.string(from: date)
    }
    
}





extension NSMutableAttributedString {
    
    /// 快速创建方法
    static func create(with attributeds : [NSAttributedString]) -> NSMutableAttributedString {
        let text = NSMutableAttributedString()
        
        attributeds.forEach { text.append($0) }
        
        return text
    }
    
}











