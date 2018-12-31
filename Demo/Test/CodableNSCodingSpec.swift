import Foundation

import Nimble
import Quick
import XCTest

@testable import MudoxKit

class CodableNSCodingSpec: QuickSpec { override func spec() {
  
  it("does not smoke") {
    let cc = CodableNSCoding(UIColor.red)
    let data = try! JSONEncoder().encode(cc)
    _ = try! JSONDecoder().decode(CodableNSCoding<UIColor>.self, from: data)
  }

} }
