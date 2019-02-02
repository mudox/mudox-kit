
import UIKit

/// The special `enum` used as namespace for all commonly accessed
/// global symbols
public enum The {

  /// The application singleton instance
  ///
  /// ```swift
  /// UIApplication.shared
  /// ```
  public static var app: UIApplication {
    return UIApplication.shared
  }

  /// The current device
  ///
  /// ```swift
  /// UIDevice.current
  /// ```
  public static var device: UIDevice {
    return UIDevice.current
  }

  /// The default file manager
  ///
  /// ```swift
  /// FileManager.default
  /// ```
  public static var files: FileManager {
    return FileManager.default
  }

  /// The app's main bundle
  ///
  /// ```swift
  /// Bundle.main
  /// ```
  public static var bundle: Bundle {
    return Bundle.main
  }

  /// The app's main screen
  ///
  /// ```swift
  /// UIScreen.main
  /// ```
  public static var screen: UIScreen {
    return UIScreen.main
  }

  /// The app's main window
  ///
  /// ```swift
  /// UIApplication.shared.windows.first!
  /// ```
  public static var window: UIWindow {
    return app.windows.first!
  }

  /// The root view controlller of app's main window
  ///
  /// ```swift
  /// UIApplication.shared.windows.first!.rootViewController
  /// ```
  public static var controller: UIViewController {
    return window.rootViewController!
  }

  /// The default notification center
  ///
  /// ```swift
  /// NofiticationCenter.default
  /// ```
  public static var notifier: NotificationCenter {
    return NotificationCenter.default
  }

  /// The singleton process info instance
  ///
  /// ```swift
  /// ProcessInfo.processInfo
  /// ```
  public static var process: ProcessInfo {
    return ProcessInfo.processInfo
  }
  
  /// The environments directionary of the process
  ///
  /// ```swift
  /// ProcessInfo.processInfo.environments
  /// ```
  public static var env: [String: String] {
    return ProcessInfo.processInfo.environment
  }

  /// The standard user defaults
  ///
  /// ```swift
  /// UserDefaults.standard
  /// ```
  public static var defaults: UserDefaults {
    return UserDefaults.standard
  }

}
