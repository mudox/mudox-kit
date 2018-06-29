import Foundation

import RxSwift
import RxCocoa

import JacKit
fileprivate let jack = Jack()

extension Bool {
  public mutating func toggle() {
    self = !self
  }
}

public enum TaskState<Result> {
  case begin
  case progress(Double)
  case success(Result)
  case error(Error)
  
  
  /// Return `true` only if self is `.success(value)` case.
  ///
  /// Convenient computed property for filtering.
  public var isSuccess: Bool {
    switch self {
    case .success: return true
    default: return false
    }
  }
}

extension PrimitiveSequence where Trait == SingleTrait {

  public var taskStateDriver: Driver<TaskState<Element>> {
    return self
      .map(TaskState<Element>.success)
      .asDriver { error in
        jack.error("asDriver captured error: \(error)")
        return .empty()
      }
      .startWith(TaskState<Element>.begin)
  }

}
