import Foundation

import JacKit
fileprivate let jack = Jack()

private let _assetsBundleName = "mbp"

final class MBPResources {

  private static var _assetsBundle: Bundle = {
    let frameworkBundle = Bundle(for: MBPResources.self)
    let assetsBundleURL = frameworkBundle.url(forResource: _assetsBundleName, withExtension: "bundle")!
    return Bundle(url: assetsBundleURL)!
  }()

  // MARK: - Images

  static var checkMarkImage: UIImage {
    if let image = UIImage(named: "Check37", in: _assetsBundle, compatibleWith: nil) {
      return image
    } else {
      Jack.failure("Loading image `Check37` failed")
      return UIImage()
    }
  }

  static var crossMarkImage: UIImage {
    if let image = UIImage(named: "Cross37", in: _assetsBundle, compatibleWith: nil) {
      return image
    } else {
      Jack.failure("Loading image `Cross37` failed")
      return UIImage()
    }
  }

}
