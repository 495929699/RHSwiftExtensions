//
//  UIView+Extensions.swift
//  RHSwiftExtensions
//
//  Created by 荣恒 on 2019/4/9.
//

import UIKit


extension UIView {
    
    /// 普通设置圆角 layer.masksToBounds = true
    func corner(_ radius : CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    /// 特殊方式设置圆角，必须要等self的frame 出来后才有效果
    func corner(_ radius : CGFloat, _ corners : UIRectCorner) {
        let rounded = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = rounded.cgPath
        
        self.layer.mask = shape
    }
    
    /// 边框
    func border(_ color : UIColor, _ width : CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    /// 阴影
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - opacity: 影音透明度
    ///   - radius: 阴影半径
    ///   - offset: 阴影偏移
    func shadow(_ color : UIColor,
                _ opacity : Float = 1, _ radius : CGFloat = 0,
                _ offset : CGSize = CGSize.zero) {
        
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity //默认为0
    }
    
    /// 添加阴影图层，设置frame后有效
    func addShadow(color : UIColor, offset : CGSize,
                   shadowRadius : CGFloat = 0, shadowOpacity : Float = 1,
                   cornerRadius : CGFloat) {
        let shadowLayer = CALayer()
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowOffset = offset
        shadowLayer.shadowRadius = shadowRadius
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.frame = self.bounds
        
        let cornerLayer = CALayer()
        cornerLayer.cornerRadius = cornerRadius
        cornerLayer.masksToBounds = true
        cornerLayer.frame = self.bounds
        
        shadowLayer.addSublayer(cornerLayer)
        self.layer.addSublayer(shadowLayer)
    }
    
}

// MARK: - 三方库抽取的方法 https://github.com/dillidon/alerts-and-pickers
extension UIView {
    
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}

// MARK: - 扩展方法
extension UIView {
    
    func setupUI() {
        
    }
    
    func setupLayout() {
        
    }
    
}
