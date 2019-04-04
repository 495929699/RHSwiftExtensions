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


public extension Reactive where Base: UIViewController {
    
    func push(_ viewController: @escaping @autoclosure () -> UIViewController,
              animated: Bool = true)
        -> Binder<Void>
    {
        return Binder(base) { this, _ in
            this.navigationController?.pushViewController(viewController(), animated: animated)
        }
    }
    
    func pop(animated: Bool = true) -> Binder<Void> {
        return Binder(base) { this, _ in
            this.navigationController?.popViewController(animated: animated)
        }
    }
    
    func popToRoot(animated: Bool = true) -> Binder<Void> {
        return Binder(base) { this, _ in
            this.navigationController?.popToRootViewController(animated: animated)
        }
    }
    
    func present(_ viewController: @escaping @autoclosure () -> UIViewController,
                 animated: Bool = true,
                 completion: (() -> Void)? = nil)
        -> Binder<Void>
    {
        return Binder(base) { this, _ in
            this.present(viewController(), animated: animated, completion: completion)
        }
    }
    
    func dismiss(animated: Bool = true) -> Binder<Void> {
        return Binder(base) { this, _ in
            this.dismiss(animated: animated, completion: nil)
        }
    }
}
