//
//  NetworkError.swift
//  JYFW
//
//  Created by 荣恒 on 2019/1/6.
//  Copyright © 2019 荣恒. All rights reserved.
//

import Foundation
import Moya

//MARK : - 结果枚举
public enum Result<Value> {
    typealias E = Value
    case Success(Value)
    case Failure(Error)
    
    var isSuccess : Bool {
        switch self {
        case .Success:
            return true
        case .Failure:
            return false
        }
    }
    
    var value : Value? {
        switch self {
        case let .Success(value):
            return value
        case .Failure:
            return nil
        }
    }
    
}

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
public enum NetworkCacheType {
    case none
    case cacheResponse
    case cacheTask
    case cacheResponseTask
}

//extension Moya.TargetType {
//    var cache : NetworkCacheType { get }
//    
//    var headers: [String : String]? { return nil }
//    var sampleData: Data { return Data() }
//}

/// 网络接口
public protocol NetworkTarget : Moya.TargetType {
    
    var cache : NetworkCacheType { get }
    
}

public extension NetworkTarget {
    var headers: [String : String]? { return nil }
    var sampleData: Data { return Data() }
}
