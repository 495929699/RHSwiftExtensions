//
//  Cache+Moya.swift
//  RHSwiftExtensions
//
//  Created by 荣恒 on 2019/3/29.
//  Copyright © 2019 荣恒. All rights reserved.
//


import Cache
import Moya


//MARK : - 网络数据缓存
public extension RHCache {
    
    /// 获取缓存数据
    func cachedResponse(for target: TargetType) throws -> Moya.Response {
        return try Storage<Moya.Response>().object(forKey: target.cachedKey)
    }
    
    /// 设置缓存数据
    func storeCachedResponse(_ cachedResponse: Moya.Response, for target: TargetType) throws {
        try Storage<Moya.Response>().setObject(cachedResponse, forKey: target.cachedKey)
    }
    
    /// 删除缓存数据
    func removeCachedResponse(for target: TargetType) throws {
        try Storage<Moya.Response>().removeObject(forKey: target.cachedKey)
    }
    
    /// 删除所有缓存数据
    private func removeAllCachedResponses() throws {
        try Storage<Moya.Response>().removeAll()
    }
    
}


public extension TargetType {

    var cachedKey: String {
        if let urlRequest = try? endpoint.urlRequest(),
            let data = urlRequest.httpBody,
            let parameters = String(data: data, encoding: .utf8) {
            return "\(method.rawValue):\(endpoint.url)?\(parameters)"
        }
        return "\(method.rawValue):\(endpoint.url)"
    }

    private var endpoint: Endpoint {
        return Endpoint(url: URL(target: self).absoluteString,
                        sampleResponseClosure: { .networkResponse(200, self.sampleData) },
                        method: method,
                        task: task,
                        httpHeaderFields: headers)
    }

}


public extension Storage where T == Moya.Response {
    
    convenience init() throws {
        try self.init(diskConfig: DiskConfig(name: "com.pircate.github.cache.response"),
                      memoryConfig: MemoryConfig(),
                      transformer: Transformer<T>(
                        toData: { $0.data },
                        fromData: { T(statusCode: 200, data: $0) }))
    }
}
