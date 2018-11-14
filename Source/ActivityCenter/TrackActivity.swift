import RxSwift
import RxCocoa

// MARK: Observable.trackActivity

extension ObservableType {

  /// Convenient operator to transform `Observable` event into activity events and report them to the
  /// activity center.
  ///
  /// - Parameters:
  ///   - activity: The activity to track.
  ///   - tracker: The activity tracker singleton to manage all activity events.
  /// - Returns: The receiver itself.
  public func trackActivity(_ activity: Activity) -> Observable<Self.E> {
    return self.do(
      onNext: {
        activity.next($0)
      },
      onError: {
        activity.error($0)
      },
      onCompleted: {
        activity.complete()
      },
      onSubscribe: {
        activity.begin()
      },
      onDispose: {
        activity.end()
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
    return self.do(
      onSuccess: {
        activity.next($0)
      },
      onError: {
        activity.error($0)
      },
      onSubscribe: {
        activity.begin()
      },
      onDispose: {
        activity.end()
      }
    )
  }

}


// MARK: - Driver.trackActivity

extension SharedSequence where S == DriverSharingStrategy {

  /// Convenient operator to transform `SingleEvent` event into activity events and report them to the
  /// activity center.
  ///
  /// - Parameters:
  ///   - activity: The activity to track.
  ///   - tracker: The activity tracker singleton to manage all activity events.
  /// - Returns: The receiver itself.
  public func trackActivity(_ activity: Activity) -> Driver<Element> {
    return self.do(
      onNext: {
        activity.next($0)
      },
      onCompleted: {
        activity.complete()
      },
      onSubscribe: {
        activity.begin()
      },
      onDispose: {
        activity.end()
      }
    )
  }

}
