import RxSwift
import RxCocoa

import JacKit
fileprivate let jack = Jack()

extension ActivityCenter {
  
  // MARK: All events of given activities

  private func _state(of activities: [Activity]) -> Signal<Activity.State> {
    return eventRelay
      .flatMap ({ event -> Signal<Activity.State> in
        if activities.contains(event.activity) {
          return .just(event.state)
        } else {
          return .empty()
        }
      })
      .asSignal(onErrorRecover: { error in
        jack.error("ActivityCenter.eventRelay emits an error: \(error), activity events dispatching is broken")
        return .empty()
      })
  }

  public func state(of activities: Activity...) -> Signal<Activity.State> {
    return _state(of: activities)
  }

  // MARK: Begin event of given activities
  
  private func _begin(of activities: [Activity]) -> Signal<Void> {
    return _state(of: activities)
      .flatMap { state -> Signal<Void> in
        switch state {
        case .begin:
          return .just(())
        default:
          return .empty()
        }
    }
  }

  public func begin(of activities: Activity...) -> Signal<Void> {
    return _begin(of: activities)
  }

  private func _next(of activities: [Activity]) -> Signal<Any?> {
    return _state(of: activities)
      .flatMap({ state -> Signal<Any?> in
        switch state {
        case .next(let value):
          return .just(value)
        default:
          return .empty()
        }
      })
  }

  // MARK: Next event of activities
  
  public func next(of activities: Activity...) -> Signal<Any?> {
    return _next(of: activities)
  }

  public func next<T>(_ type: T.Type, of activities: Activity...) -> Signal<T> {
    return _next(of: activities)
      .flatMap({ anyOrNil -> Signal<T> in
        if let value = anyOrNil as? T {
          return .just(value)
        } else {
          jack.debug("filter out element of unmatched type: \(anyOrNil)")
          return .empty()
        }
      })
  }

  // MARK: Complete event of given activities
  
  private func _complete(of activities: [Activity]) -> Signal<Void> {
    return _state(of: activities)
      .flatMap { state -> Signal<Void> in
        switch state {
        case .complete:
          return .just(())
        default:
          return .empty()
        }
    }
  }
  
  public func complete(of activities: Activity...) -> Signal<Void> {
    return _complete(of: activities)
  }
  
  // MARK: Activity.Event event of given activities

  private func _error(of activities: [Activity]) -> Signal<Swift.Error> {
    return _state(of: activities)
      .flatMap { state -> Signal<Swift.Error> in
        switch state {
        case .error(let error):
          return .just(error)
        default:
          return .empty()
        }
    }
  }

  public func error(of activities: Activity...) -> Signal<Swift.Error> {
    return _error(of: activities)
  }

  public func error<T: Swift.Error>(_ type: T.Type, of activities: Activity...) -> Signal<T> {
    return _error(of: activities)
      .flatMap({ error -> Signal<T> in
        if let error = error as? T {
          return .just(error)
        } else {
          jack.debug("filter out error of unmatched type: \(error)")
          return .empty()
        }
      })
  }
  
  // MARK: Exectuting state

  public func executing(of act: Activity) -> Driver<Bool> {
    return state(of: act)
      .map {
        switch $0 {
        case .end:
          return false
        default:
          return true
        }
      }
      .distinctUntilChanged()
      .startWith(false)
      .asDriver(onErrorRecover: { error in
        jack.error("should not error out")
        return .empty()
      })
  }

  public func combinedExecuting(of activities: [Activity]) -> Driver<Bool> {
    let e = activities.map(executing)
    return Driver.combineLatest(e)
      .map { $0.any { $0 } }
  }

}
