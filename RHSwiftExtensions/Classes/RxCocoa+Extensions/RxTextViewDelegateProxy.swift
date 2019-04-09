//
//  RxTextViewDelegateProxy.swift
//  Alamofire
//
//  Created by 荣恒 on 2019/4/9.
//

import RxSwift
import RxCocoa


public class RxTextViewDelegateProxy: DelegateProxy<UITextView, UITextViewDelegate>, DelegateProxyType, UITextViewDelegate {
    /// Typed parent object.
    public weak private(set) var textView: UITextView?
    
    public init(textView: ParentObject) {
        self.textView = textView
        super.init(parentObject: textView, delegateProxy: RxTextViewDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxTextViewDelegateProxy(textView: $0) }
    }
    
    public static func currentDelegate(for object: UITextView) -> UITextViewDelegate? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: UITextViewDelegate?, to object: UITextView) {
        object.delegate = delegate
    }
    
    /// - parameter textview: Parent object for delegate proxy.
    
    public typealias ShouldChangeText = (UITextView, NSRange, String) -> Bool
    
    public var shouldChangeText: ShouldChangeText = { _, _, _ in true }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return shouldChangeText(textView, range, text)
    }
}

