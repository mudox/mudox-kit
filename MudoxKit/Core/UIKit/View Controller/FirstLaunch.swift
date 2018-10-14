import JacKit

private let jack = Jack("MudoxKit.FirstLaunch").set(options: .short)

public class FirstLaunch {

  internal static let lastLaunchReleaseKey = "io.github.mudox.MudoxKit.FirstLaunch.launchRelease"

  public enum Kind {
    /// `application` implies `release`
    case application
    case release
    case none
  }

  public static var kind: Kind = resolve()

  public static func resolve() -> Kind {

    let lastRelease = UserDefaults.standard.string(forKey: lastLaunchReleaseKey)

    let kind: Kind
    if lastRelease == nil {
      jack.descendant("resolve").info("this is the first launch of the application")
      kind = .application
    } else if lastRelease != currentRelease {
      jack.descendant("resolve").info("this is the first launch of release \(currentRelease)")
      kind = .release
    } else {
      jack.descendant("resolve").info("ordinatory launch")
      kind = .none
    }

    // Record this launch
    UserDefaults.standard.set(Info.appRelease, forKey: lastLaunchReleaseKey)

    return kind
  }

  public static var currentRelease: String {
    if let release = The.mainBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
      return release
    } else {
      jack.descendant("currentRelease").warn("failed to get app release string, return an empty string")
      return ""
    }
  }

}
