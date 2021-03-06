import UIKit
import MBProgressHUD

import RxSwift
import RxCocoa

import JacKit
fileprivate let jack = Jack()

extension MBPProxy where Base: UIView {

  public func execute(_ command: MBPCommand) {
    command.execute(base)
  }

  public var hud: Binder<MBPCommand> {
    return Binder(base) { base, command in
      command.execute(base)
    }
  }

  public func info(
    title: String? = nil,
    message: String? = nil,
    mode: MBProgressHUDMode = .indeterminate,
    apply change: ChangeMBP? = nil
  )
  {
    execute(.info(title: title, message: message, mode: mode, apply: change))
  }

  public func start(
    title: String? = nil,
    message: String? = nil,
    mode: MBProgressHUDMode = .indeterminate,
    apply change: ChangeMBP? = nil
  )
  {
    execute(.info(title: title, message: message, mode: mode, apply: change))
  }

  public func progress(
    _ progress: Double,
    apply change: ChangeMBP? = nil
  )
  {
    execute(.progress(progress, apply: change))
  }

  public func success(
    title: String? = nil,
    message: String? = nil,
    hideIn interval: TimeInterval = 1,
    apply change: ChangeMBP? = nil
  )
  {
    execute(.success(title: title, message: message, hideIn: interval, apply: change))
  }

  public func error(
    title: String? = nil,
    message: String? = nil,
    hideIn interval: TimeInterval = 1,
    apply change: ChangeMBP? = nil
  )
  {
    execute(.error(title: title, message: message, hideIn: interval, apply: change))
  }
  
  public func hide() {
    MBProgressHUD(for: base)?.hide(animated: false)
  }
}
