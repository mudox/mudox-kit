
import Foundation

extension CGPoint {

  /// A `CGPoint` with equal x and y value.
  ///
  ///     view.frame = CGRect(origin: .of(10), size: .of(80)
  ///
  static func of(_ value: CGFloat) -> CGPoint {
    return CGPoint(x: value, y: value)
  }

  /// A `CGPoint` with specified x and y value.
  ///
  ///     view.frame = CGRect(origin: .of(10, -30), size: .of(80, 120)
  ///
  static func of(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
    return CGPoint(x: x, y: y)
  }

}

extension CGSize {

  /// A `CGSize` with equal width and height.
  ///
  ///     view.frame = CGRect(origin: .zero, size: .of(80)
  ///
  static func of(_ size: CGFloat) -> CGSize {
    return CGSize(width: size, height: size)
  }

  /// A `CGSize` with specified width and height.
  ///
  ///     view.frame = CGRect(origin: .zero, size: .of(80, 120)
  ///
  static func of(_ width: CGFloat, _ height: CGFloat) -> CGSize {
    return CGSize(width: width, height: height)
  }

  func aspectFit(into size: CGSize) -> CGSize {
    let wFactor = size.width / width
    let hFactor = size.height / height
    let factor = min(wFactor, hFactor)
    return CGSize(width: width * factor, height: height * factor)
  }

  func aspectFill(into size: CGSize) -> CGSize {
    let wFactor = size.width / width
    let hFactor = size.height / height
    let factor = max(wFactor, hFactor)
    return CGSize(width: width * factor, height: height * factor)
  }

}

extension CGRect {

  /// A `CGRect` with `.zero` origin and equal width and height.
  ///
  ///     view.frame = .of(10.5)
  ///
  /// - Returns: A sqaure with `.zero` origin.
  public static func of(_ size: CGFloat) -> CGRect {
    return CGRect(origin: .zero, size: .of(size))
  }

  /// A `CGRect` with `.zero` origin and specified width and height.
  ///
  ///     view.frame = .of(230, 20)
  ///
  /// - Returns: A box with `.zero` origin.
  public static func of(_ width: CGFloat, _ height: CGFloat) -> CGRect {
    return CGRect(origin: .zero, size: .of(width, height))
  }

}
