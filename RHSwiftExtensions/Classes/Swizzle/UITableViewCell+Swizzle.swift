//
//  UITableViewCell+Swizzle.swift
//  Alamofire
//
//  Created by 荣恒 on 2019/4/26.
//

import UIKit

private func swizzle(_ v: UITableViewCell.Type) {
    
    [
        (#selector(v.init(style:reuseIdentifier:)), #selector(v.ksr_init(style:reuseIdentifier:)))
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

extension UITableViewCell {
    
    final public class func cellDoBadSwizzleStuff() {
        guard !hasSwizzled else { return }
        
        hasSwizzled = true
        swizzle(self)
    }
    
    @objc open override func setupUI() {
        super.setupUI()
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
    }
    
    @objc internal func ksr_init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) -> UITableViewCell {
        let cell = self.ksr_init(style: style, reuseIdentifier: restorationIdentifier)
        
        setupUI()
        setupEvent()
        
        bindViewModel()
        
        return cell
    }
    
}
