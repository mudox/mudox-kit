//
//  MBP.swift
//  MudoxKit
//
//  Created by Mudox on 14/08/2017.
//
//

import UIKit
import MBProgressHUD

import RxSwift
import RxCocoa

import JacKit
fileprivate let jack = Jack.with(levelOfThisFile: .debug)

extension MBPProxy where Base: UIView {

  public func execute(_ command: MBPCommand) {
    command.execute(base)
  }

  public var hud: Binder<MBPCommand> {
    return Binder(base) { base, command in
      command.execute(base)
    }
  }

  public func start(
    title: String? = nil,
    message: String? = nil,
    mode: MBProgressHUDMode = .indeterminate,
    extra change: ChangeMBP? = nil
  ) {
    execute(.start(title: title, message: message, mode: mode, extra: change))
  }

  public func updateProgress(
    _ progress: Double,
    extra change: ChangeMBP? = nil
  )
  {
    execute(.updateProgress(progress, extra: change))
  }

  public func nextStep(
    title: String? = nil,
    message: String? = nil,
    mode: MBProgressHUDMode = .indeterminate,
    extra change: ChangeMBP? = nil
  ) {
    execute(.nextStep(title: title, message: message, mode: mode, extra: change))
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

