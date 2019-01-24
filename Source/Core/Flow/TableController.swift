import UIKit

import RxSwift

import JacKit

private let jack = Jack().set(format: .short)

open class TableController: UITableViewController, ClassInstanceCounting {

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

  // MARK: InstanceCounting

  static var roster: [String: Int] = [:]

  // Subclasses no need to add this chunk of code
  @available(*, unavailable, message: "init(coder:) has not been implemented")
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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

  open func setupView() {
    jack.func().failure("Abstract method")
  }

  open func setupModel() {
    jack.func().failure("Abstract method")
  }

}
