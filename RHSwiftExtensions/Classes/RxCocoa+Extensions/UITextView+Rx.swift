//
//  UITextView+Rx.swift
//  Alamofire
//
//  Created by 荣恒 on 2019/4/9.
//

import UIKit
import RxCocoa

public extension UITextView {
    
    var maxLength: Int {
        get { return 0 }
        set {
            RxTextViewDelegateProxy.proxy(for: self).shouldChangeText = { (textView, range, string) -> Bool in
                if string.isEmpty { return true }
                guard let text = textView.text else { return true }
                let length = text.count + string.count - range.length
                return length <= newValue
            }
        }
    }
}
