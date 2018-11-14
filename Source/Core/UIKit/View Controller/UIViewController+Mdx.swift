import UIKit
import JacKit

fileprivate let jack = Jack()

extension Mudoxive where Base: UIViewController {

  public func dismiss(animated: Bool = true) {
    guard !base.isBeingDismissed else {
      jack.warn("the view controller is being dismissed")
      return
    }

    guard !base.isBeingPresented else {
      jack.warn("the view controller is being presenting, dismiss in subsequent run loop")
      DispatchQueue.main.async {
        self.dismiss(animated: animated)
      }
      return
    }

    if base.presentingViewController != nil {
      base.dismiss(animated: animated, completion: nil)
    } else {
      jack.warn("`base.presentingViewController` is nil")
    }
  }
  
  public func setBackButtonTitleEmpty() {
    base.navigationItem.backBarButtonItem =
      UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }

}
