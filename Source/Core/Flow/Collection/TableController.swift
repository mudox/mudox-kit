import UIKit

import RxSwift

import JacKit

private let jack = Jack().set(format: .short)

open class TableController: UITableViewController, ClassInstanceCounting {

  // MARK: InstanceCounting

  static var roster: [String: Int] = [:]

  // Subclasses no longer need to add this boilerplate
  @available(*, unavailable, message: "init(coder:) is sealed")
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is sealed")
  }

  public init() {
    super.init(nibName: nil, bundle: nil)
    checkIn()
  }

  deinit {
    checkOut()
  }

  open override func viewDidLoad() {
    super.viewDidLoad()

    setupView()
    setupModel()
  }

  open func setupView() {}

  public let bag = DisposeBag()
  
  open func setupModel() {}

}
