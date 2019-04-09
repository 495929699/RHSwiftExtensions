//
//  UIButton+RHExtension.swift
//  JYFW
//
//  Created by 荣恒 on 2019/1/4.
//  Copyright © 2019 荣恒. All rights reserved.
//

import UIKit
import Kingfisher

extension UIButton {
    
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


// MARK: - 网络图片下载
extension UIButton {
    
    /// 设置网络背景图片
    func kf_setBackgroundImage(_ imageString : String?,
                               _ placeholderImage : UIImage? = nil,
                               _ state : UIControl.State = .normal,
                               _ completion : ((UIImage) -> ())? = nil) {
        guard let imageUrl = imageString,
            let url = URL(string: imageUrl) else {
                self.setBackgroundImage(placeholderImage, for: state)
                return
        }
        
        self.kf.setBackgroundImage(with: url, for: state, placeholder: placeholderImage) { (image, _, _, _) in
            guard let image = image else { return }
            completion?(image)
        }
    }
    
    /// 设置网络背景图片
    @discardableResult
    func kf_setImage(_ imageString : String?,
                               _ placeholderImage : UIImage? = nil,
                               _ state : UIControl.State = .normal,
                               _ completion : ((UIImage) -> ())? = nil) -> RetrieveImageTask? {
        guard let imageUrl = imageString,
            let url = URL(string: imageUrl) else {
                self.setImage(placeholderImage, for: state)
                return nil
        }
        
        return self.kf.setImage(with: url, for: state, placeholder: placeholderImage) { (image, _, _, _) in
            guard let image = image else { return }
            completion?(image)
        }
    }
    
}
