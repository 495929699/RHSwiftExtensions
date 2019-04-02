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


public extension Reactive where Base: MoyaProviderType {
     /// Moya加缓存的方法
    func requestResponse(_ token: NetworkTarget) -> NetworkObservable<Response> {
        var result = request(token)
        switch token.cache {
        case .none:  break
        case .cacheResponse:
            if let response = try? RHCache.shared.response(for: token) {
               var result = result.startWith(response)
            }
            
        case .cacheTask:
            result = result.do(onError: { _ in
                RHCache.shared.cachedObject(<#T##cachedObject: Decodable & Encodable##Decodable & Encodable#>, for: <#T##String#>)
            })
            
            
        case .cacheResponseTask:
        }
        
        return result
    }
    
}

public struct NetworkKey {
    public static let code = "code"
    public static let message = "msg"
    public static let success = 200
    public static let data = "data"
}



public extension Reactive where Base : MoyaProviderType {
    
    func request(_ token : NetworkTarget) -> Observable<Response> {
        return Observable.create({ [weak base] observer in
            let cancellableToken = base?.request(token as! Base.Target, callbackQueue: nil, progress: nil, completion: { result in
                switch result {
                case let .success(response):
                    observer.onNext(response)
                case let .failure(error):
                    observer.onError(error)
                }
            })
            
            return Disposables.create {
                cancellableToken?.cancel()
            }
        })
    }
    
}

/// 网路结果类型
public typealias NetworkResult<T> = Swift.Result<T,NetworkError>
/// 网路结果序列
public typealias NetworkObservable<T> = Observable<NetworkResult<T>>

public typealias NetworkVoid = Swift.Result<Void,NetworkError>
public typealias NetworkVoidObservable = Observable<NetworkVoid>

public extension ObservableType where E == Response {
    
    func mapResponse<T : Codable>(dataKey : String = NetworkKey.data,
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
                return .just(NetworkResult.failure(NetworkError.error(value: error)))
            }
            
            return .just(.success(data))
        })
    }
    
    func mapResult(codeKey : String = NetworkKey.code,
                   messageKey : String = NetworkKey.message,
                   successCode : Int = NetworkKey.success)
        -> NetworkVoidObservable {
            return flatMap({ response -> NetworkVoidObservable in
                guard let code = try? response.map(Int.self, atKeyPath: codeKey),
                    let message = try? response.map(String.self, atKeyPath: messageKey) else {
                        let error = String(data: response.data, encoding: .utf8) ?? ""
                        return .just(.failure(.error(value: error)))
                }
                guard code == 200 else {
                    return .just(.failure(.service(code: code, message: message)))
                }
                
                return .just(.success(()))
            })
    }
    
}

// MARK: - 结果转换
private extension Reactive where Base: MoyaProviderType {
    
    
    /// 预处理响应结果
    private func handleReponse(_ response : Response, codeKey : String, messageKey : String) {
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
                let info = ["code" : code]
                NotificationCenter.default.post(name: .signOut, object: nil, userInfo: info)
                log("Token失效")
                
            default: break
            }
            
        } else {
            log("请求结果：\(response)")
            log("请求结果详情：\(String(data: response.data, encoding: .utf8) ?? "")")
        }
        
        log("=====================================================================")
    }
    
}


public extension Notification.Name {
    
    /// 服务器401通知
    static let NetworkService_401 = Notification.Name("network_service_401")
    
}
