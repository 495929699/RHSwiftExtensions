//
//  UIColor+Extension.swift
//  FNXP
//
//  Created by 荣恒 on 2017/8/30.
//  Copyright © 2017年 荣恒. All rights reserved.
//


import UIKit


public extension UIColor {
    
    convenience init(hex: Int32, alpha: CGFloat = 1.0) {
        // 16进制Int -> String
        let hexString = String(hex, radix: 16)
        
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        let hex = Int(formatted, radix: 16) ?? 0
        
        let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
        let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
        let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

//    /// 随机颜色
//    static var randomColor : UIColor {
//        let colors = ["202-216-217","181-214-188","219-198-200",
//                      "203-222-223","220-217-201","251-216-191",
//                      "238-232-197","191-213-215","247-161-169",
//                      "245-233-170","197-228-174","234-239-182"]
//        
//        let index  = (Int(arc4random() % UInt32(colors.count)) - 1) + 1
//        let color = colors[index]
//        let r = color.subString(0,3).toFloat() ?? 0
//        let g = color.subString(4,3).toFloat() ?? 0
//        let b = color.subString(8,3).toFloat() ?? 0
//        
//        return UIColor.init(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b))
//    }
}
