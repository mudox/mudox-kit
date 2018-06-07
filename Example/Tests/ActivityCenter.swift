import XCTest

import Quick
import Nimble
import RxNimble

import RxTest
import RxBlocking

import RxSwift
@testable import MudoxKit

enum Activity {
  case networkRequest
  case nonNetworkRequest
}

extension Activity: ActivityType {
  
  var isNetworkActivity: Bool {
    switch self {
    case .networkRequest: return true
    case .nonNetworkRequest: return false
    }
  }
  
}

class ActivityCenterSpec: QuickSpec {
  override func spec() {

    describe("ActivityCenter") {

      var center: ActivityCenter<Activity>!

      beforeEach {
        center = ActivityCenter<Activity>()
      }

      it("networkActivity") {
        var active = false
        _ = center.networkActivity.drive(onNext: {
          active = $0
        })
        center.start(.networkRequest)
        expect(active).toEventually(equal(true))
      }
      

    } // describe("ActivityCenter")

  } // spec()
} // class Spec

