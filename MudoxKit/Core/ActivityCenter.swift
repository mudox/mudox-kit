import class UIKit.UIApplication

import RxSwift
import RxCocoa
import RxSwiftExt

import JacKit
fileprivate let jack = Jack.usingLocalFileScope().setLevel(.verbose)


public protocol ActivityType: Hashable {

  /// Maximum count of instance allowed to run at the same time.
  /// Default: 1
  var maxConcurrency: Int { get }

  /// Log out each events of this kind of tasks.
  /// Used for debugging.
  /// Default: false
  var isLoggingEnbaled: Bool { get }

  /// Keep UIApplication.shared.isNetworkActivityIndicatorVisible to true
  /// when this kind of tasks are executing.
  /// Default: false
  var isNetworkActivity: Bool { get }

}

extension ActivityType {

  public var maxConcurrency: Int { return 1 }

  public var isLoggingEnbaled: Bool { return false }

  public var isNetworkActivity: Bool { return false }
}

public final class ActivityCenter<Activity: ActivityType> {

  public struct Event {

    public enum State {
      case start
      case next(Any?)
      case succeed
      case fail(Error)
      case end
    }

    let activity: Activity
    let state: State
  }
  
  public init() {
    networkActivity = _networkActivityRelay
      .asDriver()
      .distinctUntilChanged()
  }

  // MARK: Private Members

  private let _lock = NSRecursiveLock()
  private var _activities: [Activity: Int] = [:]

  private let _eventRelay = PublishRelay<Event>()

  private func _post(_ event: Event) {
    _lock.lock(); defer { _lock.unlock() }

    // log event if required
    if event.activity.isLoggingEnbaled {
      Jack(scope: "ActivityTracker").verbose("\(event)")
    }

    // count running activity
    switch event.state {
    case .start:
      _activities[event.activity, default: 0] += 1
    case .end:
      let count = _activities[event.activity, default: 0]
      guard count > 0 else {
        Jack.failure("Internal data inconsistent, count should >= 0")
        break
      }
      _activities[event.activity] = count - 1
    default:
      break
    }

    // network activity
    let isNetworkActive = _activities
      .filter { act, cnt in act.isNetworkActivity }
      .any { act, cnt in cnt > 0 }
    jack.debug("network active: \(isNetworkActive)")
    _networkActivityRelay.accept(isNetworkActive)

    // count check
    let activity = event.activity
    let runningCount = _activities[event.activity, default: 0]

    if runningCount < 0 {
      jack.error("""
        negative count (\(runningCount)) for activity \(activity), should be >= 0
        """)
    }

    // `maxConcurrency` should >= 1
    var maxCount = activity.maxConcurrency
    if maxCount <= 0 {
      jack.error("""
        \(activity).maxConcurrency (\(maxCount)) should be >= 1, use 1")
        """)
      maxCount = 1
    }

    if runningCount > maxCount {
      jack.warn("""
        \(runningCount) instances of \(activity) running at the same, only \(maxCount) instances
        is allowed.
        """)
    }

    _eventRelay.accept(event)
  }

  // MARK: Network Activity Monitoring

  private let _networkActivityRelay = BehaviorRelay<Bool>(value: false)

  public let networkActivity: Driver<Bool>

  // MARK: Record Events Manually

  public func start(_ activity: Activity) {
    _post(Event(activity: activity, state: .start))
  }

  public func next(_ element: Any?, _ activity: Activity) {
    _post(Event(activity: activity, state: .next(element)))
  }

  public func succeed(_ activity: Activity) {
    _post(Event(activity: activity, state: .succeed))
  }

  public func fail(_ error: Error, _ activity: Activity) {
    _post(Event(activity: activity, state: .fail(error)))
  }

  public func end(_ activity: Activity) {
    _post(Event(activity: activity, state: .end))
  }

  // MARK: Handle Activities

  public func states(of activity: Activity) -> Observable<Event.State> {
    return mergedStates(of: [activity])
  }

  public func mergedStates(of activities: [Activity]) -> Observable<Event.State> {
    return _eventRelay
      .filterMap ({
        if activities.contains($0.activity) {
          return .map($0.state)
        } else {
          return .ignore
        }
      })
  }

  public func executing(of act: Activity) -> Observable<Bool> {
    return states(of: act)
      .map {
        switch $0 {
        case .start, .next:
          return true
        case .succeed, .fail, .end:
          return false
        }
      }
      .distinctUntilChanged()
      .startWith(false)
  }

  public func combinedExecuting(of activities: [Activity]) -> Observable<Bool> {
    let e = activities.map(executing)
    return Observable.combineLatest(e)
      .map { $0.any { $0 } }
  }

}

extension ObservableType {

  /// Convenient operator to transform observable event into activity events and report them to the
  /// activity center.
  ///
  /// - Parameters:
  ///   - activity: The activity to track.
  ///   - tracker: The activity tracker singleton to manage all activity events.
  /// - Returns: The receiver itself.
  public func track<A: ActivityType>(_ activity: A, by tracker: ActivityCenter<A>) -> Observable<Self.E> {
    return asObservable()
      .do(
        onNext: {
          tracker.next($0, activity)
        },
        onError: {
          tracker.fail($0, activity)
        },
        onCompleted: {
          tracker.succeed(activity)
        },
        onSubscribe: {
          tracker.start(activity)
        },
        onDispose: {
          tracker.end(activity)
        }
      )
  }

}
