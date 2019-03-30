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
     func cacheRequest(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<Response> {
     return Single.create { [weak base] single in
     // 查缓存
     if let cache = try? RHCache.shared.cachedResponse(for: token) {
     single(.success(cache))
     }
     
     let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: nil) { result in
     switch result {
     case let .success(response):
     single(.success(response))
     //成功后缓存数据
     try? RHCache.shared.storeCachedResponse(response, for: token)
     
     case let .failure(error): single(.error(error))
     }
     }
     
     return Disposables.create {
     cancellableToken?.cancel()
     }
     
     }
     }
    
}

// MARK: - Moya 请求方法扩展
public extension Reactive where Base: MoyaProviderType {

    /// 请求Data方法
    /// - Returns: 结果为 Result<T>
    func requestData<T : Codable>(_ token: Base.Target, callbackQueue: DispatchQueue? = nil,
                                  dataKey : String = "data",
                                  codeKey : String = "code",
                                  messageKey : String = "msg",
                                  successCode : Int = 200) -> Observable<Result<T>> {
        return request(token, callbackQueue: callbackQueue)
            .do(onSuccess: { self.handleReponse($0, codeKey: codeKey, messageKey: messageKey) },
                onError: handleError(with: ))
            .asObservable()
            .map({ (with : $0, codeKey : codeKey,
                    messageKey : messageKey, dataKey : dataKey,
                    successCode : successCode) })
            .flatMap(mapResponseToResult)
            .catchError({ .just(.Failure(NetworkError.network(value: $0))) })
    }
    
    /// 请求是否成功方法，根据 successCode 判断是否成功
    func requestResult(_ token: Base.Target, callbackQueue: DispatchQueue? = nil,
                       codeKey : String = "code",
                       successCode : Int = 200,
                       messageKey : String = "msg") -> Observable<Result<Void>> {
        return request(token, callbackQueue: callbackQueue)
            .do(onSuccess: { self.handleReponse($0, codeKey: codeKey, messageKey: messageKey) },
                onError: handleError(with: ))
            .asObservable()
            .map({ (with : $0, codeKey : codeKey,
                    messageKey : messageKey,
                    successCode : successCode) })
            .flatMap(mapResultVoid)
            .catchError({ .just(.Failure(NetworkError.network(value: $0))) })
    }
    
    /// 请求Data方法
    /// - Returns: 结果为 T
    func requestData<T : Codable>(_ token: Base.Target, callbackQueue: DispatchQueue? = nil,
                                  dataKey : String = "data",
                                  codeKey : String = "code",
                                  messageKey : String = "msg",
                                  successCode : Int = 200) -> Observable<T> {
        return request(token, callbackQueue: callbackQueue)
            .do(onSuccess: { self.handleReponse($0, codeKey: codeKey, messageKey: messageKey) },
                onError: handleError(with: ))
            .asObservable()
            .map({ (with : $0, codeKey : codeKey,
                    messageKey : messageKey, dataKey : dataKey,
                    successCode : successCode) })
            .flatMap(mapResponse)
    }
    
    /// 请求是否成功方法，根据 successCode 判断是否成功
    func requestResult(_ token: Base.Target,
                       callbackQueue: DispatchQueue? = nil,
                       codeKey : String = "code",
                       messageKey : String = "msg",
                       successCode : Int = 200) -> Observable<Void> {
        return request(token, callbackQueue: callbackQueue)
            .do(onSuccess: { self.handleReponse($0, codeKey: codeKey, messageKey: messageKey) }, onError: handleError(with: ))
            .asObservable()
            .map({ (with : $0, codeKey : codeKey,
                    messageKey : messageKey,
                    successCode : successCode) })
            .flatMap(mapResult)
    }
    
    
}

// MARK: - 结果转换
private extension Reactive where Base: MoyaProviderType {
    
    /// 转换 Response 为 Observable<T>
    private func mapResponse<T : Codable>(with response : Response,
                                          codeKey : String,
                                          messageKey : String,
                                          dataKey : String,
                                          successCode : Int) -> Observable<T> {
        guard let code = try? response.map(Int.self, atKeyPath: codeKey),
            let message = try? response.map(String.self, atKeyPath: messageKey) else {
                let error = String(data: response.data, encoding: .utf8) ?? ""
                return .error(NetworkError.error(value: error))
        }
        guard code == 200 else {
            return .error(NetworkError.service(code: code, message: message))
        }
        guard let data = try? response.map(T.self, atKeyPath: dataKey) else {
            let error = String(data: response.data, encoding: .utf8) ?? ""
            return .error(NetworkError.error(value: error))
        }
        
        return .just(data)
    }
    
    private func mapResponseToResult<T : Codable>(with response : Response,
                                                  codeKey : String,
                                                  messageKey : String,
                                                  dataKey : String,
                                                  successCode : Int) -> Observable<Result<T>> {
        guard let code = try? response.map(Int.self, atKeyPath: codeKey),
            let message = try? response.map(String.self, atKeyPath: messageKey) else {
                let error = String(data: response.data, encoding: .utf8) ?? ""
                return .just(.Failure(NetworkError.error(value: error)))
        }
        guard code == 200 else {
            return .just(.Failure(NetworkError.service(code: code, message: message)))
        }
        guard let data = try? response.map(T.self, atKeyPath: dataKey) else {
            let error = String(data: response.data, encoding: .utf8) ?? ""
            return .just(.Failure(NetworkError.error(value: error)))
        }
        
        return .just(.Success(data))
    }
    
    /// 转换 Response 为 Observable<Void>
    private func mapResult(with response : Response,
                           codeKey : String,
                           messageKey : String,
                           successCode : Int) -> Observable<Void> {
        guard let code = try? response.map(Int.self, atKeyPath: codeKey),
            let message = try? response.map(String.self, atKeyPath: messageKey) else {
                let error = String(data: response.data, encoding: .utf8) ?? ""
                return .error(NetworkError.error(value: error))
        }
        guard code == 200 else
        { return .error(NetworkError.service(code: code, message: message)) }
        
        return .just(())
    }
    
    private func mapResultVoid(with response : Response,
                               codeKey : String,
                               messageKey : String,
                               successCode : Int) -> Observable<Result<Void>> {
        guard let code = try? response.map(Int.self, atKeyPath: codeKey),
            let message = try? response.map(String.self, atKeyPath: messageKey) else {
                let error = String(data: response.data, encoding: .utf8) ?? ""
                return .just(.Failure(NetworkError.error(value: error)))
        }
        guard code == 200 else
        { return .just(.Failure(NetworkError.service(code: code, message: message))) }
        
        return .just(.Success(()))
    }
    
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
    
    private func handleError(with error : Error) {
        //        log("请求错误：\(error)")
    }
    
}


public extension Notification.Name {
    
    /// 服务器401通知
    static let signOut = Notification.Name("sign_out")
    
}
