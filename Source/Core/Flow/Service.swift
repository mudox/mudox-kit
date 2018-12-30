import Foundation

class Service: ClassInstanceCounting {

  static var roster: [String: Int] = [:]

  required init() {
    checkIn()
  }

  deinit {
    checkOut()
  }

}
