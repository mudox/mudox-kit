import class UIKit.UIApplication

import RxSwift
import RxCocoa

public enum Activity {

  case start(task: String)
  case progress(Double, task: String)
  case success(task: String)
  case failure(task: String)

  public var task: String {
    switch self {
    case .start(let task):
      return task
    case .progress(_, let task):
      return task
    case .success(let task):
      return task
    case .failure(let task):
      return task
    }
  }
}

final class ActivityTracker {

  private let _subject = PublishSubject<Activity>()
  
  //  MARK: Record activities

  public func start(_ task: String) {
    _subject.onNext(.start(task: task))
  }

  public func progress(_ progress: Double, task: String) {
    _subject.onNext(.progress(progress, task: task))
  }

  public func sucess(_ task: String) {
    _subject.onNext(.success(task: task))
  }

  public func failure(_ task: String) {
    _subject.onNext(.failure(task: task))
  }
  
  // MARK: Handle activities

  public func activity(of task: String) -> Observable<Activity> {
    return _subject.filter { $0.task == task }
  }

  public func executing(of task: String) -> Observable<Bool> {
    return activity(of: task)
      .filter ({
        switch $0 {
        case .start, .success, .failure:
          return true
        case .progress:
          return false
        }
      })
      .map ({
        switch $0 {
        case .start:
          return true
        case .success, .failure:
          return false
        default:
          fatalError()
        }
      })
  }

}
