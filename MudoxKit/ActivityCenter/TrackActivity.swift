import RxSwift
import RxCocoa

// MARK: - Observable.trackActivity

extension ObservableType {

  /// Convenient operator to transform `Observable` event into activity events and report them to the
  /// activity center.
  ///
  /// - Parameters:
  ///   - activity: The activity to track.
  ///   - tracker: The activity tracker singleton to manage all activity events.
  /// - Returns: The receiver itself.
  public func trackActivity(_ activity: Activity) -> Observable<Self.E> {
    let center = ActivityCenter.shared

    return self.do(
      onNext: {
        center.addEvent(.next(activity, element: $0))
      },
      onError: {
        center.addEvent(.error(activity, error: $0))
      },
      onCompleted: {
        center.addEvent(.success(activity, element: nil))
      },
      onSubscribe: {
        center.addEvent(.begin(activity))
      },
      onDispose: {
        center.addEvent(.end(activity))
      }
    )
  }

}

// MARK: - Single.trackActivity

extension PrimitiveSequence where Trait == SingleTrait {

  /// Convenient operator to transform `SingleEvent` event into activity events and report them to the
  /// activity center.
  ///
  /// - Parameters:
  ///   - activity: The activity to track.
  ///   - tracker: The activity tracker singleton to manage all activity events.
  /// - Returns: The receiver itself.
  public func trackActivity(_ activity: Activity) -> Single<Element> {
    let center = ActivityCenter.shared

    return self.do(
      onSuccess: {
        center.addEvent(.success(activity, element: $0))
      },
      onError: {
        center.addEvent(.error(activity, error: $0))
      },
      onSubscribe: {
        center.addEvent(.begin(activity))
      },
      onDispose: {
        center.addEvent(.end(activity))
      }
    )
  }

}
