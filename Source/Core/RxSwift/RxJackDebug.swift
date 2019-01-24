import RxCocoa
import RxSwift

import JacKit

private let symbol = "👀"

public extension ObservableType {

  func jack(
    _ id: String,
    //    trimOutput: Bool = false,
    file: String = #file,
    line: UInt = #line,
    function: String = #function
  )
    -> Observable<E>
  {
    let jack = Jack("RxJackDebug.\(id)").set(format: .bare)
    func log(_ text: String) {
      jack.debug("\(symbol) \(id)\(text)")
    }

    return asObservable().do(
      // swiftformat:disable consecutiveSpaces
      onNext:       { log(" next \($0)") },
      onError:      { log(" error \($0)") },
      onCompleted:  { log(" ============================== completed") },
      onSubscribe:  { log(" subscribe ------------------------------") },
      onSubscribed: { log(" ----------------------------- subscribed") },
      onDispose:    { log(" =============================== disposed") }
      // swiftformat:enable all
    )
  }

}

public extension SharedSequenceConvertibleType {

  func jack(
    _ id: String,
    //    trimOutput: Bool = false,
    file: String = #file,
    line: UInt = #line,
    function: String = #function
  )
    -> SharedSequence<SharingStrategy, E>
  {
    func log(_ text: String) {
      Jack("RxJackDebug.\(id)")
        .set(format: .bare)
        .set(level: .verbose)
        .debug("\(symbol) \(id)\(text)")
    }

    return `do`(
      // swiftformat:disable consecutiveSpaces
      onNext:       { log(" next \($0)") },
      onCompleted:  { log(" ============================== completed") },
      onSubscribe:  { log(" subscribe ------------------------------") },
      onSubscribed: { log(" ----------------------------- subscribed") },
      onDispose:    { log(" =============================== disposed") }
      // swiftformat:enable all
    )
  }

}
