import XCTest

import Quick
import Nimble
import RxNimble

import RxTest
import RxBlocking

import RxSwift
@testable import MudoxKit

struct TestDecodable: Decodable, Equatable {
  let name: String
  let age: Int
}

class RxOperatorsSpec: QuickSpec {
  override func spec() {
    
    describe("RxOperators") {

      it("jsonDecode") {
        let seq = Observable<Data>.just("""
        {
          "name": "mudox",
          "age": 100
        }
        """.data(using: .utf8)!)

        let decoded = seq.jsonDecode(TestDecodable.self)

        let expected = TestDecodable(name: "mudox", age: 100)
        expect(decoded).last == expected
      }

    } // describe("RxOperators")

  } // spec()
} // class Spec

