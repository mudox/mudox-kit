import Foundation

import JacKit
fileprivate let jack = Jack()

public enum CommonError: Error {
  case cancelled
  case casting(Any?, to: Any.Type)
  case weakReference
  case error(String)
}
