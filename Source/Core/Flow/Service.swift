import Foundation

open class Service: ClassInstanceCounting {

  static var roster: [String: Int] = [:]

  public required init() {
    checkIn()
  }

  deinit {
    checkOut()
  }

}
