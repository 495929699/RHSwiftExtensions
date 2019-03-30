//
//  ObservableType+Extensions.swift
//  RHSwiftExtensions
//
//  Created by 荣恒 on 2019/3/29.
//  Copyright © 2019 荣恒. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


// MARK: - 过滤
public extension ObservableType {
    
    /// 过滤nil
    func filterNil<T>() -> Observable<T> where E == Optional<T> {
        return filter({ $0 != nil }).map({ $0! })
    }
    
}




// MARK: - Map
public extension ObservableType {
    
    func mapVoid() -> Observable<Void> {
        return map({ _ in () })
    }
    
    func mapValue<T>(_ value : T) -> Observable<T> {
        return map({ _ in value })
    }
    
    /// map 成功后的值（过滤失败），并处理 Failure事件
    func mapSuccess<T>(failure : ((Error) -> Void)? = nil) -> Observable<T> where Self.E == Result<T> {
        if let failure = failure {
            return self.do(onFailure: failure).map({ $0.value }).filterNil()
        } else {
            return self.map({ $0.value }).filterNil()
        }
    }
    
    /// 转换错误
    func mapError<T>(to error : Error) -> Observable<Result<T>> where Self.E == Result<T> {
        return map({ (result) in
            switch result {
            case .Success : return result
            case .Failure: return .Failure(error)
            }
        })
    }
    
}

extension ObservableType where E == Bool {
    
    /// 取反
    func negate() -> Observable<E> {
        return map({ !$0 })
    }
    
}


// MARK: - do 副作用
public extension ObservableType {
    
    func doNext(_ closure : @escaping (E) -> Void) -> Observable<E> {
        return self.do(onNext: { value in closure(value) })
    }
    
    /// 给 （值 和 错误）添加副作用
    func `do`(onNextOrError closure : @escaping () -> Void) -> Observable<E> {
        return self.do(onNext: { _ in closure() }, onError: { _ in closure() })
    }
    
    /// 添加副作用（类型为Result<T>）
    func `do`<T>(onSuccess : ((T) -> Void)? = nil,
                 onFailure : ((Error) -> Void)? = nil) -> Observable<Result<T>>
        where Self.E == Result<T> {
            return self.do(onNext: { (result) in
                switch result {
                case let .Success(value): onSuccess?(value)
                case let .Failure(error): onFailure?(error)
                }
            })
    }
    
}


// MARK: - 订阅
public extension ObservableType {
    
    /// 订阅值事件
    func subscribeNext(_ next : @escaping (Self.E) -> Void) -> Disposable {
        return subscribe(onNext: { (value) in
            next(value)
        })
    }
    
    /// 订阅 Result   序列类型为 Observable<Result<T>> 才能调用
    func subscribe<T>(onSuccess : @escaping (T) -> Void,
                      onFailure : @escaping (Error) -> Void) -> Disposable
        where Self.E == Result<T> {
            
            return subscribe(onNext: { (result) in
                switch result {
                case let .Success(value): onSuccess(value)
                case let .Failure(error): onFailure(error)
                }
            })
    }
    
}


// MARK: - 序列 Collection Map
extension ObservableType where E: Collection {
    
    /// 将序列中的数组map
    func mapMany<T>(_ transform: @escaping (Self.E.Element) -> T) -> Observable<[T]> {
        return self.map { collection -> [T] in
            collection.map(transform)
        }
    }
    
}


