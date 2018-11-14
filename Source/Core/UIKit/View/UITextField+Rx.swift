import UIKit

import RxSwift
import RxCocoa

import JacKit
fileprivate let jack = Jack()

extension Reactive where Base: UITextField {

  public var isPlaceHolderHidden: Driver<Bool> {
    
    return isEditing.withLatestFrom(text.orEmpty.asDriver()) {
      isEditing, text -> Bool in
      
      if isEditing {
        return true
      } else {
        return !text.trimmed().isEmpty
      }
    }
    
  }
  
}
