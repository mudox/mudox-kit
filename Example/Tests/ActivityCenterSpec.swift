import XCTest

import Quick
import Nimble

import RxTest
import RxBlocking
import RxNimble

import RxSwift
import RxCocoa

@testable import MudoxKit

class ActivityCenterSpec: QuickSpec {
  override func spec() {

    describe("Activity") {

      // FIXME: throwAssertion() can not capture expection
      xit("reject duplicate identifers") {
        expect { () -> Void in
          _ = Activity(identifier: "a")
          _ = Activity(identifier: "a")
        }.to(throwAssertion())
      }

    }

    describe("ActivityCenter") {

      var center: ActivityCenter!

      beforeEach {
        center = ActivityCenter.shared
        center.reset()
      }

      it("track network activities") {
        let a1 = Activity(identifier: "networkRequest", isNetworkActivity: true)
        let a2 = Activity(identifier: "anotherNetworkRequest", isNetworkActivity: true)
        let b = Activity(identifier: "nonNetworkRequest", isNetworkActivity: false)
        
        _ = center.networkActivity.drive(onNext: {
          print("network active - \($0)")
        })

        // a1 network task started
        a1.begin()
        expect(center.networkActivity.asObservable()).first == true

        // network is active as long as at least 1 netowrk task is active
        a2.begin()
        expect(center.networkActivity.asObservable()).first == true
        a2.end()
        expect(center.networkActivity.asObservable()).first == true

        // other events do not affect the result
        a1.complete()
        expect(center.networkActivity.asObservable()).first == true
        a1.next(1)
        expect(center.networkActivity.asObservable()).first == true

        // a1 quit, no network request is active
        a1.end()
        expect(center.networkActivity.asObservable()).first == false

        // b is not a network task, should not affect the result
        b.begin()
        expect(center.networkActivity.asObservable()).first == false
      }

      // FIXME: throwAssertion() can not capture expection
      xit("monitor activity concurrency") {
        let a = Activity(identifier: "networkRequest", maxConcurrency: 1)
        expect{ () -> Void in
          a.begin()
          a.begin()
        }.to(throwAssertion())
      }

    } // describe("ActivityCenter")

  } // spec()
} // class Spec
