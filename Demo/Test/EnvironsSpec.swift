import XCTest

import Nimble
import Quick

import JacKit
import MudoxKit

private let jack = Jack().set(format: .short)

class EnvironsSpec: QuickSpec { override func spec() {

  let boolKey = "testBooleanKey"
  let stringKey = "testStringKey"
  let tokensKey = "testTokensKey"

  afterEach {
    Environs.reset()
  }

  // MARK: Bool
  
  it("write read bool") {
    expect(Environs.boolean(forKey: boolKey)) == false

    Environs.set(boolean: true, forKey: boolKey)
    expect(Environs.boolean(forKey: boolKey)) == true

    Environs.set(boolean: false, forKey: boolKey)
    expect(Environs.boolean(forKey: boolKey)) == false
  }

  // MARK: String
  
  it("wirte read string") {
    expect(Environs.string(forKey: stringKey)).to(beNil())

    Environs.set(string: "test", forKey: stringKey)
    expect(Environs.string(forKey: stringKey)) == "test"

    Environs.set(string: "", forKey: stringKey)
    expect(Environs.string(forKey: stringKey)) == ""
  }
  
  // MARK: Tokens

  it("wirte read tokens") {
    expect(Environs.tokens(forKey: tokensKey)) == []

    Environs.set(tokens: ["swift", "objective-c", "c", "c++"], forKey: tokensKey)
    expect(Environs.tokens(forKey: tokensKey)) == ["swift", "objective-c", "c", "c++"]

    Environs.set(tokens: [], forKey: tokensKey)
    expect(Environs.tokens(forKey: tokensKey)) == []
  }
} }
