import UIKit

import RxSwift

open class View: UIView, ClassInstanceCounting {

  public var disposeBag = DisposeBag()

  // MARK: InstanceCounting

  static var roster: [String: Int] = [:]

  // Subclasses no need to add this chunk of code
  @available(*, unavailable, message: "init(coder:) has not been implemented")
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public init() {
    super.init(frame: .zero)
    checkIn()
  }

  deinit {
    checkOut()
  }

}
