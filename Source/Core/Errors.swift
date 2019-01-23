public enum Errors: Error {
  // Operation cancelled
  case cancelled
  
  // Casting failed
  case casting(Any?, to: Any.Type)
  
  // Weakly referenced instance in block got released
  case weakReference(String)
  
  // General (uncategorized) error case
  case error(String)
}
