import UIKit

import JacKit
fileprivate let jack = Jack("MudoxKit.UIImage")

extension Mudoxive where Base: UIImage {
  /// Generate a image filled with a single color. Typically used for
  /// control background image.
  ///
  /// - Parameters:
  ///   - color: Color to fill.
  ///   - size: Defaults to 1x1 pixel
  public static func color(_ color :UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 1)
    defer { UIGraphicsEndImageContext() }
    
    color.setFill()
    UIRectFill(CGRect(origin: .zero, size: size))
    
    guard let image = UIGraphicsGetImageFromCurrentImageContext(), let cgImage = image.cgImage else {
      jack.func().failure("Failed, return an empty image")
      return UIImage()
    }
    
    return UIImage(cgImage: cgImage)
  }
}
