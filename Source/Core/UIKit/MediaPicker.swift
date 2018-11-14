import UIKit

import RxSwift
import RxCocoa

import JacKit
fileprivate let jack = Jack()

public struct MediaPicker {

  /// Pick a image using `UIImagePickerController`, using the default media type `kUTTypeImage`.
  ///
  /// - Parameters:
  ///   - sourceType: The type of picker interface to be displayed by the controller.
  ///   - presenter: The view controller to present the picker controller, if nil
  ///     try using the root view controller. A __error__ may be thrown if the presenter
  ///     is already preseting a view controller.
  ///   - animated: Pass true to animate the presentation; otherwise, pass false.
  ///   - configure: Put custom configuration to the picker controller in it if any.
  ///     Setting the __delegate__ property in this block has no effect.
  /// - Returns: `Single<UIImage>`.
  public static func singleImageSelected(
    from sourceType: UIImagePickerController.SourceType,
    sourceViewController: UIViewController,
    animated: Bool = true,
    configure: ((UIImagePickerController) throws -> Void)? = nil
  )
    -> Single<UIImage>
  {
    /*
     *
     * Step 1 - Create and configure a UIImagePickerController
     *
     */
    let controller = UIImagePickerController()
    controller.sourceType = sourceType

    do {
      try configure?(controller)
    } catch {
      return Single.error(error)
    }

    if controller.delegate != nil {
      Jack.failure("user should not set the delegate property in the `configure` closure")
    }

    /*
     *
     * Step 2 - Create delegate and assign it to the controller
     *
     */
    let delegate = ImagePickerDelegate(for: controller)
    controller.delegate = delegate

    /*
     *
     * Step 3 - Present the controller
     *
     */
    sourceViewController.present(controller, animated: animated)

    return delegate.imageSubject
      .take(1)
      .asSingle()
      .do(onDispose: { [weak controller] in
        delegate.retainSelf = nil
        controller?.mdx.dismiss(animated: animated)
      })
  }

}

class ImagePickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  weak var controller: UIImagePickerController!

  let imageSubject = PublishSubject<UIImage>()
  
  var retainSelf: ImagePickerDelegate? = nil

  init(for controller: UIImagePickerController) {
    super.init()
    self.controller = controller
    self.retainSelf = self
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    imageSubject.onError(CommonError.cancelled)
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
    guard let controller = controller else {
      #if DEBUG
        fatalError("property `controller` should not be nil")
      #else
        imageSubject.onError(CommonError.error("weak property `controller` is nil"))
        return
      #endif
    }

    do {
      let key = controller.allowsEditing
        ? UIImagePickerController.InfoKey.editedImage
        : UIImagePickerController.InfoKey.originalImage
      let image = try cast(info[key.rawValue], to: UIImage.self)
      imageSubject.onNext(image)
      imageSubject.onCompleted()
    } catch {
      imageSubject.onError(error)
    }
  }

  deinit {
    #if DEBUG
      jack.debug("Bye!")
    #endif
  }
}
