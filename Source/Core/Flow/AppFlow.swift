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

      run(inDebugMode: Environs.appRunMode)
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

    private func resetIfNeeded() {
      let modes = Environs.appRestTokens
      modes.forEach(reset)
    }

    open func reset(mode: String) {
      jack.func().failure("Abstract method should not be called")
    }

  #endif

  // MARK: - Run

  #if DEBUG

    open func run(inDebugMode: String) {
      jack.func().failure("Abstract method should not be called")
    }

  #endif

  open func runInReleaseMode() {
    jack.func().failure("Abstract method should not be called")
  }

}

// MARK: - Related Environs

extension Environs {

  private static let appRunModeKey = "APP_RUN_MOD"
  fileprivate static var appRunMode: String {
    get { return string(forKey: appRunModeKey) ?? "release" }
    set { set(string: newValue, forKey: appRunModeKey) }
  }

  private static let appResetTokensKey = "APP_RESET_TOKENS"
  fileprivate static var appRestTokens: [String] {
    get { return tokens(forKey: appResetTokensKey) }
    set { set(tokens: newValue, forKey: appResetTokensKey) }
  }

}
