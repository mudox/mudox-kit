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

    /// Run in given reset & run mode at runtime. It overrides run and reset
    /// mode derived from environments. It is designed to be called in setup
    /// stage before each test case (E.g. in `beforeEach` closure of an EarlGrey
    /// test suite.
    ///
    /// - Parameters:
    ///   - resetModes: Array of reset tokens defined by user, defaults to release
    ///                 mode.
    ///   - mode: Debug run mode string, if nil derive from environments which
    ///           defaults to `"release"`.
    public func run(reset resetModes: [String]? = nil, mode: String? = nil) {
      _resetModes = resetModes
      _runMode = mode

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

    private var _resetModes: [String]?

    private var _envResetModes: [String]? {
      return ProcessInfo.processInfo
        .environment["APP_RESET_MODE"]?
        .split(separator: " ")
        .map { token in
          String(token).lowercased()
        }
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

  // MARK: - Run

  #if DEBUG

    private var _runMode: String?

    private var _envRunMode: String? {
      return ProcessInfo.processInfo.environment["APP_RUN_MODE"]
    }

    private var runMode: String {
      return _runMode ?? _envRunMode ?? "release"
    }

    open func run(inDebugMode: String) {
      jack.func().verbose("AppFlow.debugRun(mode:) does nothing, no need to call super in overrides")
    }

  #endif

  open func runInReleaseMode() {
    jack.func().verbose("AppFlow.releaseRun() does nothing, no need to call super in overrides")
  }

}
