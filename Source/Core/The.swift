
import UIKit

/// The special `enum` used as namespace for all commonly accessed
/// global symbols
public enum The {

  /// UIApplication.shared
  public static var app: UIApplication {
    return UIApplication.shared
  }
  /// UIDevice.current
  public static var device: UIDevice {
    return UIDevice.current
  }

  /// FileManager.default
  public static var files: FileManager {
    return FileManager.default
  }

  /// Bundle.main
  public static var bundle: Bundle {
    return Bundle.main
  }

  /// UIScreen.main
  public static var screen: UIScreen {
    return UIScreen.main
  }

  /// UIApplication.shared.windows.first!
  public static var window: UIWindow {
    return app.windows.first!
  }

  /// UIApplication.shared.windows.first!.rootViewController
  public static var controller: UIViewController {
    return window.rootViewController!
  }

  /// NofiticationCenter.default
  public static var notifier: NotificationCenter {
    return NotificationCenter.default
  }

  /// ProcessInfo.processInfo
  public static var process: ProcessInfo {
    return ProcessInfo.processInfo
  }
  
  /// ProcessInfo.processInfo.environments
  public static var env: [String: String] {
    return ProcessInfo.processInfo.environment
  }

  /// UserDefaults.standard
  public static var defaults: UserDefaults {
    return UserDefaults.standard
  }

}
