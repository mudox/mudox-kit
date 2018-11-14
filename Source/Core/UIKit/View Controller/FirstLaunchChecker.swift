import JacKit

private let jack = Jack("MudoxKit.FirstLaunchChecker").set(options: .short)

public protocol FirstLaunchCheckerType {
  func check() -> FirstLaunchKind
}

public enum FirstLaunchKind {

  /// `application` implies `release`
  case application
  case release
  case other

}

public class FirstLaunchChecker: FirstLaunchCheckerType {

  // MARK: - Singleton

  public static let shared = FirstLaunchChecker()

  private init() {}

  // MARK: - Internal Members

  internal let lastLaunchReleaseKey = "io.github.mudox.MudoxKit.FirstLaunch.launchRelease"

  internal var kind: FirstLaunchKind?

  internal func resolve() -> FirstLaunchKind {

    let lastRelease = UserDefaults.standard.string(forKey: lastLaunchReleaseKey)

    let kind: FirstLaunchKind
    if lastRelease == nil {
      jack.function().info("1st launch for the application")
      kind = .application
    } else if lastRelease != currentRelease {
      jack.function().info("1st launch for current release - \(currentRelease)")
      kind = .release
    } else {
      jack.function().info("ordinary launch")
      kind = .other
    }

    // Record this launch
    UserDefaults.standard.set(Info.appRelease, forKey: lastLaunchReleaseKey)

    return kind
  }

  internal var currentRelease: String {
    if let release = The.mainBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
      return release
    } else {
      jack.descendant(#function).warn("failed to get app release string, return an empty string")
      return ""
    }
  }

  // MARK: - Public Interface

  public func check() -> FirstLaunchKind {
    if let kind = kind {
      return kind
    }

    kind = resolve()

    return kind!
  }

}
