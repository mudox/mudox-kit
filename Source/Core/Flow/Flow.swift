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

  public let bag = DisposeBag()
  
  public let stage: Flow.Stage

  // MARK: InstanceCounting

  static var roster: [String: Int] = [:]

  public init(on stage: Flow.Stage) {
    self.stage = stage
    checkIn()
  }
  
  convenience public init(on window: UIWindow) {
    self.init(on: .window(window))
  }
    
  convenience public init(on viewController: UIViewController) {
    self.init(on: .viewController(viewController))
  }

  deinit {
    checkOut()
  }
  
}
