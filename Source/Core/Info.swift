import UIKit

public enum Info {
  // MARK: App
  public static var appName: String {
    return The.process.processName
  }
  public static var appBundleID: String? {
    return The.mainBundle.bundleIdentifier
  }
  public static var appRelease: String? {
    return The.mainBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
  }
  public static var appBuild: String? {
    return The.mainBundle.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
  }

  public static var isDebug: Bool {
    #if DEBUG
      return true
    #else
      return false
    #endif
  }
  public static var isSimulator: Bool {
    #if targetEnvironment(simulator)
    return true
    #else
    return false
    #endif
  }
  public static var isUITest: Bool {
    return The.process.environment["isUITest"] != nil
  }

  // MARK: Device
  public static var deviceName: String {
    return The.device.name
  }
  public static var deviceModel: String {
    return The.device.model
  }
  public static var deviceUUID: String? {
    return The.device.identifierForVendor?.uuidString
  }

  // MARK: System
  public static var systemName: String {
    return The.device.systemName
  }
  public static var systemVersion: String {
    return The.device.systemVersion
  }

  public static var isLowPowerModeEnabled: Bool {
    return The.process.isLowPowerModeEnabled
  }

  @available(iOS 11.0, *)
  public static var thermalState: ProcessInfo.ThermalState {
    return The.process.thermalState
  }

  public static var isReduceMotionEnabled: Bool {
    return UIAccessibility.isReduceMotionEnabled
  }

  // MARK: Screen
  public static var screenWidth: CGFloat {
    return The.mainScreen.bounds.width
  }

  public static var screenHeight: CGFloat {
    return The.mainScreen.bounds.height
  }
}
