import CoreLocation
import UIKit

protocol HasEnumNames {
  static var enumName: String { get }
  var fullName: String { get }
  var caseName: String { get }
}

extension HasEnumNames {
  public var fullName: String {
    return "\(Self.enumName).\(caseName)"
  }
}

extension UIAlertController.Style: HasEnumNames {
  public static let enumName = "UIAlertControllerStyle"

  public var caseName: String {
    switch self {
    case .actionSheet: return "actionSheet"
    case .alert: return "alert"
    }
  }
}

extension UIImagePickerController.SourceType: HasEnumNames {
  public static let enumName = "UIImagePickerControllerSourceType"

  public var caseName: String {
    switch self {
    case .camera: return "camera"
    case .photoLibrary: return "photoLibrary"
    case .savedPhotosAlbum: return "savedPhotosAlbum"
    }
  }
}

extension CLAuthorizationStatus: HasEnumNames {
  public static var enumName: String = "CLAuthorizationStatus"

  public var caseName: String {
    switch self {
    case .notDetermined: return "notDetermined"
    case .denied: return "denied"
    case .restricted: return "restricted"
    case .authorizedWhenInUse: return "authorizedWhenInUse"
    case .authorizedAlways: return "authorizedAlways"
    }
  }
}

extension UIApplication.State: HasEnumNames {
  public static var enumName: String = "UIApplicationState"

  public var caseName: String {
    switch self {
    case .active: return "active"
    case .inactive: return "inactive"
    case .background: return "background"
    }
  }
}
