import Foundation

import JacKit
fileprivate let jack = Jack.with(levelOfThisFile: .verbose)


/// Global function version of `DispatchQueue.asynAfter...`.
///
///       after(3) {
///         // would execute after 3 second in the default
///         // queue which is `DispathQueue.main`
///       }
///
/// - Parameters:
///   - interval: Delayed interval in seconds.
///   - queue: Dispatch queue to perform the delayed work in.
///   - work: The delayed work.
public func after(
  _ interval: TimeInterval,
  in queue: DispatchQueue = DispatchQueue.main,
  do work: @escaping () -> Void
)
{
  guard interval > 0 else {
    jack.failure("paramter `interval` must > 0")
    return
  }
  
  DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: work)
}
