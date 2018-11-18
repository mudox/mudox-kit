import UIKit

import JacKit
fileprivate let jack = Jack()


extension Mudoxive where Base: UIApplication {
  
  /// Switch to app' own page in the Settings.app
  public func openSettingsPage() {
    let url = URL(string: UIApplication.openSettingsURLString)!
    if #available(iOS 10.0, *) {
      UIApplication.shared.open(url)
    } else {
      UIApplication.shared.openURL(url)
    }
  }
  
}
