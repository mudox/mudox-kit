import UIKit

import RxSwift

extension Mudoxive where Base: UIView {
  
  public static func animation(
    duration: TimeInterval,
    delay: TimeInterval = 0,
    options: UIViewAnimationOptions = [],
    setup: @escaping () -> Void = { },
    animations: @escaping () -> Void,
    completion: @escaping (Bool) -> Void = { _ in }
    )
    -> Observable<Void>
  {
    return Observable.create { observer in
      setup()
      UIView.animate(
        withDuration: duration,
        delay: delay,
        options: options,
        animations: animations,
        completion: {
          completion($0)
          if !$0 {
            observer.onError(CommonError.cancelled)
          } else {
            observer.onNext(())
            observer.onCompleted()
          }
      })
      return Disposables.create()
    }
  }
  
}
