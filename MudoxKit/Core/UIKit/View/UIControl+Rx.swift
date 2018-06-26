import UIKit

import RxSwift
import RxCocoa


extension Reactive where Base: UIControl {
  
  public var isEditing: Driver<Bool> {
    return .merge(
      controlEvent(.editingDidBegin).asDriver().map { _ in true },
      controlEvent(.editingDidEnd).asDriver().map { _ in false }
    )
  }

}

extension Reactive where Base: UITextField {

  public var isPlaceHolderHidden: Driver<Bool> {
    return isEditing.withLatestFrom(text.orEmpty.asDriver()) { isEditing, text -> Bool in
      if isEditing {
        return true
      } else {
        return !text.trimmed().isEmpty
      }
    }
  }

}
