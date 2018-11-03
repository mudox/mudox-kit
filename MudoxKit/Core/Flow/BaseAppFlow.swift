import UIKit

import RxSwift

import MudoxKit

protocol AppFlowType: FlowType {

  func start()

}

open class BaseAppFlow: BaseFlow, AppFlowType {

  /// The application's main user launching logic.
  /// Subclasses need to override this method to put application launching
  /// logic into it.
  open func start() {
    The.app.mdx.dumpBasicInfo()
    The.app.mdx.startTrackingStateChanges()
  }

}
