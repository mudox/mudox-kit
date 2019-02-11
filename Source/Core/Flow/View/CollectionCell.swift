import UIKit

import RxSwift

open class CollectionCell: UICollectionViewCell {

  // Subclasses no longer need to add this boilerplate
  @available(*, unavailable, message: "init(coder:) is sealed")
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is sealed")
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)

    setupView()
    setupBinding()
  }

  open func setupView() {}

  private let bag = DisposeBag()

  open func setupBinding() {}

}
