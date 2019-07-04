//
//  Optional.swift
//  JYFW
//
//  Created by 荣恒 on 2019/6/11.
//  Copyright © 2019 荣恒. All rights reserved.
//

import Foundation

/// 默认值协议，有了默认值，可以直接解包
public protocol DefaultValueType {
    static var defaultValue : Self { get }
}

extension Optional where Wrapped : DefaultValueType {
    /// 解包
   public func unwrap() -> Wrapped {
        return self ?? Wrapped.defaultValue
    }
}

extension String : DefaultValueType {
    public static var defaultValue: String {
        return ""
    }
}

extension Int : DefaultValueType {
    public static var defaultValue: Int {
        return 0
    }
}

extension CGFloat : DefaultValueType {
    public static var defaultValue: CGFloat {
        return 0
    }
}

extension Float : DefaultValueType {
    public static var defaultValue: Float {
        return 0
    }
}

extension Array : DefaultValueType {
    public static var defaultValue: Array<Element> {
        return []
    }
}

extension Dictionary : DefaultValueType {
    public static var defaultValue: Dictionary<Key, Value> {
        return [:]
    }
}
