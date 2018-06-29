import class UIKit.UIApplication

import RxSwift
import RxCocoa

import JacKit
fileprivate let jack = Jack()

extension Activity {

  public enum State {

    /// Before an observable is subscriped.
    case begin
    /// Obervable type's  .next event.
    /// Single / Maybe type's .success event.
    case next(Any?)
    /// Any observable type's .error event.
    case error(Error)
    /// Mabe .completed event.
    /// Completable type's .completed event.
    /// Observable type's .completed event.
    case complete
    /// After any observable is disposed.
    case end

    var shortDescription: String {
      switch self {
      case .begin:
        return "begin"
      case .error(let error):
        return "error(\(error))"
      case .complete:
        return "complete"
      case .end:
        return "end"
      case .next(let value):
        return "next(\(value))"
      }
    }

  }

}
