import UIKit

import RxCocoa
import RxSwift

import JacKit
fileprivate let jack = Jack().set(format: .short)

extension Reactive where Base: UIControl {

  public var isEditing: Driver<Bool> {
    return .merge(
      controlEvent(.editingDidBegin).asDriver().map { _ in true },
      controlEvent(.editingDidEnd).asDriver().map { _ in false }
    )
  }

}

extension Reactive where Base: UIControl {

  public static func createTapStopGroup(_ controls: Base...) -> Disposable {
    guard controls.count > 1 else {
      jack.func().failure("Need at least 2 controls, currently \(controls.count) control")
      return Disposables.create()
    }

    let disposables = controls.dropLast().enumerated().map { index, control -> Disposable in
      let nextControl = controls[index + 1]
      return control.rx.controlEvent(.editingDidEndOnExit).bind(onNext: {
        nextControl.becomeFirstResponder()
      })
    }

    return Disposables.create(disposables)
  }

}
