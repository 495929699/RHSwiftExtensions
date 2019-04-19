//
//  BindType.swift
//  JiangRoom
//
//  Created by 荣恒 on 2019/4/10.
//  Copyright © 2019 荣恒. All rights reserved.
//

import Foundation


/// 绑定协议
public protocol BindType where Self : ViewType {
    
    /// 绑定ViewModel
    func bindViewModel()
    
}


