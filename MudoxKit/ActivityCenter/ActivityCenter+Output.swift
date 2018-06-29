import class UIKit.UIApplication

import RxSwift
import RxCocoa

import JacKit
fileprivate let jack = Jack()

extension ActivityCenter {
  
  // MARK: All events of given activities

  private func _state(of activities: [Activity]) -> Observable<Activity.State> {
    return eventRelay
      .filterMap ({
        if activities.contains($0.activity) {
          return .map($0.state)
        } else {
          return .ignore
        }
      })
  }

  public func state(of activities: Activity...) -> Observable<Activity.State> {
    return _state(of: activities)
  }

  // MARK: Begin event of given activities
  
  private func _begin(of activities: [Activity]) -> Observable<Void> {
    return _state(of: activities)
      .flatMap { state -> Observable<Void> in
        switch state {
        case .begin:
          return .just(())
        default:
          return .empty()
        }
    }
  }

  public func begin(of activities: Activity...) -> Observable<Void> {
    return _begin(of: activities)
  }

  private func _next(of activities: [Activity]) -> Observable<Any?> {
    return _state(of: activities)
      .flatMap({ state -> Observable<Any?> in
        switch state {
        case .next(let value):
          return .just(value)
        default:
          return .empty()
        }
      })
  }

  // MARK: Next event of activities
  
  public func next(of activities: Activity...) -> Observable<Any?> {
    return _next(of: activities)
  }

  public func next<T>(_ type: T.Type, of activities: Activity...) -> Observable<T> {
    return _next(of: activities)
      .flatMap({ anyOrNil -> Observable<T> in
        if let value = anyOrNil as? T {
          return .just(value)
        } else {
          jack.debug("filter out element of unmatched type: \(anyOrNil)")
          return .empty()
        }
      })
  }

  // MARK: Complete event of given activities
  
  private func _complete(of activities: [Activity]) -> Observable<Void> {
    return _state(of: activities)
      .flatMap { state -> Observable<Void> in
        switch state {
        case .complete:
          return .just(())
        default:
          return .empty()
        }
    }
  }
  
  public func complete(of activities: Activity...) -> Observable<Void> {
    return _complete(of: activities)
  }
  
  // MARK: Activity.Event event of given activities

  private func _error(of activities: [Activity]) -> Observable<Swift.Error> {
    return _state(of: activities)
      .flatMap { state -> Observable<Swift.Error> in
        switch state {
        case .error(let error):
          return .just(error)
        default:
          return .empty()
        }
    }
  }

  public func error(of activities: Activity...) -> Observable<Swift.Error> {
    return _error(of: activities)
  }

  public func error<T: Swift.Error>(_ type: T.Type, of activities: Activity...) -> Observable<T> {
    return _error(of: activities)
      .flatMap({ error -> Observable<T> in
        if let error = error as? T {
          return .just(error)
        } else {
          jack.debug("filter out error of unmatched type: \(error)")
          return .empty()
        }
      })
  }
  
  // MARK: Exectuting state

  public func executing(of act: Activity) -> Observable<Bool> {
    return state(of: act)
      .map {
        switch $0 {
        case .begin:
          return true
        default:
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
