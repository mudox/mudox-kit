import UIKit

import RxCocoa
import RxSwift

public enum LoadingState<Value> {

  case begin(phase: String?)
  case progress(phase: String, completed: Double)
  case error(Error)
  case value(Value)

  public var isInProgress: Bool {
    switch self {
    case .begin, .progress:
      return true
    default:
      return false
    }
  }

  public var value: Value! {
    if case let .value(value) = self {
      return value
    } else {
      return nil
    }
  }

}

// MARK: - Equatable

extension LoadingState: Equatable where Value: Equatable {

  public static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
    switch (lhs, rhs) {
    case (.begin, .begin):
      return true
    case (.error, .error):
      return true
    case let (.value(v1), .value(v2)):
      return v1 == v2
    default:
      return false
    }
  }

}

// MARK: - Transform

extension LoadingState {

  public var error: Error! {
    if case let .error(error) = self {
      return error
    } else {
      return nil
    }
  }

  public func analysis<T>(
    mapBegin: (String?) -> T,
    mapProgress: (String, Double) -> T,
    mapValue: (Value) -> T,
    mapError: (Error) -> T
  )
    -> T
  {
    switch self {
    case let .begin(phase):
      return mapBegin(phase)
    case let .progress(phase, progress):
      return mapProgress(phase, progress)
    case let .value(value):
      return mapValue(value)
    case let .error(error):
      return mapError(error)
    }
  }

  public func map<T>(_ transform: (Value) -> T) -> LoadingState<T> {
    return analysis(
      // swiftformat:disable consecutiveSpaces
      // swiftlint:disable operator_usage_whitespace comma
      mapBegin:  { .begin(phase: $0)                  },
      mapProgress: { .progress(phase: $0, completed: $1)  },
      mapValue:    { .value(transform($0))                },
      mapError:    { .error($0)                           }
      // swiftlint:enable operator_usage_whitespace comma
      // swiftformat:enable consecutiveSpaces
    )
  }

  public func flatMap<T>(_ transform: (Value) -> LoadingState<T>) -> LoadingState<T> {
    return analysis(
      // swiftformat:disable consecutiveSpaces
      // swiftlint:disable operator_usage_whitespace comma
      mapBegin:   { .begin(phase: $0)                  },
      mapProgress:  { .progress(phase: $0, completed: $1)  },
      mapValue:     { transform($0)                        },
      mapError:     { .error($0)                           }
      // swiftlint:enable operator_usage_whitespace comma
      // swiftformat:enable consecutiveSpaces
    )
  }

}

public extension ObservableConvertibleType {

  func asLoadingStateDriver(phase: String? = nil) -> Driver<LoadingState<E>> {
    return asObservable()
      .map(LoadingState.value)
      .startWith(LoadingState.begin(phase: phase))
      .asDriver { .just(.error($0)) }
  }

}
