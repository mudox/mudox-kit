import class UIKit.UIApplication

import RxSwift
import RxCocoa

import JacKit
fileprivate let jack = Jack()

public final class ActivityCenter {

  public struct Event {

    public enum State {
      case begin
      case next(Any?)
      case success
      case error(Error)
      case end
    }

    public static func begin(_ activity: Activity) -> Event {
      return Event(activity: activity, state: .begin)
    }

    public static func next(_ activity: Activity, element: Any?) -> Event {
      return Event(activity: activity, state: .next(element))
    }

    public static func success(_ activity: Activity, element: Any?) -> Event {
      return Event(activity: activity, state: .success)
    }

    public static func error(_ activity: Activity, error: Error) -> Event {
      return Event(activity: activity, state: .error(error))
    }

    public static func end(_ activity: Activity) -> Event {
      return Event(activity: activity, state: .end)
    }

    let activity: Activity
    let state: State
  }

  // MARK: - Singleton: ActivityCenter.shared

  public static let shared: ActivityCenter = {
    let c = ActivityCenter()
    _ = c.networkActivity
      .skip(1) // skip initial `false` element
    .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
    return c
  }()

  private init() {
    networkActivity = _networkActivityRelay
      .asDriver()
      .distinctUntilChanged()
  }

  // MARK: - Private Members

  private let _lock = NSRecursiveLock()
  private var _activities: [Activity: Int] = [:]


  /// Internal method for testing purpose
  func reset() {
    _lock.lock()
    _activities = [:]
    _lock.unlock()
  }

  // MARK: - Report Activity Events

  private let _eventRelay = PublishRelay<Event>()

  public func addEvent(_ event: Event) {
    _lock.lock(); defer { _lock.unlock() }

    // log event if required
    if event.activity.isLoggingEnbaled {
      Jack("ActivityTracker").verbose("\(event)")
    }

    // count running activity
    switch event.state {
    case .begin:
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
      Jack.failure("""
        \(runningCount) instances of \(activity) running at the same time, only \(maxCount) instances \
        is allowed.
        """)
    }

    _eventRelay.accept(event)
  }

  // MARK: - Network Activity Monitoring

  private let _networkActivityRelay = BehaviorRelay<Bool>(value: false)

  public let networkActivity: Driver<Bool>

  // MARK: - Handle Activities

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
        case .begin, .next:
          return true
        case .success, .error, .end:
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

// MARK: - The.activityCenter

extension The {
  public static var activityCenter: ActivityCenter { return ActivityCenter.shared }
}
