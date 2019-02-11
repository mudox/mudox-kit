import UIKit

import RxSwift

import JacKit

private let jack = Jack().set(format: .short)

open class View: UIView {

  // Subclasses no longer need to add this boilerplate
  @available(*, unavailable, message: "init(coder:) is sealed")
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is sealed")
  }

  // MARK: - Skeleton

  public init() {
    super.init(frame: .zero)

    setupView()
    setupBinding()
  }

  open func setupView() {}

  public let bag = DisposeBag()

  open func setupBinding() {}

}
