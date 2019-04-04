//
//  do.swift
//  RHSwiftExtensions
//
//  Created by 荣恒 on 2019/4/4.
//

import Foundation
import RxSwift


// MARK: - do 副作用
public extension ObservableType {
    
    func doNext(_ closure : @escaping (E) -> Void) -> Observable<E> {
        return self.do(onNext: { value in closure(value) })
    }
    
    /// 添加副作用（类型为Result<T>）
    func `do`<T>(success : ((T) -> Void)? = nil,
                 failure : ((Error) -> Void)? = nil) -> Observable<E>
        where Self.E == Result<T,Error> {
            return self.do(onNext: { (result) in
                switch result {
                case let .success(value): success?(value)
                case let .failure(error): failure?(error)
                }
            })
    }
    
}
