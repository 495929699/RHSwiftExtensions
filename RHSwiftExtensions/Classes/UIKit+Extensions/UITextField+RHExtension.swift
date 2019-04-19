//
//  UITextField+RHExtension.swift
//  RHSwiftExtensions
//
//  Created by 荣恒 on 2019/4/19.
//

import UIKit


extension UITextField {
    
    convenience init(
        fontSize : CGFloat,
        bold : Bool = false,
        textColor : UIColor? = nil,
        placeholder : String? = nil,
        textAlignment : NSTextAlignment? = nil,
        keyboardType : UIKeyboardType? = nil,
        left : CGFloat? = nil,
        right : CGFloat? = nil,
        delegate : UITextFieldDelegate? = nil) {
        self.init(frame: CGRect.zero)
        
        if bold {
            self.font = UIFont.boldSystemFont(ofSize: fontSize)
        } else {
            self.font = UIFont.systemFont(ofSize: fontSize)
        }
        
        if let textColor = textColor {
            self.textColor = textColor
        }
        if let placeholder = placeholder {
            self.placeholder = placeholder
        }
        if let textAlignment = textAlignment {
            self.textAlignment = textAlignment
        }
        if let keyboardType = keyboardType {
            self.keyboardType = keyboardType
        }
        if let left = left {
            self.leftView = UIView.init(x: 0, y: 0, w: left, h: 0)
            self.leftViewMode = .always
        }
        if let right = right {
            self.rightView = UIView.init(x: 0, y: 0, w: right, h: 0)
            self.rightViewMode = .always
        }
        
        self.delegate = delegate
    }
    
}
