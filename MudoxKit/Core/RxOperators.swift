import Foundation
import RxSwift
import RxCocoa

extension ObservableType where E == Data {
  
  public func jsonDecode<T>(_ type: T.Type) -> Observable<T> where T: Decodable {
    return map {
      try JSONDecoder().decode(type.self, from: $0)
    }
  }
  
}
