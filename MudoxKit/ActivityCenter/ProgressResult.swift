import RxSwift
import RxCocoa

public protocol ProgressResultType {
  associatedtype ResultType

  var progress: Double? { get }
  var result: ResultType? { get }
}

public enum ProgressResult<T> {
  case progress(Double)
  case result(T)
}

extension ProgressResult: ProgressResultType {

  public typealias ResultType = T

  public var progress: Double? {
    switch self {
    case .progress(let progress):
      return progress
    case .result:
      return nil
    }
  }

  public var result: T? {
    switch self {
    case .progress:
      return nil
    case .result(let result):
      return result
    }
  }

}

extension ObservableType where E: ProgressResultType {

  public func filterProgress() -> Observable<Double> {
    return flatMap ({ progressOrResult -> Observable<Double> in
      if let progress = progressOrResult.progress {
        return .just(progress)
      } else {
        return .empty()
      }
    })
  }

  public func filterResult() -> Observable<E.ResultType> {
    return flatMap ({ progressOrResult -> Observable<E.ResultType> in
      if let result = progressOrResult.result {
        return .just(result)
      } else {
        return .empty()
      }
    })
  }

}

extension SharedSequence where S == DriverSharingStrategy, Element: ProgressResultType {

  public func filterProgress() -> Driver<Double> {
    return flatMap ({ progressOrResult -> Driver<Double> in
      if let progress = progressOrResult.progress {
        return .just(progress)
      } else {
        return .empty()
      }
    })
  }

  public func filterResult() -> Driver<E.ResultType> {
    return flatMap ({ progressOrResult -> Driver<E.ResultType> in
      if let result = progressOrResult.result {
        return .just(result)
      } else {
        return .empty()
      }
    })
  }

}
