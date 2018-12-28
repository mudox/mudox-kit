import UIKit

import RxCocoa
import RxSwift

import JacKit

private let jack = Jack().set(format: .short)

public enum FlowStage {
  
  case window(UIWindow)
  case viewController(UIViewController)

  public var window: UIWindow! {
    if case let FlowStage.window(window) = self {
      return window
    } else {
      return nil
    }
  }

  public var viewController: UIViewController! {
    if case let FlowStage.viewController(viewController) = self {
      return viewController
    } else {
      return nil
    }
  }
  
  public var navigationController: UINavigationController! {
    if case let FlowStage.viewController(vc) = self {
      return vc as? UINavigationController
    } else {
      return nil
    }
  }

  public var tabBarController: UITabBarController! {
    if case let FlowStage.viewController(vc) = self {
      return vc as? UITabBarController
    } else {
      return nil
    }
  }

}

public protocol FlowType: AnyObject {

  var disposeBag: DisposeBag { get set }

  var stage: FlowStage { get }

}

open class Flow: FlowType {

  public var disposeBag = DisposeBag()

  public let stage: FlowStage

  public init(on stage: FlowStage) {
    self.stage = stage
    incrementInstanceCount()
  }

  deinit {
    decrementInstanceCount()
  }

}

// MARK: - Flow Instance Counting

private var flowCounts: [String: Int] = [:]

private var dump: String {
  if flowCounts.isEmpty {
    return "flows: <no flows>"
  } else {
    return "flows: " + flowCounts
      .filter { $1 != 0 }
      .map { "\($0) [\($1)]" }
      .joined(separator: ", ")
  }
}

private extension Flow {

  var typeName: String {
    return String(describing: type(of: self))
  }

  func incrementInstanceCount() {
    flowCounts[typeName, default: 0] += 1
    validateCount(context: "init")
  }

  func decrementInstanceCount() {
    flowCounts[typeName, default: 0] -= 1
    validateCount(context: "deinit")
  }

  /// Subclass can override this property to return a bigger number.
  var maximumInstanceCount: Int {
    return 1
  }

  func validateCount(context: String) {
    let logger = Jack(typeName).sub(context).set(format: .short)

    let count = flowCounts[typeName]!
    let symbol = (context == "init") ? "🔥" : "💀"

    switch count {
    case 0 ... maximumInstanceCount:
      logger.debug("\(symbol) \(typeName) - \(dump)", format: .bare)
    default:
      logger.warn("""
      \(dump)
      Invalid instance count: \(count)
      """)
    }
  }

}
