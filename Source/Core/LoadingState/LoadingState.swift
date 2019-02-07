import UIKit

import RxCocoa
import RxSwift

public enum LoadingState<Value> {

  case loading

  case error(Error)

  case value(Value)

  public var isLoading: Bool {
    if case .loading = self {
      return true
    } else {
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
    case (.loading, .loading):
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

  public func analysis<T>(ifLoading: () -> T, ifValue: (Value) -> T, ifError: (Error) -> T) -> T {
    switch self {
    case .loading:
      return ifLoading()
    case let .value(value):
      return ifValue(value)
    case let .error(error):
      return ifError(error)
    }
  }

  public func map<T>(_ transform: (Value) -> T) -> LoadingState<T> {
    return analysis(
      // swiftformat:disable consecutiveSpaces
      // swiftlint:disable operator_usage_whitespace comma
      ifLoading: { .loading   },
      ifValue:   { .value(transform($0)) },
      ifError:   { .error($0) }
      // swiftlint:enable operator_usage_whitespace comma
      // swiftformat:enable consecutiveSpaces
    )
  }

  public func flatMap<T>(_ transform: (Value) -> LoadingState<T>) -> LoadingState<T> {
    return analysis(
      // swiftformat:disable consecutiveSpaces
      // swiftlint:disable operator_usage_whitespace comma
      ifLoading: { .loading      },
      ifValue:   { transform($0) },
      ifError:   { .error($0)    }
      // swiftlint:enable operator_usage_whitespace comma
      // swiftformat:enable consecutiveSpaces
    )
  }

}

public extension ObservableConvertibleType {

  func asLoadingStateDriver() -> Driver<LoadingState<E>> {
    return asObservable()
      .map(LoadingState.value)
      .startWith(.loading)
      .asDriver { .just(.error($0)) }
  }

}
