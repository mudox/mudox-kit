import Foundation

import RxSwift

open class ViewModel: ClassInstanceCounting {
  
  /// Constant bag which only release subscription(s) on view controller
  /// deallocation.
  ///
  /// If you want to release subscription(s) within lifetime of the view
  /// controller, define `var` bags with more meaningful names.
  ///
  /// ```
  /// // Define dedicated bag for given subscriptions.
  /// var imageTasksBag = DisposeBag()
  /// // Release subscription explicitly.
  /// imageTasksBag = DisposeBag()
  /// ```
  public let bag = DisposeBag()
  
  // MARK: - InstanceCounting
  
  static var roster: [String: Int] = [:]
  
  public init() { checkIn() }

  deinit { checkOut() }

}
