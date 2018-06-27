import Foundation

extension Bool {
  public mutating func toggle() {
    self = !self
  }
}

public enum TaskState<Step, Result> {
  case begin(Step)
  case progress(Double)
  case success(Result)
  case error(Error)
}
