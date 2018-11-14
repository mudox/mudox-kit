import class UIKit.UIApplication

import RxSwift
import RxCocoa

import JacKit
fileprivate let jack = Jack()

extension Activity {

  /// Activity.Event = (Activity, Activty.State)
  public struct Event {
    let activity: Activity
    let state: State
  }

}

// MARK: - Factory Methods

extension Activity.Event {

  public static func begin(_ activity: Activity) -> Activity.Event {
    return Activity.Event(activity: activity, state: .begin)
  }

  public static func next(_ activity: Activity, element: Any?) -> Activity.Event {
    return Activity.Event(activity: activity, state: .next(element))
  }

  public static func error(_ activity: Activity, error: Error) -> Activity.Event {
    return Activity.Event(activity: activity, state: .error(error))
  }

  public static func complete(_ activity: Activity) -> Activity.Event {
    return Activity.Event(activity: activity, state: .complete)
  }

  public static func end(_ activity: Activity) -> Activity.Event {
    return Activity.Event(activity: activity, state: .end)
  }

}

// MARK: - Description

extension Activity.Event: CustomStringConvertible {

  public var description: String {
    return """
      \(activity) state:\(state.shortDescription)
      """
  }

}
