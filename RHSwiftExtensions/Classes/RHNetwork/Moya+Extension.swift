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
import WCDBSwift

public struct NetworkErrorRequest : TableCodable {
    public typealias CodingKeys = <#type#>
    
    var task : TargetType
}

// MARK: - Moya RXSwift网络请求方法扩展
public extension Reactive where Base: MoyaProviderType {
    
    /// Moya请求Response方法
    func requestResponse<T : TargetType>(_ token: T) -> Observable<Response> {
        
        return Observable.create({ [weak base] observer in
            
            // 先取缓存
            if token.cache == .cacheResponse,
                let response = try? RHCache.shared.response(for: token) {
                observer.onNext(response)
            }
            
            // 发请求
            let cancellableToken = base?.request(token as! Base.Target, callbackQueue: nil, progress: nil) { result in
                switch result {
                case let .success(response):
                    observer.onNext(response)
                    observer.onCompleted()
                    
                    // 缓存数据
                    if token.cache == .cacheResponse {
                        RHCache.shared.asyncCachedResponse(for: token)
                    }
        
                case let .failure(error):
                    observer.onError(error)
                    
                    // 缓存失败任务（如数据库，不是使用缓存）
                    if token.cache == .cacheRequest {
                        
                    }
                    
                }
            }
            
            return Disposables.create {
                cancellableToken?.cancel()
            }
        })
        
    }
    
    /// Moya请求Result方法 -> Observable<Result<R,NetworkError>>
    func requestResult<T : TargetType, R : Codable>(
        _ token: T,
        dataKey : String = NetworkKey.data,
        codeKey : String = NetworkKey.code,
        messageKey : String = NetworkKey.message,
        successCode : Int = NetworkKey.success) -> NetworkObservable<R> {
        return requestResponse(token)
            .mapResult(dataKey: dataKey, codeKey: codeKey,
                       messageKey: messageKey, successCode: successCode)
    }
    
    /// Moya请求Success方法 -> Observable<Result<Void,NetworkError>>
    func requestSuccess<T : TargetType>(
        _ token: T,
        codeKey : String = NetworkKey.code,
        messageKey : String = NetworkKey.message,
        successCode : Int = NetworkKey.success) -> NetworkObservable<Void> {
        return requestResponse(token)
            .mapSuccess(codeKey: codeKey, messageKey: messageKey, successCode: successCode)
    }
    
}


// MARK: - 对 Response 序列扩展，转成Result<T,Error>
extension ObservableType where E == Response {
    
    /// 将内容 map成 Result<T,NetworkError>
    func mapResult<T : Codable>(dataKey : String, codeKey : String,
                                messageKey : String, successCode : Int)
        -> NetworkObservable<T> {
            return debugNetwork()
                .flatMap({ response -> NetworkObservable<T> in
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
    
    /// 将内容 map成 Result<Void,NetworkError>
    func mapSuccess(codeKey : String, messageKey : String, successCode : Int)
        -> NetworkVoidObservable {
            return debugNetwork()
                .flatMap({ response -> NetworkVoidObservable in
                guard let code = try? response.map(Int.self, atKeyPath: codeKey),
                    let message = try? response.map(String.self, atKeyPath: messageKey) else {
                        let error = String(data: response.data, encoding: .utf8) ?? "没有错误信息"
                        return .just(.failure(.error(value: error)))
                }
                guard code == successCode else {
                    return .just(.failure(.service(code: code, message: message)))
                }
                
                return .just(.success(()))
            })
                .catchError({ .just(.failure(.network(value: $0))) })
    }
    
    /// 调试操作符，打印网路请求的响应
    func debugNetwork(codeKey : String = NetworkKey.code,
                      messageKey : String = NetworkKey.message) -> Observable<Response> {
        return self.do(onNext: { response in
            logDebug("================================请求结果==============================")
            if let request = response.request,
                let url = request.url,
                let httpMethod = request.httpMethod  {
                logDebug("URL : \(url)   \(httpMethod)")
                logDebug("请求头：\(request.allHTTPHeaderFields ?? [:])")
            }
            
            if let code = try? response.map(Int.self, atKeyPath: codeKey),
                let message = try? response.map(String.self, atKeyPath: messageKey) {
                logDebug("code :\(code) \t message : \(message) \t HttpCode : \(response.response?.statusCode ?? -1) ")
                logDebug("响应数据：\n \(String(data: response.data, encoding: .utf8) ?? "")")
                
                switch code {
                case 401:   // Token时效，发出退出登录通知
                    NotificationCenter.default.post(name: .networkService_401, object: nil)
                    logDebug("Token失效")
                    
                default: break
                }
                
            } else {
                logDebug("请求结果：\(response)")
                logDebug("请求结果详情：\(String(data: response.data, encoding: .utf8) ?? "")")
            }
            
            logDebug("=====================================================================")
        }, onError: { error in
            
        })
    }
    
}
