//
//  UserDefaults+RHExtension.swift
//  JYFW
//
//  Created by 荣恒 on 2019/1/4.
//  Copyright © 2019 荣恒. All rights reserved.
//

import Foundation


extension UserDefaults {
    
    /// 保存自定义对象 类型限制 Codable
    func setObject<T>(value : T, forKey key : String) where T : Codable  {
        let data = try? JSONEncoder().encode(value)
        set(data, forKey: key)
        synchronize()
    }
    
    /// 获取自定义对象
    func getObject<T>(forKey key : String) -> T? where T : Codable {
        guard let data = object(forKey: key) as? Data
            else { return nil }
        
        let value = try? JSONDecoder().decode(T.self, from: data)
        return value
    }
    
}
