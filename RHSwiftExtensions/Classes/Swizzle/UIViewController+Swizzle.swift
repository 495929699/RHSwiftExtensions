//
//  UIViewController+Swizzle.swift
//  RHSwiftExtensions
//
//  Created by 荣恒 on 2019/4/23.
//

import UIKit

private func swizzle(_ vc: UIViewController.Type) {
    
    [
        (#selector(vc.viewDidLoad), #selector(vc.ksr_viewDidLoad)),
        (#selector(vc.viewWillAppear(_:)), #selector(vc.ksr_viewWillAppear(_:)))
    ]
        .forEach { original, swizzled in
            
            guard let originalMethod = class_getInstanceMethod(vc, original),
                let swizzledMethod = class_getInstanceMethod(vc, swizzled) else { return }
            
            let didAddViewDidLoadMethod = class_addMethod(vc,
                                                          original,
                                                          method_getImplementation(swizzledMethod),
                                                          method_getTypeEncoding(swizzledMethod))
            
            if didAddViewDidLoadMethod {
                class_replaceMethod(vc,
                                    swizzled,
                                    method_getImplementation(originalMethod),
                                    method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
    }
}

private var hasSwizzled = false

extension UIViewController {
    
    /// 交换方法
    final public class func doBadSwizzleStuff() {
        guard !hasSwizzled else { return }
        
        hasSwizzled = true
        swizzle(self)
    }
    
    @objc internal func ksr_viewDidLoad() {
        self.ksr_viewDidLoad()
        setupUI()
        setupEvent()
        
        self.bindViewModel()
    }
    
    @objc open func bindViewModel() {}
    
    @objc open func setupUI() {
        view.backgroundColor = UIColor.white
    }
    @objc open func setupEvent() {}
    @objc open func setupLayout() {}
    @objc open func setupNavigationBar() {}
    
    @objc internal func ksr_viewWillAppear(_ animated: Bool) {
        self.ksr_viewWillAppear(animated)
        
        setupLayout()
        setupNavigationBar()
    }
    
}
