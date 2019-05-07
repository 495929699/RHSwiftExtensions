//
//  UICollectionViewCell+Swizzle.swift
//  Alamofire
//
//  Created by 荣恒 on 2019/4/28.
//

import UIKit

private func swizzle(_ v: UICollectionViewCell.Type) {
    
    [
        (#selector(v.init(frame:)), #selector(v.ksr_collectionCell_init(frame:)))
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

extension UICollectionViewCell {
    
    final public class func cellDoBadSwizzleStuff() {
        guard !hasSwizzled else { return }
        
        hasSwizzled = true
        swizzle(self)
    }
    
    @objc open override func setupUI() {
        super.setupUI()
        self.backgroundColor = UIColor.white
    }
    
    @objc internal func ksr_collectionCell_init(frame: CGRect) -> UICollectionViewCell {
        let cell = self.ksr_collectionCell_init(frame: frame)
        
        setupUI()
        setupEvent()
        
        bindViewModel()
        
        return cell
    }
    
}
