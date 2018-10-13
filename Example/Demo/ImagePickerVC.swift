import UIKit

import RxSwift
import RxCocoa

import Eureka

import MudoxKit

import JacKit
private let jack = Jack("ImagePickerVC")

class ImagePickerVC: FormViewController {

  var disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupForm()
  }
  
  var sourceType: UIImagePickerControllerSourceType {
    return form.values()["sourceType"] as! UIImagePickerControllerSourceType
  }

  fileprivate func setupForm() {

    form.inlineRowHideOptions = [.AnotherInlineRowIsShown, .FirstResponderChanges]
    
    form +++ Section("SETTINGS")

    <<< PickerInlineRow<UIImagePickerControllerSourceType>("sourceType") {
      $0.title = "Source Type"
      $0.options = [.camera, .photoLibrary, .savedPhotosAlbum].filter {
        UIImagePickerController.isSourceTypeAvailable($0)
      }
      $0.value = $0.options.first!
      $0.displayValueFor = { $0?.caseName ?? "nil" }
    }

    form +++ Section()

    <<< ButtonRow() {
      $0.title = "Present"
    }.onCellSelection { [weak self] cell, row in
      guard let ss = self else { return }
      MediaPicker
        .singleImageSelected(from: ss.sourceType, sourceViewController: ss)
        .subscribe(onSuccess: { print("image: \($0)") }, onError: { print("error: \($0)") })
        .disposed(by: ss.disposeBag)
    }
  }

}
