//
//  Cache+Moya.swift
//  RHSwiftExtensions
//
//  Created by 荣恒 on 2019/3/29.
//  Copyright © 2019 荣恒. All rights reserved.
//


import Moya

//MARK : - 缓存网络成功的数据
public extension RHCache {
    
    /// 同步获取成功请求的数据
    func response(for target: TargetType) throws -> Response {
        return try Storage<Response>().object(forKey: target.cachedKey)
    }
    
    /// 异步获取成功请求的数据
    func response(for target: TargetType, completion : @escaping (CacheResult<Response>) -> Void) {
        do {
            try Storage<Response>().async.object(forKey: target.cachedKey, completion: completion)
        } catch {
            completion(CacheResult.error(CacheError.storageError))
        }
    }
    
    /// 同步缓存成功请求的数据
    func cachedResponse(_ cachedResponse: Response, for target: TargetType) throws {
        try Storage<Response>().setObject(cachedResponse, forKey: target.cachedKey)
    }
    
    /// 异步缓存成功请求的数据
    func cachedResponse(for target: String, completion : @escaping (CacheResult<Response>) -> Void) {
        do {
            try Storage<Response>().async.object(forKey: target, completion: completion)
        } catch {
            completion(CacheResult.error(CacheError.storageError))
        }
    }
    
    /// 删除缓存数据
    func removeCachedResponse(for target: TargetType) throws {
        try Storage<Response>().removeObject(forKey: target.cachedKey)
    }
    
    /// 删除所有缓存数据
    private func removeAllCachedResponses() throws {
        try Storage<Response>().removeAll()
    }
    
}


extension Storage where T == Response {
    
    convenience init() throws {
        /// 内存缓存 5分钟过期
        try self.init(diskConfig: DiskConfig(name: DiskName.response.rawValue),
                      memoryConfig: MemoryConfig(expiry: .seconds(60 * 5)),
                      transformer: TransformerFactory.forResponse())
    }
}


extension TransformerFactory {
    
    static func forResponse() -> Transformer<Response> {
        let toData: (Response) -> Data = { object in
            return object.data
        }
        
        let fromData: (Data) -> Response = { data in
            return Response.init(statusCode: 200, data: data)
        }
        
        return Transformer<Response>(toData: toData, fromData: fromData)
    }
    
}
