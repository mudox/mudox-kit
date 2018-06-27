import Foundation


import JacKit
fileprivate let jack = Jack()

fileprivate var _allIdentifiers: Set<String> = []

public struct Activity {

  /// String identifier
  public let identifier: String

  /// Maximum count of instance allowed to run at the same time.
  /// Default: 1
  public let maxConcurrency: Int

  /// Log out each events of this kind of tasks.
  /// Used for debugging.
  /// Default: false
  public let isLoggingEnbaled: Bool

  /// Keep UIApplication.shared.isNetworkActivityIndicatorVisible to true
  /// when this kind of tasks are executing.
  /// Default: false
  public let isNetworkActivity: Bool

  public init(
    identifier: String,
    isNetworkActivity: Bool = false,
    maxConcurrency: Int = 1,
    isLoggingEnbaled: Bool = false
  )
  {
    self.maxConcurrency = maxConcurrency
    self.isLoggingEnbaled = isLoggingEnbaled
    self.isNetworkActivity = isNetworkActivity

    if !_allIdentifiers.insert(identifier).inserted {
      Jack.failure("""
        activity identifier "\(identifier)" has already been used, double check to \
        use a unique identifier"
        """)
    }

    self.identifier = identifier
  }

}

// MARK: - Hashable
extension Activity: Hashable {

  public static func == (lhs: Activity, rhs: Activity) -> Bool {
    return lhs.identifier == rhs.identifier
  }

  public var hashValue: Int {
    return identifier.hashValue
  }

}

// MARK: - Report Events
extension Activity {
  public func begin() {
    ActivityCenter.shared.addEvent(.begin(self))
  }

  public func next(_ element: Any?) {
    ActivityCenter.shared.addEvent(.next(self, element: element))
  }

  public func success(_ element: Any?) {
    ActivityCenter.shared.addEvent(.success(self, element: element))
  }

  public func error(_ error: Error) {
    ActivityCenter.shared.addEvent(.error(self, error: error))
  }

  public func end() {
    ActivityCenter.shared.addEvent(.end(self))
  }
}
