import UIKit

import RxSwift

import JacKit

private let jack = Jack().set(format: .short)

open class CollectionController: UICollectionViewController, ClassInstanceCounting {

  // Subclasses no longer need to add this boilerplate
  @available(*, unavailable, message: "init(coder:) is sealed")
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is sealed")
  }
  
  // No need in storyboard-free developing
  private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    fatalError("init(nibName:bundle:) is sealed")
  }

  // MARK: ClassInstanceCounting

  static var roster: [String: Int] = [:]

  public override init(collectionViewLayout: UICollectionViewLayout) {
    super.init(collectionViewLayout: collectionViewLayout)
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
