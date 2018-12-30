import Foundation

import RxSwift

open class ViewModel: ClassInstanceCounting {
  
  public var disposeBag = DisposeBag()
  
  // MARK: - InstanceCounting
  
  static var roster: [String: Int] = [:]
  
  public init() { checkIn() }

  deinit { checkOut() }

}
