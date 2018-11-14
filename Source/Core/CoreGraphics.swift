
import Foundation

extension CGSize {

  func aspectFit(into size: CGSize) -> CGSize {
    let factor = min(size.width / width, size.height / height)
    return CGSize(width: width * factor, height: height * factor)
  }

  func aspectFill(into size: CGSize) -> CGSize {
    let factor = max(size.width / width, size.height / height)
    return CGSize(width: width * factor, height: height * factor)
  }

}
