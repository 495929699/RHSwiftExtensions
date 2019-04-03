//
//  Types.swift
//  Alamofire
//
//  Created by 荣恒 on 2019/4/3.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

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

/// 磁盘名
enum DiskName : String {
    case object = "jiangroom.cache.data"
    case response = "jiangromm.cache.network.response"
}

public extension Notification.Name {
    
    /// 服务器401通知
    static let networkService_401 = Notification.Name("network_service_401")
    
}


/// 分页返回结果n类型
public protocol PageList : Codable & Equatable {
    associatedtype E : Codable & Equatable
    var items : [E] { get }
    var total : Int { get }
}

/// 分页加载状态
public enum PageLoadState : String {
    case startRefresh
    case endRefresh
    case startLoadMore
    case endLoadMore
    
    var isLoading : Bool {
        switch self {
        case .startRefresh, .startLoadMore:
            return true
        case .endRefresh, .endLoadMore:
            return false
        }
    }
}

/// 通用网络错误
public enum NetworkError : Error {
    /// 网络错误
    case network(value : Error)
    /// 服务器错误
    case service(code : Int, message : String)
    ///返回字段不是code,msg,data 格式
    case error(value : String)
}

/// 缓存类型
///
/// - none: 不缓存
/// - cacheResponse: 缓存成功结果
/// - cacheTask: 缓存失败任务
/// - cacheResponseTask: 缓存成功结果和失败任务
public enum NetworkCacheType : Int {
    case none
    case cacheResponse
    case cacheTask
    case cacheResponseTask
}


// MARK: - 扩展 TargetType 加入缓存属性
public extension TargetType {
    
    /// 缓存类型，默认没有缓存
    var cache : NetworkCacheType {
        return .none
    }
    
    /// 缓存Key
    var cachedKey: String {
        return "\(baseURL.absoluteString)\(path),\(method.rawValue),\(headers ?? [:]),\(task)"
    }
    
    var headers: [String : String]? { return nil }
    var sampleData: Data { return Data() }
    
}
