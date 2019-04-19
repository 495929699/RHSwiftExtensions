//
//  ViewType.swift
//  JiangRoom
//
//  Created by 荣恒 on 2019/4/10.
//  Copyright © 2019 荣恒. All rights reserved.
//

import UIKit

/// 通用视图协议
public protocol ViewType {
    /// 设置界面
    func setupUI()
    /// 设置布局
    func setupLayout()
    /// 设置事件
    func setupEvent()
    /// 设置导航栏
    func setupNavigationBar()
}

public extension ViewType {
    func setupUI() { }
    func setupLayout() { }
    func setupEvent() { }
    func setupNavigationBar() { }
}


extension UIView : ViewType {}
extension UIViewController : ViewType {}


public protocol ViewIdentifierType where Self : UIView {
    static var ID : String { get }
}
extension ViewIdentifierType {
    static var ID: String {
        return String(describing: self)
    }
}
