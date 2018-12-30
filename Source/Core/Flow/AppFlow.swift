import UIKit

import RxCocoa
import RxSwift

import JacKit

private let jack = Jack().set(format: .short)

public protocol AppFlowType: FlowType {
  #if DEBUG
    func run(reset: [String]?, mode: String?)
  #else
    func run()
  #endif
}

open class AppFlow: Flow, AppFlowType {

  #if DEBUG
    public func run(reset resetModes: [String]? = nil, mode: String? = nil) {
      _resetModes = resetModes
      _runMode = mode

      Jack.reportAppInfo()
      Jack.startReportingAppStateChanges()

      resetIfNeeded()

      debugRun(mode: runMode)
    }

  #else
    public func run() {
      Jack.reportAppInfo()
      Jack.startReportingAppStateChanges()

      releaseRun()
    }

  #endif

  // MARK: - Reset App States

  #if DEBUG

    private var _resetModes: [String]?

    private var _envResetModes: [String]? {
      return ProcessInfo.processInfo
        .environment["APP_RESET_MODE"]?
        .split(separator: " ")
        .map { String($0.lowercased()) }
    }

    private var resetModes: [String]? {
      return _resetModes ?? _envResetModes
    }

    private func resetIfNeeded() {
      resetModes?.forEach(reset)
    }

    open func reset(mode: String) {
      jack.func().verbose("AppFlow.reset(_ mode:) does nothing, no need to call super in overrides")
    }

  #endif

  // MARK: - Run Mode

  private var _runMode: String?

  private var _envRunMode: String? {
    return ProcessInfo.processInfo.environment["APP_RUN_MODE"]
  }

  private var runMode: String {
    return _runMode ?? _envRunMode ?? "release"
  }

  open func debugRun(mode: String) {
    jack.func().verbose("AppFlow.debugRun(mode:) does nothing, no need to call super in overrides")
  }

  open func releaseRun() {
    jack.func().verbose("AppFlow.releaseRun() does nothing, no need to call super in overrides")
  }
}
