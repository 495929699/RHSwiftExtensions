//
//  Types.swift
//  Alamofire
//
//  Created by 荣恒 on 2019/4/3.
//

import Foundation

//public extension Task {
//
//    typealias Value = (Int,String?,ParameterEncoding?)
//
//    var value : Value {
//        switch self {
//        case let .requestParameters(value):
//            return (rawValue,toJSON(form: value.parameters), value.encoding)
//
//        case let .requestData(data):
//            return (rawValue, String(data: data, encoding: .utf8),nil)
//
//        default: return (rawValue,nil,nil)
//        }
//    }
//
//    /// 自定义Int值
//    var rawValue : Int {
//        switch self {
//        case .requestPlain: return 0
//        case .requestData: return 1
//        case .requestJSONEncodable: return 2
//        case .requestCustomJSONEncodable: return 3
//        case .requestParameters: return 4
//        case .requestCompositeData: return 5
//        case .requestCompositeParameters: return 6
//        case .uploadFile: return 7
//        case .uploadMultipart: return 8
//        case .uploadCompositeMultipart: return 9
//        case .downloadDestination: return 10
//        case .downloadParameters: return 11
//        }
//    }
//
//    static func create(rawValue : Int, value : String, encoding : ParameterEncoding?) -> Task? {
//        switch rawValue {
//        case 4:
//            guard let dictionary = toDictionary(form: value),
//               let encoding = encoding else { return nil }
//            return Task.requestParameters(parameters: dictionary, encoding: encoding)
//        case 1:
//            guard let data = value.data(using: .utf8) else { return nil }
//            return Task.requestData(data)
//
//        default: return nil
//        }
//    }
//
//}


func toJSON(form value : Any) -> String? {
    guard JSONSerialization.isValidJSONObject(value)
        else { return nil }
    guard let data = try? JSONSerialization.data(withJSONObject: value, options: [])
        else { return nil }
    let JSONString = String(data:data ,encoding: .utf8)
    
    return JSONString
}

func toDictionary(form json : String) -> [String : Any]? {
    guard let jsonData = json.data(using: .utf8),
        let object = try? JSONSerialization.jsonObject(with: jsonData, options: []),
        let result = object as? [String : Any]
        else { return nil }
    return result
}
