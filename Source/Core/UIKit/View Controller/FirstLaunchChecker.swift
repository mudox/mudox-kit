import JacKit

private let jack = Jack("MudoxKit.FirstLaunchChecker").set(format: .short)

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
      jack.func().info("First launch for the application")
      kind = .application
    } else if lastRelease != currentRelease {
      jack.func().info("First launch for release <\(currentRelease)>")
      kind = .release
    } else {
      jack.func().info("Ordinary launch")
      kind = .other
    }

    // Record this launch
    UserDefaults.standard.set(Info.appRelease, forKey: lastLaunchReleaseKey)

    return kind
  }

  internal var currentRelease: String {
    if let release = The.bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
      return release
    } else {
      jack.sub(#function).warn("Failed to get app release string, return an empty string")
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
