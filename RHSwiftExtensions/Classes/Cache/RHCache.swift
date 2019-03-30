//
//  RHCache.swift
//  RHMoyaCache
//
//  Created by 荣恒 on 2018/9/28.
//  Copyright © 2018 荣恒. All rights reserved.
//

/**
import Foundation
import Cache
import Moya

//MARK : - 缓存管理类
public class RHCache {
    
    static let shared = RHCache()
    
    private init() {}
}

//MARK : - 对象缓存
public extension RHCache {
    
    func cachedObject<C: Codable>(_ type: C.Type, for key: String) throws -> C {
        return try Storage<C>().object(forKey: key)
    }
    
    func storeCachedObject<C: Codable>(_ cachedObject: C, for key: String) throws {
        try Storage<C>().setObject(cachedObject, forKey: key)
    }
    
    func removeCachedObject<C: Codable>(_ type: C.Type, for key: String) throws {
        try Storage<C>().removeObject(forKey: key)
    }
    
    private func removeAllCachedObjects() throws {
        try Storage<String>().removeAll()
    }
    
}

public extension Storage where T: Codable {
    
    convenience init() throws {
        try self.init(diskConfig: DiskConfig(name: "com.pircate.github.cache.object"),
                      memoryConfig: MemoryConfig(),
                      transformer: TransformerFactory.forCodable(ofType: T.self))
    }
}


*/
