import UIKit

import RxCocoa
import RxSwift

import JacKit

private let jack = Jack().set(format: .short)

public protocol AppFlowType: FlowType {
  func run()

  #if DEBUG
    func reset(mode: String)
  #endif
}

open class AppFlow: Flow, AppFlowType {
  #if DEBUG

    public func run() {
      Jack.reportAppInfo()
      Jack.startReportingAppStateChanges()

      resetIfNeeded()

      run(inDebugMode: runMode)
    }

  #else

    public func run() {
      Jack.reportAppInfo()
      Jack.startReportingAppStateChanges()

      runInReleaseMode()
    }

  #endif

  // MARK: - Reset

  #if DEBUG

    private var resetModes: [String]? {
      return ProcessInfo.processInfo
        .environment["APP_RESET_MODE"]?
        .split(separator: " ")
        .map { token in
          String(token).lowercased()
        }
    }

    private func resetIfNeeded() {
      resetModes?.forEach(reset)
    }

    open func reset(mode: String) {
      jack.func().verbose("AppFlow.reset(_ mode:) does nothing, no need to call super in overrides")
    }

  #endif

  // MARK: - Run

  #if DEBUG

    private var runMode: String {
      return ProcessInfo.processInfo.environment["APP_RUN_MODE"] ?? "release"
    }

    open func run(inDebugMode: String) {
      jack.func().verbose("AppFlow.debugRun(mode:) does nothing, no need to call super in overrides")
    }

  #endif

  open func runInReleaseMode() {
    jack.func().verbose("AppFlow.releaseRun() does nothing, no need to call super in overrides")
  }

}
