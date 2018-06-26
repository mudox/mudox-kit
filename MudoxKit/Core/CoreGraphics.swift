
import Foundation

extension CGSize {
  
  func aspectFit(to size: CGSize) -> CGSize {
    let wFactor = size.width / width
    let hFactor = size.height / height
    let factor = min(wFactor, hFactor)
    return CGSize(width: width * factor, height: height * factor)
  }

  func aspectFill(to size: CGSize) -> CGSize {
    let wFactor = size.width / width
    let hFactor = size.height / height
    let factor = max(wFactor, hFactor)
    return CGSize(width: width * factor, height: height * factor)
  }
  
}

extension CGRect {
  
  public static func square(size: CGFloat) -> CGRect {
    return CGRect(origin: .zero, size: CGSize(width: size, height: size))
  }
  
  public static func box(width: CGFloat, height: CGFloat) -> CGRect {
    return CGRect(origin: .zero, size: CGSize(width: width, height: height))
  }
  
}
