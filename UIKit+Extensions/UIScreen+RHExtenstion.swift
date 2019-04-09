//
//  UIScreen+RHExtenstion.swift
//  SwiftBaseProject
//
//  Created by 荣恒 on 2017/12/26.
//  Copyright © 2017年 荣恒. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 适配
extension UIScreen {
    
    static var frame : CGRect {
        return main.bounds
    }
    static var width : CGFloat {
        return main.bounds.width
    }
    static var height : CGFloat {
        return main.bounds.height
    }
    
    /// 顶部安全距离 这里的safe 与系统的安全区别不同
    static var safeTop : CGFloat {
        return isX() ? 44 : 20
    }
    
    /// 底部安全距离
    static var safeBottom : CGFloat {
        return isX() ? 34 : 0
    }
    
    /// 导航栏高度
    static var navigationHeight : CGFloat {
        return isX() ? 88 : 64
    }
    
    /// TabBar高度
    static var tabBarHeight : CGFloat {
        return isX() ? 83 : 49
    }
   
    /// 是否iPhone X系列
    static func isX() -> Bool {
        var iPhoneXSeries = false
        
        /// 是否为手机
        if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.phone {
            return iPhoneXSeries
        }
        
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.delegate?.window,
                let mainWindow = window,
                mainWindow.safeAreaInsets.bottom > 0.0 {
                iPhoneXSeries = true
            }
        }
        
        return iPhoneXSeries
    }
    
}




