//
//  RxUIApplicationDelegateProxy.swift
//  RHSwiftExtensions
//
//  Created by 荣恒 on 2019/4/9.
//

import RxSwift
import RxCocoa
import UIKit

//UIApplicationDelegate 代理委托
public class RxApplicationDelegateProxy :
    DelegateProxy<UIApplication, UIApplicationDelegate>,
UIApplicationDelegate, DelegateProxyType {
    
    public weak private(set) var application: UIApplication?
    
    init(application: ParentObject) {
        self.application = application
        super.init(parentObject: application, delegateProxy: RxApplicationDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxApplicationDelegateProxy(application: $0) }
    }
    
    public static func currentDelegate(for object: UIApplication) -> UIApplicationDelegate? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: UIApplicationDelegate?,
                                          to object: UIApplication) {
        object.delegate = delegate
    }
    
    override open func setForwardToDelegate(_ forwardToDelegate: UIApplicationDelegate?,
                                            retainDelegate: Bool) {
        super.setForwardToDelegate(forwardToDelegate, retainDelegate: true)
    }
}
