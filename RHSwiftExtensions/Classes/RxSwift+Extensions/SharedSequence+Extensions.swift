//
//  SharedSequence+Extensions.swift
//  RHSwiftExtensions
//
//  Created by 荣恒 on 2019/3/29.
//  Copyright © 2019 荣恒. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


public extension SharedSequence {
    /// 过滤nil
    func filterNil<T>() -> SharedSequence<S,T> where E == Optional<T> {
        return filter({ $0 != nil }).map({ $0! })
    }
}


public extension SharedSequence {
    
    func mapVoid() -> SharedSequence<S,Void> {
        return map({ _ in () })
    }
    
    func mapValue<T>(_ value : T) -> SharedSequence<S,T> {
        return map({ _ in value })
    }
    
}



public extension SharedSequence {
    
    
    
}


extension SharedSequence where E : Collection {
    
    /// 将序列中的数组map
    func mapMany<T>(_ transform: @escaping (SharedSequence.E.Element) -> T) -> SharedSequence<S,[T]> {
        return self.map { collection -> [T] in
            collection.map(transform)
        }
    }
    
}
