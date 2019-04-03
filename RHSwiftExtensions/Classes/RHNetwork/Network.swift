//
//  Network.swift
//  JYFW
//
//  Created by 荣恒 on 2019/3/18.
//  Copyright © 2019 荣恒. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/// 通用网络请求方法
public func network<S,O,T>(start : S,
                    request selector : @escaping (S.E) throws -> O)
    -> (isLoading : Observable<Bool>,
    result : Observable<T>,
    error : Observable<NetworkError>)
    where S : ObservableType,
    O : ObservableType, O.E == Result<T,Error> {
        
        let isLoading = BehaviorRelay<Bool?>(value: nil)
        let error = BehaviorRelay<NetworkError?>(value: nil)
        let result = start
            .do(onNext: { _ in isLoading.accept(true) })
            .flatMapLatest(selector)
            .do(onNext: { _ in isLoading.accept(false) })
            .mapSuccess { error.accept($0 as? NetworkError) }
            .share(replay: 1)
        
        return (isLoading.asObservable().filterNil(), result, error.asObservable().filterNil())
}

/// 通用网络请求方法
///
/// - Parameters:
///   - start: 请求信号
///   - params: 参数
///   - selector: 请求方法
///   - error: 处理错误
/// - Returns: 返回活动加载 isLoading，结果 result
public func network<S,P,O,T>(start : S,
                      params : P,
                      request selector : @escaping (P.E) throws -> O)
    -> (isLoading : Observable<Bool>,
    result : Observable<T>,
    error : Observable<NetworkError>)
    where S : ObservableType,
    O : ObservableType, O.E == Result<T,Error>,
    P : ObservableConvertibleType {
        
        let isLoading = BehaviorRelay<Bool?>(value: nil)
        let error = BehaviorRelay<NetworkError?>(value: nil)
        let result = start
            .do(onNext: { _ in isLoading.accept(true) })
            .withLatestFrom(params)
            .flatMapLatest(selector)
            .do(onNext: { _ in isLoading.accept(false) })
            .mapSuccess { error.accept($0 as? NetworkError) }
            .share(replay: 1)
        
        return (isLoading.asObservable().filterNil(), result, error.asObservable().filterNil())
}


/// 分页网络请求通用方法
///
/// - Parameters:
///   - frist: 上拉信号
///   - next: 下拉序列
///   - params: 参数，不包含page
///   - selector: 请求方法，需要传page
///
/// - Returns: loadState 加载状态，result 组合后的数据， isMore：是否还有数据, disposables 内部绑定生命周期，可与外部调用者绑定
public func pageNetwork<S,N,P,O,L,T>(
    frist : S, next : N, params : P,
    request selector : @escaping (P.E, Int) throws -> O)
    -> (values : Observable<[T]>,
    loadState : Observable<PageLoadState>,
    error : Observable<NetworkError>,
    page : Observable<Int>,
    isMore : Observable<Bool>,
    disposables : [Disposable])
where S : ObservableType,
    N : ObservableType,
    P : ObservableConvertibleType,
    O : ObservableType, O.E == Result<L,Error>,
    L : PageList, L.E == T {
        let loadState = BehaviorRelay<PageLoadState?>(value: nil)
        let error = BehaviorRelay<NetworkError?>(value: nil)
        let page = BehaviorRelay<Int>(value: 1)
        let total = BehaviorRelay<Int>(value: 0)
        let isHasMore = BehaviorRelay<Bool>(value: false)
        let values = BehaviorRelay<[T]>(value: [])
        
        let fristResult = frist.do(onNext: { _ in
            loadState.accept(.startRefresh)
        })
            .withLatestFrom(params).map { ($0, 1) }
            .flatMapLatest(selector)
            .mapSuccess { error.accept($0 as? NetworkError) }
            .do(onNext: { value in
                page.accept(1)
                loadState.accept(.endRefresh)
            })
            .share(replay: 1)
        
        let nextResult = next.flatMap({ _ in isHasMore.asObservable() }).filter({ $0 })
            .do(onNext: { _ in loadState.accept(.startLoadMore) })
            .withLatestFrom(params).map { ($0, page.value + 1) }
            .flatMapLatest(selector)
            .mapSuccess { error.accept($0 as? NetworkError) }
            .do(onNext: { _ in
                page.accept(page.value + 1)
                loadState.accept(.endLoadMore)
            })
            .share(replay: 1)
        
         let disposable1 = Observable.combineLatest(
            total.asObservable(),
            values.map({ $0.count }).asObservable())
            .map { $0 - $1 > 0 }
            .bind(to: isHasMore)
        
        let disposable2 = Observable.merge(fristResult.map({ $0.total }),nextResult.map({ $0.total }))
            .bind(to: total)
        
        let disposable3 = Observable.merge(
            fristResult.map({ $0.items }),
            nextResult.map({ $0.items })
                .scan([], accumulator: {  [$0,$1].flatMap({ $0}) })
                .withLatestFrom(fristResult.map({ $0.items }),
                                resultSelector: { [$1,$0].flatMap({ $0 }) })
        )
            .bind(to: values)
        
        
        return (values.asObservable(),
                loadState.asObservable().filterNil(),
                error.asObservable().filterNil(),
                page.asObservable(),
                isHasMore.asObservable(),
                [disposable1,disposable2,disposable3])
}
