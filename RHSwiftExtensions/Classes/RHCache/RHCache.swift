//
//  RHCache.swift
//  RHMoyaCache
//
//  Created by 荣恒 on 2018/9/28.
//  Copyright © 2018 荣恒. All rights reserved.
//

import Foundation

//MARK : - 缓存管理类
public class RHCache {
    
    enum CacheError : Error {
        case storageError
    }
    
    static let shared = RHCache()
    
    private init() {}
}

//MARK : - 对象缓存
public extension RHCache {
    
    /// 同步获取缓存
    func object<C: Codable>(_ type: C.Type, for key: String) throws -> C {
        return try Storage<C>().object(forKey: key)
    }
    
    /// 异步获取缓存
    func object<C: Codable>(_ type: C.Type, for key: String, completion : @escaping (CacheResult<C>) -> Void) {
        do {
            try Storage<C>().async.object(forKey: key, completion: completion)
        } catch {
            completion(CacheResult.error(CacheError.storageError))
        }
    }
    
    /// 同步缓存数据
    func cachedObject<C: Codable>(_ cachedObject: C, for key: String) throws {
        try Storage<C>().setObject(cachedObject, forKey: key)
    }
    
    /// 异步缓存数据
    func cachedObject<C: Codable>(_ cachedObject: C, for key: String, completion : @escaping (CacheResult<C>) -> Void) {
        do {
            try Storage<C>().async.object(forKey: key, completion: completion)
        } catch {
            completion(CacheResult.error(CacheError.storageError))
        }
    }
    
    /// 删除指定缓存，同步
    func removeCachedObject<C: Codable>(_ type: C.Type, for key: String) throws {
        try Storage<C>().removeObject(forKey: key)
    }
    
}

fileprivate let dataDiskName = "jiangroom.cache.data"

extension Storage where T: Codable {

    convenience init() throws {
        try self.init(diskConfig: DiskConfig(name: dataDiskName),
                      memoryConfig: MemoryConfig(),
                      transformer: TransformerFactory.forCodable(ofType: T.self))
    }
}
