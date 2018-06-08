import class UIKit.UIApplication

import RxSwift
import RxCocoa
import RxSwiftExt

import JacKit
fileprivate let jack = Jack.usingLocalFileScope().setLevel(.verbose)

public final class ActivityCenter {

  public struct Event {

    public enum State {
      case start
      case next(Any?)
      case succeed
      case fail(Error)
      case end
    }

    public static func start(_ activity: Activity) -> Event {
      return Event(activity: activity, state: .start)
    }
    
    public static func next(_ activity: Activity, element: Any?) -> Event {
      return Event(activity: activity, state: .next(element))
    }
    
    public static func succeed(_ activity: Activity) -> Event {
      return Event(activity: activity, state: .succeed)
    }
    
    public static func fail(_ activity: Activity, error: Error) -> Event {
      return Event(activity: activity, state: .fail(error))
    }
    
    public static func end(_ activity: Activity) -> Event {
      return Event(activity: activity, state: .end)
    }

    let activity: Activity
    let state: State
  }

  // MARK: Singleton

  public static let shared = ActivityCenter()

  init() {
    networkActivity = _networkActivityRelay
      .asDriver()
      .distinctUntilChanged()
  }

  // MARK: Private Members

  private let _lock = NSRecursiveLock()
  private var _activities: [Activity: Int] = [:]

  // MARK: Report Activity Events
  
  private let _eventRelay = PublishRelay<Event>()

  public func addEvent(_ event: Event) {
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

  // MARK: Network Activity Monitoring

  private let _networkActivityRelay = BehaviorRelay<Bool>(value: false)

  public let networkActivity: Driver<Bool>

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

extension The {
  public static var activityCenter: ActivityCenter { return ActivityCenter.shared }
}

extension ObservableType {

  /// Convenient operator to transform observable event into activity events and report them to the
  /// activity center.
  ///
  /// - Parameters:
  ///   - activity: The activity to track.
  ///   - tracker: The activity tracker singleton to manage all activity events.
  /// - Returns: The receiver itself.
  public func trackActivity(_ activity: Activity) -> Observable<Self.E> {
    let center = ActivityCenter.shared

    return asObservable()
      .do(
        onNext: {
          center.addEvent(.next(activity, element: $0))
        },
        onError: {
          center.addEvent(.fail(activity, error: $0))
        },
        onCompleted: {
          center.addEvent(.succeed(activity))
        },
        onSubscribe: {
          center.addEvent(.start(activity))
        },
        onDispose: {
          center.addEvent(.end(activity))
        }
      )
  }

}
