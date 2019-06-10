//
//  UIButton+RHExtension.swift
//  JYFW
//
//  Created by 荣恒 on 2019/1/4.
//  Copyright © 2019 荣恒. All rights reserved.
//

import UIKit

public extension UIButton {
    
    /// UIButton 快捷创建方法
    convenience init(
        title : String? = nil,
        titleState : [UIControl.State] = [.normal,.highlighted],
        titleColor : UIColor? = nil,
        titleColorState : [UIControl.State] = [.normal,.highlighted],
        selectedTitle : String? = nil,
        selectedTitleColor : UIColor? = nil,
        fontSize : CGFloat? = nil,
        titleEdge : UIEdgeInsets? = nil,
        image : UIImage? = nil,
        imageState : [UIControl.State] = [.normal,.highlighted],
        selectedImage : UIImage? = nil,
        imageEdge : UIEdgeInsets? = nil,
        backgroundColor : UIColor? = nil,
        target : Any? = nil, action : Selector? = nil, event : UIControl.Event? = nil) {
        
        self.init(frame: CGRect.zero)
        if let title = title {
            titleState.forEach { setTitle(title, for: $0) }
        }
        if let titleColor = titleColor {
            titleColorState.forEach { setTitleColor(titleColor, for: $0) }
        }
        imageState.forEach { setImage(image, for: $0) }
        if let titleEdge = titleEdge {
            self.titleEdgeInsets = titleEdge
        }
        if let selectedTitle = selectedTitle {
            setTitle(selectedTitle, for: .selected)
        }
        if let selectedTitleColor = selectedTitleColor {
            setTitleColor(selectedTitleColor, for: .selected)
        }
        if let fontSize = fontSize {
            titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        }
        if let imageEdge = imageEdge {
            self.imageEdgeInsets = imageEdge
        }
        if let selectedImage = selectedImage {
            setImage(selectedImage, for: .selected)
        }
        self.backgroundColor = backgroundColor
        
        if let target = target, let action = action, let event = event {
            addTarget(target, action: action, for: event)
        }
        
    }
    
    /// 快捷初始化，图片相关
    convenience init(image : UIImage?, selectedImage : UIImage?) {
        self.init(frame: CGRect.zero)
        self.setImage(image, for: UIControl.State.normal)
        self.setImage(selectedImage, for: UIControl.State.selected)
    }
    
    
}

