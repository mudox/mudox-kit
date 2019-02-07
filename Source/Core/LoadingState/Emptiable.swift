public protocol Emptiable {
  var isEmpty: Bool { get }
}

// swiftformat:disable consecutiveSpaces
// swiftlint:disable operator_usage_whitespace comma

extension String     : Emptiable { }
extension Array      : Emptiable { }
extension Dictionary : Emptiable { }
extension Set        : Emptiable { }

// swiftlint:enable operator_usage_whitespace comma
// swiftformat:enable consecutiveSpaces
