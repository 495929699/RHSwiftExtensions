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
    /// 开始刷新
    case startRefresh
    /// 结束刷新
    case endRefresh
    /// 开始上拉加载
    case startLoadMore
    /// 结束上拉加载
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
    /// 返回字段不是code,msg,data 格式
    case error(value : String)
}

/// 缓存类型
public enum NetworkCacheType : Int {
    /// 不缓存
    case none
    /// 缓存成功结果
    case cacheResponse
    /// 缓存失败任务
    case cacheRequest
    
    /// 缓存错误请求的Key
    static var cacheRequestKey : String {
        return "RHCache.error.cacheRequest"
    }
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
    
    /// 对应的请求
    var request : URLRequest? {
        return try? MoyaProvider.defaultEndpointMapping(for: self).urlRequest()
    }
    
}

/// Target转换协议
public protocol TargetTransform where Self : TargetType {
    
    /// TargetType转换到String
    func toValue() -> String?
    
    /// 根据String生成TargetType
    init(value : String)
    
}


public extension Task {
    
    typealias Value = (Int,String?,ParameterEncoding?)
    
    var value : Value {
        switch self {
        case let .requestParameters(value):
            return (rawValue,toJSON(form: value.parameters), value.encoding)

        case let .requestData(data):
            return (rawValue, String(data: data, encoding: .utf8),nil)
            
        default: return (rawValue,nil,nil)
        }
    }
    
    /// 自定义Int值
    var rawValue : Int {
        switch self {
        case .requestPlain: return 0
        case .requestData: return 1
        case .requestJSONEncodable: return 2
        case .requestCustomJSONEncodable: return 3
        case .requestParameters: return 4
        case .requestCompositeData: return 5
        case .requestCompositeParameters: return 6
        case .uploadFile: return 7
        case .uploadMultipart: return 8
        case .uploadCompositeMultipart: return 9
        case .downloadDestination: return 10
        case .downloadParameters: return 11
        }
    }
    
    static func create(rawValue : Int, value : String, encoding : ParameterEncoding?) -> Task? {
        switch rawValue {
        case 4:
            guard let dictionary = toDictionary(form: value),
               let encoding = encoding else { return nil }
            return Task.requestParameters(parameters: dictionary, encoding: encoding)
        case 1:
            guard let data = value.data(using: .utf8) else { return nil }
            return Task.requestData(data)
            
        default: return nil
        }
    }
    
}


func toJSON(form value : Any) -> String? {
    guard JSONSerialization.isValidJSONObject(value)
        else { return nil }
    guard let data = try? JSONSerialization.data(withJSONObject: value, options: [])
        else { return nil }
    let JSONString = String(data:data ,encoding: .utf8)
    
    return JSONString
}

func toDictionary(form json : String) -> [String : Any]? {
    guard let jsonData = json.data(using: .utf8),
        let object = try? JSONSerialization.jsonObject(with: jsonData, options: []),
        let result = object as? [String : Any]
        else { return nil }
    return result
}
