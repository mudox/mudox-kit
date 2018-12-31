import Foundation

import Nimble
import Quick
import XCTest

@testable import MudoxKit

class NSCodingCodableSpec: QuickSpec { override func spec() {
  
  it("does not smoke") {
    let cc = NSCodingCodable(UIColor.red)
    let data = try! JSONEncoder().encode(cc)
    _ = try! JSONDecoder().decode(NSCodingCodable<UIColor>.self, from: data)
  }

} }
