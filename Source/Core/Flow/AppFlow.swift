import UIKit

import RxCocoa
import RxSwift

import JacKit

private let jack = Jack().set(format: .short)

public protocol AppFlowType: FlowType {

  var run: Completable { get }

}

open class AppFlow: Flow, AppFlowType {

  open var run: Completable {
    return .create { completable in

      Jack.reportAppInfo()
      Jack.startReportingAppStateChanges()

      #if DEBUG
        self.resetIfNeeded()
      #endif

      #if DEBUG
        self.debugRun(self.runMode)
      #else
        self.releaseRun()
      #endif

      return Disposables.create()
    }
  }

  // MARK: - Reset App States

  #if DEBUG

    open var resetModes: [String]? {
      return ProcessInfo.processInfo
        .environment["APP_RESET_MODE"]?
        .split(separator: " ")
        .map { String($0.lowercased()) }
    }

    /// Reset app states for developing purpose
    ///
    /// Reset according to the value of environment variable __RESET__:
    /// - "defaults":  reset UserDefaults through SwiftyUserDefaults
    /// - "cache": reset caches through Cache
    private func resetIfNeeded() {
      resetModes?.forEach(reset)
    }

    open func reset(_: String) {
      jack.func().verbose("BaseAppFlow.reset(_ mode:) does nothing, no need to call super in overrides")
    }

  #endif

  // MARK: - Run Mode

  open var runMode: String? {
    return ProcessInfo.processInfo.environment["APP_RUN_MODE"]
  }

  open func debugRun(_: String?) {
    jack.func().verbose("BaseAppFlow.debugRun(_ mode:) does nothing, no need to call super in overrides")
  }

  open func releaseRun() {
    jack.func().verbose("BaseAppFlow.releaseRun does nothing, no need to call super in overrides")
  }
}
