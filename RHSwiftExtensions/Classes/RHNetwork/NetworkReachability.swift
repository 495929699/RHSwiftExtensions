//
//  Network+Reachability.swift
//  Alamofire
//
//  Created by 荣恒 on 2019/4/19.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

public typealias NetworkReachabilityStatus = Alamofire.NetworkReachabilityManager.NetworkReachabilityStatus


public extension Notification.Name {
    /// 网路可达性改变通知
    public static let reachabilityChanged = Notification.Name("reachabilityChanged")
}

public let reachabilityChangedKey = "status"

/// 网路可用性服务
public struct NetworkReachabilityService {
    
    public static let shared = NetworkReachabilityService()
    
    private let reachability = NetworkReachabilityManager()
    
    /// 当前网路状态
    var currentStatus : NetworkReachabilityStatus {
        return reachability?.networkReachabilityStatus ?? .notReachable
    }
    
    /// 是否有网
    var isHasNetwork : Bool {
        return reachability?.isReachable ?? false
    }
    
    /// 默认开始网络监听
    private init() {
        reachability?.listener = networkStatusChange(_:)
        reachability?.startListening()
    }
    
    private func networkStatusChange(_ status : NetworkReachabilityStatus) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .reachabilityChanged, object: nil,
                                            userInfo: [reachabilityChangedKey : status])
        }
    }
    
    /// 停止监听网路状态
    func stop() {
        reachability?.stopListening()
    }
    
    
}



