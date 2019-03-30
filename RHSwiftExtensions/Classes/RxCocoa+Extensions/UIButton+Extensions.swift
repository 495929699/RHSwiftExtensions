//
//  UIButton+Extensions.swift
//  RHSwiftExtensions
//
//  Created by 荣恒 on 2019/3/29.
//  Copyright © 2019 荣恒. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


// MARK: - UIButton
public extension Reactive where Base : UIButton {
    
    /// 背景颜色
    var backgroupColor : Binder<UIColor?> {
        return Binder.init(self.base, binding: { (button, color) in
            button.backgroundColor = color
        })
    }
    
    /// 背景图片
    var backgroundImage : Binder<UIImage?> {
        return Binder.init(self.base, binding: { (button, image) in
            button.setBackgroundImage(image, for: .normal)
        })
    }
    
}


public extension Reactive where Base : UIButton {
    
    /// 点击后的Selected
    var tapSelected : ControlProperty<Bool> {
        let source = controlEvent(.touchUpInside).map { self.base.isSelected }
        let bindingObserver = Binder<Bool>(base) { (control, value) in
            if control.isSelected != value {
                control.isSelected = value
            }
        }
        
        return ControlProperty(values: source, valueSink: bindingObserver)
    }
    
}
