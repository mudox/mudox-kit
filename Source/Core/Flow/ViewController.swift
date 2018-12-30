import UIKit

import RxSwift

open class ViewController: UIViewController, ClassInstanceCounting {

  public var disposeBag = DisposeBag()
  
  
  // MARK: InstanceCounting
  
  static var roster: [String: Int] = [:]

  // Subclasses no need to add this chunk of code
  @available(*, unavailable, message: "init(coder:) has not been implemented")
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    checkIn()
  }

  deinit {
    checkOut()
  }
  
}
