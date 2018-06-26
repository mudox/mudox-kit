import Foundation
import MBProgressHUD

import JacKit
fileprivate let jack = Jack.fileScopeInstance().setLevel(.debug)

/// Change MBProgressHUD view
public typealias ChangeMBP = (MBProgressHUD) -> ()

/// Change MBProgressHUD view for the parameter view
public typealias ChangeMBPofView = (UIView) -> ()

private func _getHUD(
  from view: UIView,
  addIfNotExists: Bool = true,
  warnIfNotExists: Bool = true
)
  -> MBProgressHUD?
{
  guard let hud = MBProgressHUD(for: view) else {
    if warnIfNotExists {
      var text = "HUD view does not exist"
      if addIfNotExists {
        text += ", add new HUD view"
      } else {
        text += ", return nil"
      }
      jack.verbose(text)
    }
    if addIfNotExists {
      return MBProgressHUD.showAdded(to: view, animated: true)
    } else {
      return nil
    }
  }
  return hud
}

public struct MBPCommand {

  let change: ChangeMBPofView

  func execute(_ view: UIView) {
    change(view)
  }

  private init(change: @escaping ChangeMBPofView) {
    self.change = change
  }

  // MARK: - Commands

  public static func hide(
    animated: Bool = false,
    afterDelay interval: TimeInterval = 0
  )
    -> MBPCommand
  {
    return MBPCommand { view in
      _getHUD(from: view, addIfNotExists: false, warnIfNotExists: false)?
        .hide(animated: animated, afterDelay: interval)
    }
  }

  public static func info(
    title: String? = nil,
    message: String? = nil,
    mode: MBProgressHUDMode = .text,
    hideIn interval: TimeInterval = 1,
    apply change: ChangeMBP? = nil
  )
    -> MBPCommand
  {
    return MBPCommand.init { view in
      // make sure hud is shown
      let hud = _getHUD(from: view)!

      // texts
      hud.label.text = title
      hud.detailsLabel.text = message

      // progress and mode
      hud.progress = 0
      hud.mode = mode

      // apply extra change if any
      change?(hud)

      // hide
      hud.hide(animated: true, afterDelay: interval)
    }
  }

  public static func start(
    title: String? = nil,
    message: String? = nil,
    mode: MBProgressHUDMode = .indeterminate,
    apply change: ChangeMBP? = nil
  )
    -> MBPCommand
  {
    return info(title: title, message: message, mode: mode, apply: change)
  }

  public static func next(
    title: String? = nil,
    message: String? = nil,
    mode: MBProgressHUDMode = .indeterminate,
    apply change: ChangeMBP? = nil
  )
    -> MBPCommand
  {
    return info(title: title, message: message, mode: mode, apply: change)
  }

  public static func progress(
    _ progress: Double,
    apply change: ChangeMBP? = nil
  )
    -> MBPCommand
  {
    return MBPCommand.init { view in
      let hud = _getHUD(from: view)!

      hud.progress = Float(progress)

      change?(hud)

      if hud.mode == .indeterminate
        || hud.mode == .customView
        || hud.mode == .text {
        jack.warn("Invalid MBProgressHUDMode (\(hud.mode.caseName)), the progress can not be shown")
      }
    }
  }

  /// Predefined appearance for success result.
  ///
  /// - Parameters:
  ///   - title: Title string.
  ///   - message: Message String.
  ///   - interval: Interval in which to hide the HUD.
  ///   - change: Extra modifications applied to the HUD.
  /// - Returns: The MBPCommand to change the HUD states.
  public static func success(
    title: String? = nil,
    message: String? = nil,
    hideIn interval: TimeInterval = 1,
    apply change: ChangeMBP? = nil
  )
    -> MBPCommand
  {
    return MBPCommand.init { view in
      let hud = _getHUD(from: view)!

      // reset progress
      hud.progress = 0

      // custom view to show success mark
      hud.mode = .customView
      let image = MBPResources.checkMarkImage
      let imageView = UIImageView(image: image)
      hud.customView = imageView

      // text
      hud.label.text = title
      hud.detailsLabel.text = message

      // apply extra change if any
      change?(hud)

      // hide
      hud.hide(animated: true, afterDelay: interval)
    }
  }

  /// Predefined appearance for failure result.
  ///
  /// - Parameters:
  ///   - title: Title string.
  ///   - message: Message String.
  ///   - interval: Interval in which to hide the HUD.
  ///   - change: Extra modifications applied to the HUD.
  /// - Returns: The MBPCommand to change the HUD states.
  public static func failure(
    title: String? = nil,
    message: String? = nil,
    hideIn interval: TimeInterval = 1,
    apply change: ChangeMBP? = nil
  )
    -> MBPCommand
  {
    return MBPCommand.init { view in
      let hud = _getHUD(from: view)!

      // reset progress
      hud.progress = 0

      // custom view to show success mark
      hud.mode = .customView
      let image = MBPResources.crossMarkImage
      let imageView = UIImageView(image: image)
      hud.customView = imageView

      // text
      hud.label.text = title
      hud.detailsLabel.text = message

      // apply extra change if any
      change?(hud)

      // hide
      hud.hide(animated: true, afterDelay: interval)
    }
  }
}
