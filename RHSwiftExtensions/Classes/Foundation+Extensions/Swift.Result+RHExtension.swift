//
//  Swift.Result.swift
//  Tenants
//
//  Created by 荣恒 on 2019/7/3.
//  Copyright © 2019 Jiangroom. All rights reserved.
//

import Foundation

extension Swift.Result {
    /// 获取错误值
    public func getError() throws -> Failure {
        switch self {
        case .success: throw NSError()
        case let .failure(error): return error
        }
    }
}
