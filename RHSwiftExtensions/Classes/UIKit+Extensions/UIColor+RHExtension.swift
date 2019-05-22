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
    
}
