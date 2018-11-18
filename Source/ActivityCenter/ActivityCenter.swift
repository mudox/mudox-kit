import class UIKit.UIApplication

import RxSwift
import RxCocoa

import JacKit
fileprivate let jack = Jack()

public final class ActivityCenter {

  // MARK: - ActivityCenter.shared

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

  // MARK: - Manage Activities

  private let _lock = NSRecursiveLock()
  private var _activities: [Activity: Int] = [:]


  /// Internal method for testing purpose
  func reset() {
    _lock.lock()
    _activities = [:]
    _lock.unlock()
  }

  // MARK: - Report Activity Events

  let eventRelay = PublishRelay<Activity.Event>()

  public func post(_ event: Activity.Event) {
    _lock.lock(); defer { _lock.unlock() }

    // log event if required
    if event.activity.isLoggingEnabled {
      Jack("ActivityCenter").verbose("\(event)")
    }

    // count running activity
    switch event.state {
    case .begin:
      _activities[event.activity, default: 0] += 1
    case .end:
      let count = _activities[event.activity, default: 0]
      guard count > 0 else {
        jack.failure("Internal data inconsistent, count should >= 0")
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
      jack.failure("""
        \(runningCount) instances of \(activity) running at the same time, only \(maxCount) instances \
        is allowed.
        """)
    }

    eventRelay.accept(event)
  }

  // MARK: - Network Activity Monitoring

  private let _networkActivityRelay = BehaviorRelay<Bool>(value: false)

  public let networkActivity: Driver<Bool>

}

// MARK: - The.activityCenter

extension The {
  public static var activityCenter: ActivityCenter { return ActivityCenter.shared }
}
