//
//  ViewType.swift
//  JiangRoom
//
//  Created by 荣恒 on 2019/4/10.
//  Copyright © 2019 荣恒. All rights reserved.
//

import UIKit

public enum UIError : Error {
    case dequeue
}

public protocol ViewIdentifierType where Self : UIView { }
extension ViewIdentifierType {
    static var ID: String {
        return String(describing: self)
    }
}
extension UIView : ViewIdentifierType {}
