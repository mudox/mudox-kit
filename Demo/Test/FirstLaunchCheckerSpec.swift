import XCTest

import Nimble
import Quick

import UIKit

@testable import MudoxKit

import JacKit

private let jack = Jack("Test.FirstLaunchChecker")

class FirstLaunchCheckerSpec: QuickSpec { override func spec() {

  describe("FirstLaunchChecker") {
    
    let checker = FirstLaunchChecker.shared
    
    afterEach {
      UserDefaults.standard.removeObject(forKey: checker.lastLaunchReleaseKey)
      checker.kind = nil
    }

    it("of the application") {
      UserDefaults.standard.removeObject(forKey: checker.lastLaunchReleaseKey)
      expect(checker.check()) == FirstLaunchKind.application
    }

    it("of the current release") {
      UserDefaults.standard.set("", forKey: checker.lastLaunchReleaseKey)
      expect(checker.check()) == FirstLaunchKind.release
    }

    it("none") {
      UserDefaults.standard.set(checker.currentRelease, forKey: checker.lastLaunchReleaseKey)
      expect(checker.check()) == FirstLaunchKind.other
    }

  }
  
} }
