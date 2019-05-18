//
//  UserDefaults+RHExtension.swift
//  JYFW
//
//  Created by 荣恒 on 2019/1/4.
//  Copyright © 2019 荣恒. All rights reserved.
//

import Foundation


public extension UserDefaults {
    
    /// 保存自定义对象 已同步。
    func setObject<T : Codable>(value : T, forKey key : String)  {
        let data = try? JSONEncoder().encode(value)
        set(data, forKey: key)
        synchronize()
    }
    
    /// 获取自定义对象
    func getObject<T : Codable>(forKey key : String) throws -> T {
        guard let data = object(forKey: key) as? Data
            else { throw NSError() }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
}
