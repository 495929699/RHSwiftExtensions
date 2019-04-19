//
//  Result+Extensions.swift
//  Alamofire
//
//  Created by 荣恒 on 2019/4/18.
//

import Foundation

public extension Swift.Result {

    /// 是否成功
    var isSuccess : Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }

    var value : Success? {
        switch self {
        case let .success(v): return v
        case .failure: return nil
        }
    }
    
}
