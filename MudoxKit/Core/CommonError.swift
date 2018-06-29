public enum CommonError: Error {
  case cancelled
  case casting(Any?, to: Any.Type)
  case weakRetain
  case error(String)
}
