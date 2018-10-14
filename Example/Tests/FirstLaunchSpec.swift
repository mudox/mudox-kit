import XCTest

import Nimble
import Quick

import UIKit

@testable import MudoxKit

import JacKit

private let jack = Jack("Test.FirstLaunch")

class FirstLaunchSpec: QuickSpec { override func spec() {

  fdescribe("FirstLaunch") {
    
    afterEach {
      UserDefaults.standard.removeObject(forKey: FirstLaunch.lastLaunchReleaseKey)
    }

    it("of the application") {
      UserDefaults.standard.removeObject(forKey: FirstLaunch.lastLaunchReleaseKey)
      expect(FirstLaunch.resolve()) == FirstLaunch.Kind.application
    }

    it("of the current release") {
      UserDefaults.standard.set("", forKey: FirstLaunch.lastLaunchReleaseKey)
      expect(FirstLaunch.resolve()) == FirstLaunch.Kind.release
    }

    it("none") {
      UserDefaults.standard.set(FirstLaunch.currentRelease, forKey: FirstLaunch.lastLaunchReleaseKey)
      expect(FirstLaunch.resolve()) == FirstLaunch.Kind.none
    }

  }
  
} }
