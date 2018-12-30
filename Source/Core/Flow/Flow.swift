import UIKit

import RxCocoa
import RxSwift

import JacKit

private let jack = Jack().set(format: .short)

public protocol FlowType: AnyObject {
  var disposeBag: DisposeBag { get set }
  var stage: Flow.Stage { get }
}

open class Flow: FlowType, ClassInstanceCounting {

  // MARK: FlowType

  public var disposeBag = DisposeBag()
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
