//
//  UIViewController+Extensions.swift
//  RHSwiftExtensions
//
//  Created by 荣恒 on 2019/3/29.
//  Copyright © 2019 荣恒. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

// MARK: - UIViewController
public extension Reactive where Base : UIViewController {
    
    // 生命周期相关
    var didLoad : Observable<Void> {
        return methodInvoked(#selector(Base.viewDidLoad)).mapVoid()
    }
    
    var willAppear : Observable<Void> {
        return methodInvoked(#selector(Base.viewWillAppear(_:))).mapVoid()
    }
    
    var didAppear : Observable<Void> {
        return methodInvoked(#selector(Base.viewDidAppear(_:))).mapVoid()
    }
    
    var willDisappear : Observable<Void> {
        return methodInvoked(#selector(Base.viewWillDisappear(_:))).mapVoid()
    }
    
    var didDisappear : Observable<Void> {
        return methodInvoked(#selector(Base.viewDidDisappear(_:))).mapVoid()
    }

}
