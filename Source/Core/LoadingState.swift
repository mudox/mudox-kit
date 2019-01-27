import RxCocoa
import RxSwift

public enum LoadingState<Value> {

  case loading

  case value(Value)

  case error(Error)

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
      ifLoading: { .loading },
      ifValue: { .value(transform($0)) },
      ifError: LoadingState<T>.error
    )
  }

  public func flatMap<T>(_ transform: (Value) -> LoadingState<T>) -> LoadingState<T> {
    return analysis(
      ifLoading: { .loading },
      ifValue: transform,
      ifError: LoadingState<T>.error
    )
  }

}

public extension ObservableConvertibleType {

  func asLoadingStateDriver() -> Driver<LoadingState<E>> {
    return self
      .asObservable()
      .map(LoadingState.value)
      .startWith(.loading)
      .asDriver { .just(.error($0)) }
  }

}