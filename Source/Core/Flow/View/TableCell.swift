import UIKit

import RxSwift

open class TableCell: UITableViewCell {

  // Subclasses no longer need to add this boilerplate
  @available(*, unavailable, message: "init(coder:) is sealed")
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is sealed")
  }

  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupView()
    setupBinding()
  }

  open func setupView() {}

  private let bag = DisposeBag()

  open func setupBinding() {}

}
