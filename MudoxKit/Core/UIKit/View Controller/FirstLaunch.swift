import JacKit

private let jack = Jack("MudoxKit.FirstLaunch")

public class FirstLaunch {
  
  static let launchReleaseKey = "io.github.mudox.MudoxKit.FirstLaunch.launchRelease"
  
  public enum Kind {
    /// `application` implies `release`
    case application
    case release
    case none
  }
  
  public static var kind: Kind = resolve()
  
  internal static func resolve() -> Kind {
    
    let lastRelease = UserDefaults.standard.string(forKey: launchReleaseKey)
    
    let kind: Kind
    if lastRelease == nil {
      kind = .application
    } else if lastRelease == currentRelease {
      kind = .release
    } else {
      kind = .none
    }
    
    // Record this launch
    UserDefaults.standard.set(Info.appRelease, forKey: launchReleaseKey)
    
    return kind
  }
  
  private static var currentRelease: String {
    if let release = The.mainBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
      return release
    } else {
      jack.descendant("currentRelease").warn("failed to get app release string, return an empty string")
      return ""
    }
  }
  
}
