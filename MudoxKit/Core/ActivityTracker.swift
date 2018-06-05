import class UIKit.UIApplication

import RxSwift
import RxCocoa
import RxSwiftExt

import JacKit
fileprivate let jack = Jack.with(levelOfThisFile: .verbose)

protocol ActivityType: Hashable {
  var oneAtATime: Bool { get }
  var isLoggingEnbaled: Bool { get }
}

extension ActivityType {
  var oneAtATime: Bool { return true }
  var isLoggingEnbaled: Bool { return false }
}

public final class ActivityTracker<Activity: Hashable> {

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

  public init() { }

  // MARK: Private Members

  private let _lock = NSRecursiveLock()
  private var _activities: [Activity: UInt] = [:]

  private let _subject = PublishSubject<Event>()

  private func _post(_ event: Event) {
    _lock.lock(); defer { _lock.unlock() }

    switch event.state {
    case .start:
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

    _subject.onNext(event)
  }

  //  MARK: Record Activities

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
    return states(of: [activity])
  }

  public func states(of activities: [Activity]) -> Observable<Event.State> {
    return _subject
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

  public func track<A>(_ activity: A, by tracker: ActivityTracker<A>) -> Observable<Self.E> {
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
