//
//  NetworkError.swift
//  JYFW
//
//  Created by 荣恒 on 2019/1/6.
//  Copyright © 2019 荣恒. All rights reserved.
//

import Foundation
import Moya

/// 分页返回结果n类型
public protocol PageList : Codable & Equatable {
    associatedtype E : Codable & Equatable
    var items : [E] { get }
    var total : Int { get }
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
