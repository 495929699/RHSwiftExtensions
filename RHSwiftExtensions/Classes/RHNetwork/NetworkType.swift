//
//  NetworkError.swift
//  JYFW
//
//  Created by 荣恒 on 2019/1/6.
//  Copyright © 2019 荣恒. All rights reserved.
//

import Foundation

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
    
    /// 错误描述，以区分正式环境
    var value : String {
        #if DEVELOPMENT
        switch self {
        case .network:
            return "网路链接错误，请检查网络连接"
        case .service:
            return "服务器错误，code 不等于 200"
        case .error:
            return "数据解析错误，data字段不存在或者其他字段类型不一致"
        }
        #else
        return "网络请求错误，请稍后再试！"
        #endif
    }
}

