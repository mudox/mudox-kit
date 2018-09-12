import UIKit

import JacKit
fileprivate let jack = Jack()

var _appStateTrackingTokens: [NSObjectProtocol] = []

extension Mudoxive where Base: UIApplication {
  
  /// Switch to app' own page in the Settings.app
  public func openSettingsPage() {
    let url = URL(string: UIApplicationOpenSettingsURLString)!
    if #available(iOS 10.0, *) {
      UIApplication.shared.open(url)
    } else {
      UIApplication.shared.openURL(url)
    }
  }
  
  public func setupAtLaunchTime() {
    dumpBasicInfo()
    startTrackingStateChanges()
  }

  /// Log a line when App state transition happens.
  public func startTrackingStateChanges() {
    if !_appStateTrackingTokens.isEmpty {
      stopTrackingStateChanges()
    }
    
    _appStateTrackingTokens = _appStates.map { item in
      The.notificationCenter.addObserver(forName: item.key, object: nil, queue: nil, using: { _ in
        Jack().debug("⭐️ \(item.value)", options: .messageOnly)
      })
    }
  }
  
  public func stopTrackingStateChanges() {
    if _appStateTrackingTokens.isEmpty {
      jack.warn("\(#function) is invoked when there is no tokens to remove")
    }
    _appStateTrackingTokens.forEach(The.notificationCenter.removeObserver)
  }

  public func dumpBasicInfo() {
    let lines = """
    🚀 \(Info.appName)
    [App]
      - Name       :   \(Info.appName)
      - ID         :   \(Info.appBundleID ?? "N/A")
      - Release    :   \(Info.appRelease ?? "N/A")  (CFBundleShortVersionString)
      - Build      :   \(Info.appBuild ?? "N/A") (kCFBundleVersionKey)
      - Debug      :   \(Info.isDebug)
      - Simulator  :   \(Info.isSimulator)
    [Device]
      - Name       :   \(Info.deviceName)
      - Model      :   \(Info.deviceModel)
      - UUID       :   \(Info.deviceUUID ?? "N/A")
    [System]
      - Name       :   \(Info.systemName)
      - Version    :   \(Info.systemVersion)
    """ + "\n"
    Jack(Info.appName).info(lines, options: .messageOnly)
  }
}
