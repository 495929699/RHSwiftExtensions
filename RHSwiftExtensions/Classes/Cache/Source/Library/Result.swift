import Foundation

/// Used for callback in async operations.
public enum CacheResult<T> {
  case value(T)
  case error(Error)

  public func map<U>(_ transform: (T) -> U) -> CacheResult<U> {
    switch self {
    case .value(let value):
      return CacheResult<U>.value(transform(value))
    case .error(let error):
      return CacheResult<U>.error(error)
    }
  }
    
    /// 是否成功
    var isSuccess : Bool {
        switch self {
        case .value:
            return true
        case .error:
            return false
        }
    }
    
    var value : T? {
        switch self {
        case let .value(v):
            return v
        case .error:
            return nil
        }
    }
    
}
