public func with<T: AnyObject>(_ target: T, apply: (T) throws -> ()) rethrows {
  try apply(target)
}

//public func with<T: AnyObject, Result>(_ target: T, evaluate: (T) throws -> Result) rethrows -> Result {
//  return try evaluate(target)
//}
