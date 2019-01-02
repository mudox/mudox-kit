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
    
  }
  
  open func setupModel() {
    
  }

}
