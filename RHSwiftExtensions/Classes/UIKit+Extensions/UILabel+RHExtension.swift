//
//  UILabel+RHExtension.swift
//  SwiftBaseProject
//
//  Created by 荣恒 on 2017/10/12.
//  Copyright © 2017年 荣恒. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UILabel初始化扩展
public extension UILabel {
    
    /// Label通用快捷创建方法
    convenience init(fontSize:CGFloat,
                     textColor: UIColor,
                     bold : Bool = false,
                     textAlignment: NSTextAlignment? = nil,
                     numberOfLines : Int? = nil,
                     backgroundColor : UIColor? = nil,
                     text: String? = nil){
        self.init(frame:CGRect.zero)
        self.font = bold ? .boldSystemFont(ofSize: fontSize) : .systemFont(ofSize:fontSize)
        self.textColor = textColor
        if let textAlignment = textAlignment {
            self.textAlignment = textAlignment
        }
        if let numberOfLines = numberOfLines {
            self.numberOfLines = numberOfLines
        }
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        if let text = text {
            self.text = text
        }
    }
    
}
