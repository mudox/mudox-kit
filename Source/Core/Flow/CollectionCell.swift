import UIKit

import RxSwift

import JacKit

private let jack = Jack().set(format: .short)

open class CollectionCell: UICollectionViewCell {

  // Subclasses no longer need to add this boilerplate
  @available(*, unavailable, message: "init(coder:) is sealed")
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is sealed")
  }

  public init() {
    super.init(frame: .zero)

    setupView()
    setupBinding()
  }

  open func setupView() {
    jack.func().failure("Abstract method")
  }

  private let bag = DisposeBag()

  open func setupBinding() {
    jack.func().failure("Abstract method")
  }

}
