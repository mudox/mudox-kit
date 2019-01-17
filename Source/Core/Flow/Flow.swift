import UIKit

import RxCocoa
import RxSwift

import JacKit

private let jack = Jack().set(format: .short)

public protocol FlowType: AnyObject {
  var stage: Flow.Stage { get }
}

open class Flow: FlowType, ClassInstanceCounting {

  // MARK: FlowType

  /// Constant bag which only release subscription(s) on view controller
  /// deallocation.
  ///
  /// If you want to release subscription(s) within lifetime of the view
  /// controller, define `var` bags with more meaningful names.
  ///
  /// ```
  /// // Define dedicated bag for given subscriptions.
  /// var imageTasksBag = DisposeBag()
  /// // Release subscription explicitly.
  /// imageTasksBag = DisposeBag()
  /// ```
  public let bag = DisposeBag()
  
  public let stage: Flow.Stage

  // MARK: InstanceCounting

  static var roster: [String: Int] = [:]

  public init(on stage: Flow.Stage) {
    self.stage = stage
    checkIn()
  }

  deinit {
    checkOut()
  }
}
