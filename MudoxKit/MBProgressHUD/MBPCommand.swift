//
//  MBPCommand.swift
//  CocoaLumberjack
//
//  Created by Mudox on 2018/4/5.
//

import Foundation
import MBProgressHUD

import JacKit
fileprivate let jack = Jack.with(fileLocalLevel: .verbose)

/// Change MBProgressHUD view
public typealias ChangeMBP = (MBProgressHUD) -> ()

/// Change MBProgressHUD view for the parameter view
public typealias ChangeMBPofView = (UIView) -> ()

public struct MBPCommand {

  let change: ChangeMBPofView

  func execute(_ view: UIView) {
    change(view)
  }

  private init(change: @escaping ChangeMBPofView) {
    self.change = change
  }

  public static func start(
    title: String? = nil,
    message: String? = nil,
    mode: MBProgressHUDMode = .indeterminate,
    extra change: ChangeMBP? = nil
  ) -> MBPCommand {
    return MBPCommand.init { view in
      // make sure hud is shown
      let hud = MBProgressHUD(for: view) ?? MBProgressHUD.showAdded(to: view, animated: true)

      // texts
      hud.label.text = title
      hud.detailsLabel.text = message

      // progress and mode
      hud.progress = 0
      hud.mode = mode

      // apply extra change if any
      change?(hud)
    }
  }

  public static func updateProgress(
    _ progress: Double,
    extra change: ChangeMBP? = nil
  )
    -> MBPCommand
  {
    return MBPCommand.init { view in
      if MBProgressHUD(for: view) == nil {
        jack.warn("HUD view should already be shown")
      }

      // make sure hud is shown
      let hud = MBProgressHUD(for: view) ?? MBProgressHUD.showAdded(to: view, animated: true)

      hud.progress = Float(progress)

      change?(hud)

      if hud.mode == .indeterminate
        || hud.mode == .customView
        || hud.mode == .text {
        jack.warn("Invalid MBProgressHUDMode (\(hud.mode.caseName)), the progress can not be shown")
      }
    }
  }

  public static func nextStep(
    title: String? = nil,
    message: String? = nil,
    mode: MBProgressHUDMode = .indeterminate,
    extra change: ChangeMBP? = nil
  ) -> MBPCommand {
    return start(title: title, message: message, mode: mode, extra: change)
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
    extra change: ChangeMBP? = nil
  ) -> MBPCommand {
    return MBPCommand.init { view in
      // make sure hud is shown
      let hud = MBProgressHUD(for: view) ?? MBProgressHUD.showAdded(to: view, animated: true)

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

      // color
      hud.setForeground(color: .white)
      hud.setBackground(color: MBPResources.successColor)


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
  public static func failure(title: String? = nil, message: String? = nil, hideIn interval: TimeInterval = 1, extra change: ChangeMBP? = nil) -> MBPCommand {
    return MBPCommand.init { view in
      // make sure hud is shown
      let hud = MBProgressHUD(for: view) ?? MBProgressHUD.showAdded(to: view, animated: true)

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

      // color
      hud.setForeground(color: .white)
      hud.setBackground(color: MBPResources.failureColor)

      // apply extra change if any
      change?(hud)

      // hide
      hud.hide(animated: true, afterDelay: interval)
    }
  }
}
