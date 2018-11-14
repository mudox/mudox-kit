import UIKit

import RxSwift
import RxCocoa

import JacKit
fileprivate let jack = Jack()

extension Reactive where Base: UIControl {

  public var isEditing: Driver<Bool> {
    return .merge(
      controlEvent(.editingDidBegin).asDriver().map { _ in true },
      controlEvent(.editingDidEnd).asDriver().map { _ in false }
    )
  }

}

extension Reactive where Base: UIControl {
  
  public static func setupTapStopGroup(_ controls: Base...) -> Disposable {
      guard controls.count > 1 else {
        Jack("MudoxKit.Array.setupTapStop").warn("count should > 1")
        return Disposables.create()
      }
      
      let disposables = controls.dropLast().enumerated().map { indexAndControl -> Disposable in
        let (index, control) = indexAndControl
        let nextControl = controls[index + 1]
        return control.rx.controlEvent(.editingDidEndOnExit).bind(onNext: {
          nextControl.becomeFirstResponder()
        })
      }
      
      return Disposables.create(disposables)
  }
  
}
