
import UIKit
import MBProgressHUD

import RxSwift
import RxCocoa

import JacKit
fileprivate let jack = Jack.usingLocalFileScope().setLevel(.verbose)

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
    extra change: ChangeMBP? = nil
    ) {
    execute(.info(title: title, message: message, mode: mode, extra: change))
  }
  
  public func start(
    title: String? = nil,
    message: String? = nil,
    mode: MBProgressHUDMode = .indeterminate,
    extra change: ChangeMBP? = nil
  ) {
    execute(.info(title: title, message: message, mode: mode, extra: change))
  }

  public func next(
    title: String? = nil,
    message: String? = nil,
    mode: MBProgressHUDMode = .indeterminate,
    extra change: ChangeMBP? = nil
    ) {
    execute(.info(title: title, message: message, mode: mode, extra: change))
  }

  public func progress(
    _ progress: Double,
    extra change: ChangeMBP? = nil
  )
  {
    execute(.progress(progress, extra: change))
  }

  public func success(
    title: String? = nil,
    message: String? = nil,
    hideIn interval: TimeInterval = 1,
    extra change: ChangeMBP? = nil
  )
  {
    execute(.success(title: title, message: message, hideIn: interval, extra: change))
  }

  public func failure(
    title: String? = nil,
    message: String? = nil,
    hideIn interval: TimeInterval = 1,
    extra change: ChangeMBP? = nil
  )
  {
    execute(.failure(title: title, message: message, hideIn: interval, extra: change))
  }
}
