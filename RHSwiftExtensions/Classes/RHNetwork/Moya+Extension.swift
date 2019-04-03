//
//  Moya+Extension.swift
//  RHMoyaCache
//
//  Created by 荣恒 on 2018/9/28.
//  Copyright © 2018 荣恒. All rights reserved.
//

import Foundation
import RxSwift
import Moya

// MARK: - 类型定义
public typealias TargetType = Moya.TargetType
public typealias Response = Moya.Response
/// 网路结果类型
public typealias NetworkResult<T> = Swift.Result<T,NetworkError>
/// 网路结果序列
public typealias NetworkObservable<T> = Observable<NetworkResult<T>>

public typealias NetworkVoid = Swift.Result<Void,NetworkError>
public typealias NetworkVoidObservable = Observable<NetworkVoid>

/// 网络请求Key值
public struct NetworkKey {
    public static let code = "code"
    public static let message = "msg"
    public static let success = 200
    public static let data = "data"
}


// MARK: - Moya RXSwift网络请求方法扩展
public extension Reactive where Base: MoyaProviderType {
    
    func requestResponse<T>(_ token: T) -> Observable<Response> where T : TargetType & Codable {
        
        return Observable.create({ [weak base] observer in
            
            if [.cacheResponse, .cacheResponseTask].contains(token.cache) {
                //先取缓存
                RHCache.shared.response(for: token) { value in
                    if let response = value.value {
                        observer.onNext(response)
                    }
                }
            }
            
            // 发请求
            let cancellableToken = base?.request(token as! Base.Target, callbackQueue: nil, progress: nil) { result in
                switch result {
                case let .success(response):
                    observer.onNext(response)
                    observer.onCompleted()
                    
                    // 缓存数据
                    if [.cacheResponse, .cacheResponseTask].contains(token.cache) {
                        try? RHCache.shared.cachedResponse(response, for: token as! Base.Target)
                    }
                    
                case let .failure(error):
                    observer.onError(error)
                    
                    // 缓存失败任务
                    if [.cacheTask, .cacheResponseTask].contains(token.cache) {
                        try? RHCache.shared.cachedObject(token, for: token.cachedKey)
                    }
                    
                }
            }
            
            return Disposables.create {
                cancellableToken?.cancel()
            }
        })
        
    }
    
    /// Moya请求方法
    func requestResponse<T>(_ token: T) -> Single<Response> where T : TargetType & Codable {
        return Single.create(subscribe: { [weak base] single in
            
            if [.cacheResponse, .cacheResponseTask].contains(token.cache) {
                //先取缓存
                RHCache.shared.response(for: token) { value in
                    if let response = value.value {
                        single(.success(response))
                    }
                }
            }
            
            // 发请求
            let cancellableToken = base?.request(token as! Base.Target, callbackQueue: nil, progress: nil) { result in
                switch result {
                case let .success(response):
                    single(.success(response))
                    
                    // 缓存数据
                    if [.cacheResponse, .cacheResponseTask].contains(token.cache) {
                        try? RHCache.shared.cachedResponse(response, for: token as! Base.Target)
                    }
                    
                case let .failure(error):
                    single(.error(error))
                    
                    // 缓存失败任务
                    if [.cacheTask, .cacheResponseTask].contains(token.cache) {
                        try? RHCache.shared.cachedObject(token, for: token.cachedKey)
                    }
                   
                }
            }
            
            return Disposables.create {
                cancellableToken?.cancel()
            }
        })
    }
    
}


public extension ObservableType where E == Response {
    
    func mapResult<T : Codable>(dataKey : String = NetworkKey.data,
                                  codeKey : String = NetworkKey.code,
                                  messageKey : String = NetworkKey.message,
                                  successCode : Int = NetworkKey.success)
        -> NetworkObservable<T> {
            return flatMap({ response -> NetworkObservable<T> in
                guard let code = try? response.map(Int.self, atKeyPath: codeKey),
                    let message = try? response.map(String.self, atKeyPath: messageKey) else {
                        let error = String(data: response.data, encoding: .utf8) ?? "没有错误信息"
                        return .just(.failure(.error(value: error)))
                }
                guard code == successCode else {
                    return .just(.failure(.service(code: code, message: message)))
                }
                guard let data = try? response.map(T.self, atKeyPath: dataKey) else {
                    let error = String(data: response.data, encoding: .utf8) ?? "没有错误信息"
                    return .just(NetworkResult.failure(.error(value: error)))
                }
                
                return .just(.success(data))
            })
                .catchError({ .just(.failure(.network(value: $0))) })
    }
    
    func mapResult(codeKey : String = NetworkKey.code,
                   messageKey : String = NetworkKey.message,
                   successCode : Int = NetworkKey.success)
        -> NetworkVoidObservable {
            return flatMap({ response -> NetworkVoidObservable in
                guard let code = try? response.map(Int.self, atKeyPath: codeKey),
                    let message = try? response.map(String.self, atKeyPath: messageKey) else {
                        let error = String(data: response.data, encoding: .utf8) ?? "没有错误信息"
                        return .just(.failure(.error(value: error)))
                }
                guard code == 200 else {
                    return .just(.failure(.service(code: code, message: message)))
                }
                
                return .just(.success(()))
            })
                .catchError({ .just(.failure(.network(value: $0))) })
    }
    
    /// 调试操作符，打印网路请求的响应
    internal func debugNetwork(codeKey : String = NetworkKey.code,
                      messageKey : String = NetworkKey.message) -> Observable<Response> {
        return self.do(onNext: { response in
            log("================================请求结果==============================")
            if let request = response.request,
                let url = request.url,
                let httpMethod = request.httpMethod  {
                log("URL : \(url)   \(httpMethod)")
                log("请求头：\(request.allHTTPHeaderFields ?? [:])")
            }
            
            if let code = try? response.map(Int.self, atKeyPath: codeKey),
                let message = try? response.map(String.self, atKeyPath: messageKey) {
                log("code :\(code) \t message : \(message) \t HttpCode : \(response.response?.statusCode ?? -1) ")
                log("响应数据：\n \(String(data: response.data, encoding: .utf8) ?? "")")
                
                switch code {
                case 401:   // Token时效，发出退出登录通知
                    NotificationCenter.default.post(name: .networkService_401, object: nil)
                    log("Token失效")
                    
                default: break
                }
                
            } else {
                log("请求结果：\(response)")
                log("请求结果详情：\(String(data: response.data, encoding: .utf8) ?? "")")
            }
            
            log("=====================================================================")
        }, onError: { error in
            
        })
    }
    
}


// MARK: - Single<Response> 扩展
public extension PrimitiveSequence where Trait == SingleTrait ,Element == Response {
    
    /// 转换成服务器返回的结果
    func mapResult<T : Codable>(dataKey : String = NetworkKey.data,
                                codeKey : String = NetworkKey.code,
                                messageKey : String = NetworkKey.message,
                                successCode : Int = NetworkKey.success)
        -> Single<T> {
            return flatMap({ response -> Single<T> in
                guard let code = try? response.map(Int.self, atKeyPath: codeKey),
                    let message = try? response.map(String.self, atKeyPath: messageKey) else {
                        let error = String(data: response.data, encoding: .utf8) ?? "没有错误信息"
                        return .error(NetworkError.error(value: error))
                }
                guard code == successCode else {
                    return .error(NetworkError.service(code: code, message: message))
                }
                guard let data = try? response.map(T.self, atKeyPath: dataKey) else {
                    let error = String(data: response.data, encoding: .utf8) ?? "没有错误信息"
                    return .error(NetworkError.error(value: error))
                }
                
                return .just(data)
            })
    }
    
    /// 转成成是否成功的结果
    func mapResult(codeKey : String = NetworkKey.code,
                   messageKey : String = NetworkKey.message,
                   successCode : Int = NetworkKey.success) -> Single<Void> {
        
        return flatMap({ response -> Single<Void> in
            guard let code = try? response.map(Int.self, atKeyPath: codeKey),
                let message = try? response.map(String.self, atKeyPath: messageKey) else {
                    let error = String(data: response.data, encoding: .utf8) ?? ""
                    return .error(NetworkError.error(value: error))
            }
            guard code == successCode else {
                return .error(NetworkError.service(code: code, message: message))
            }
            
            return .just(())
        })
        
    }
    
    /// 调试操作符，打印网路请求的响应
    func debugNetwork(codeKey : String = NetworkKey.code,
                      messageKey : String = NetworkKey.message) -> Single<Response> {
        
        return self.do(onSuccess: { response in
            
            log("================================请求结果==============================")
            if let request = response.request,
                let url = request.url,
                let httpMethod = request.httpMethod  {
                log("URL : \(url)   \(httpMethod)")
                log("请求头：\(request.allHTTPHeaderFields ?? [:])")
            }
            
            if let code = try? response.map(Int.self, atKeyPath: codeKey),
                let message = try? response.map(String.self, atKeyPath: messageKey) {
                log("code :\(code) \t message : \(message) \t HttpCode : \(response.response?.statusCode ?? -1) ")
                log("响应数据：\n \(String(data: response.data, encoding: .utf8) ?? "")")
                
                switch code {
                case 401:   // Token时效，发出退出登录通知
                    NotificationCenter.default.post(name: .networkService_401, object: nil)
                    log("Token失效")
                    
                default: break
                }
                
            } else {
                log("请求结果：\(response)")
                log("请求结果详情：\(String(data: response.data, encoding: .utf8) ?? "")")
            }
            
            log("=====================================================================")
            
        }, onError: { error in
            
        })
    }
    
}


public extension Notification.Name {

    /// 服务器401通知
    static let networkService_401 = Notification.Name("network_service_401")

}
