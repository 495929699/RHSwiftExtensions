//
//  UIView+Swizzle.swift
//  RHSwiftExtensions
//
//  Created by 荣恒 on 2019/4/23.
//

import UIKit

private func swizzle(_ v: UIView.Type) {
    
    [
//        (#selector(v.traitCollectionDidChange(_:)), #selector(v.ksr_traitCollectionDidChange(_:))),
        (#selector(v.layoutSubviews), #selector(v.ksr_layoutSubviews))
//        (#selector(v.init(frame:)), #selector(v.ksr_init(frame:)))
    ]
            .forEach { original, swizzled in
            
            guard let originalMethod = class_getInstanceMethod(v, original),
                let swizzledMethod = class_getInstanceMethod(v, swizzled) else { return }
            
            let didAddViewDidLoadMethod = class_addMethod(v,
                                                          original,
                                                          method_getImplementation(swizzledMethod),
                                                          method_getTypeEncoding(swizzledMethod))
            
            if didAddViewDidLoadMethod {
                class_replaceMethod(v,
                                    swizzled,
                                    method_getImplementation(originalMethod),
                                    method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
}

private var hasSwizzled = false

extension UIView {
    
    final public class func doBadSwizzleStuff() {
        guard !hasSwizzled else { return }
        
        hasSwizzled = true
        swizzle(self)
    }

    @objc open func bindViewModel() {}
    
    @objc open func setupUI() {}
    @objc open func setupEvent() {}
    @objc open func setupLayout() {}
    
    @objc internal func ksr_traitCollectionDidChange(_ previousTraitCollection: UITraitCollection) {
        self.ksr_traitCollectionDidChange(previousTraitCollection)
    }
    
    @objc internal func ksr_layoutSubviews() {
        self.ksr_layoutSubviews()
        setupLayout()
    }
    
    @objc internal func ksr_init(frame: CGRect) {
        self.ksr_init(frame: frame)
        bindViewModel()
        
        setupUI()
        setupEvent()
    }
    
}
