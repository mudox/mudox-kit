import Foundation

import JacKit

fileprivate let jack = Jack()


/// Global function version of `DispatchQueue.asynAfter...`.
///
///     after(3) {
///       // would execute after 3 second in the default
///       // queue which is `DispathQueue.main`
///     }
///
/// - Parameters:
///   - interval: Delayed interval in seconds.
///   - queue: Dispatch queue to perform the delayed work in.
///   - work: The delayed work.
public func after(
  seconds: TimeInterval,
  in queue: DispatchQueue = DispatchQueue.main,
  do work: @escaping () -> Void
) {
  guard seconds > 0 else {
    jack.function().failure("paramter `interval` must > 0")
    return
  }

  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: work)
}
