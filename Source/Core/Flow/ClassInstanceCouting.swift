import Foundation

import JacKit

private let jack = Jack().set(format: .short)

protocol ClassInstanceCounting: AnyObject {

  /// - Important: DO NOT set this property.
  static var roster: [String: Int] { get set }

  /// Subclass can override this property to return a bigger number.
  static var maximumInstanceCount: Int { get }

}

extension ClassInstanceCounting {

  static var count: Int {
    return roster[String(describing: self), default: 0]
  }

  static var rosterDescription: String {
    if roster.isEmpty || roster.allSatisfy({ $1 == 0 }) {
      return "Roster: <Empty>"
    } else {
      return "Roster: " + roster
        .filter { $1 != 0 }
        .map { "\($0) (\($1))" }
        .joined(separator: ", ")
    }
  }

  var typeName: String {
    return String(describing: type(of: self))
  }

  func checkIn() {
    Self.roster[typeName, default: 0] += 1
    Self.validateRoster(typeName: typeName, context: "init")
  }

  func checkOut() {
    Self.roster[typeName, default: 0] -= 1
    Self.validateRoster(typeName: typeName, context: "deinit")
  }

  /// Subclass can override this property to return a bigger number.
  static var maximumInstanceCount: Int {
    return 1
  }

  static func validateRoster(typeName: String, context: String) {
    let logger = Jack(typeName).sub(context).set(format: .short)

    let count = roster[typeName]!
    let symbol = (context == "init") ? "🔥" : "💀"

    switch count {
    case 0 ... maximumInstanceCount:
      logger.debug("\(symbol) \(typeName) - \(rosterDescription)", format: .bare)
    default:
      logger.warn("""
      Invalid instance count: \(count)
      \(rosterDescription)
      """)
    }
  }

}
