import UIKit

import RxCocoa
import RxSwift

import JacKit

private let jack = Jack()

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

}

public protocol FlowType: AnyObject {

  var disposeBag: DisposeBag { get set }

  var stage: FlowStage { get }

}

open class BaseFlow: FlowType {

  public var disposeBag = DisposeBag()

  public let stage: FlowStage

  public init(stage: FlowStage) {
    self.stage = stage
    incrementInstanceCount()
  }

  deinit {
    jack.debug("💀 \(type(of: self))", options: .bare)
    decrementInstanceCount()
  }

}

// MARK: - Flow Instance Counting

private var flowCounts: [String: Int] = [:]

private var flowCountsDump: String {
  if flowCounts.isEmpty {
    return "flows: <no flows>"
  } else {
    return "flows: " + flowCounts
      .map { "\($0) [\($1)]" }
      .joined(separator: ", ")
  }
}

private extension BaseFlow {

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

  /// Subclass can override this propety to return a bigger number.
  var maximumInstanceCount: Int {
    return 1
  }

  func validateCount(context: String) {
    let logger = Jack(typeName).descendant(context).set(options: .short)

    let count = flowCounts[typeName]!

    switch count {
    case 0 ... maximumInstanceCount:
      logger.debug(flowCountsDump)
    default:
      logger.warn("""
      \(flowCountsDump)
      invalid count: \(count)
      """)
    }
  }

}
