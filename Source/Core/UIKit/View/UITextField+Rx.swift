import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: UITextField {

  public var shouldHidePlaceHolder: Driver<Bool> {
    return isEditing.withLatestFrom(text.orEmpty.asDriver()) {
      isEditing, text -> Bool in

      if isEditing {
        return true
      } else {
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      }
    }

  }

  public var shouldHideClearButton: Driver<Bool> {
    return Driver.combineLatest(isEditing, text.orEmpty.asDriver()) {
      isEditing, text -> Bool in
      !(isEditing && !text.isEmpty)
    }
  }

}
