//
//  UIColor+Extension.swift
//  FNXP
//
//  Created by 荣恒 on 2017/8/30.
//  Copyright © 2017年 荣恒. All rights reserved.
//


import UIKit


public extension UIColor {
    
    /// 十六进制颜色
    convenience init(hex: Int32, alpha: CGFloat = 1) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let b = CGFloat((hex & 0xFF)) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

}
