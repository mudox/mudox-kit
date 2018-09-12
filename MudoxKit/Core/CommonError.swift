public enum CommonError: Error {
  // Operation cancelled
  case cancelled
  // Casting failed
  case casting(Any?, to: Any.Type)
  // Weakly referenced instance in block got released
  case nilWeakReference(String)
  // General (uncategorized) error case
  case error(String)
}
