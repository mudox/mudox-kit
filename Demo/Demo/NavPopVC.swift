import UIKit
import Eureka
import MudoxKit

class NavPopVC: FormViewController {
  var popStyle: NavigationController.PopStyle {
    get {
      let vc = The.window.rootViewController as! NavigationController
      return vc.popStyle
    }
    set {
      let vc = The.window.rootViewController as! NavigationController
      vc.popStyle = newValue
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    form +++ Section("Chooose a Interactive pop styles")
    
    let options: [NavigationController.PopStyle] = [
        .none, .inherit, .edge, .anywhere
    ]

    for style in options {
      form.last! <<< ButtonRowOf<NavigationController.PopStyle>() {
        let fullName = String(describing: style)
        $0.title = String(fullName.dropFirst(44))
        $0.value = style
      }.cellSetup { cell, row in
        cell.selectionStyle = .default
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      }.cellUpdate { [weak self] cell, row in
        guard let ss = self else { return }
        if ss.popStyle == row.value! {
          cell.textLabel?.textColor = .black
        } else {
          cell.textLabel?.textColor = .lightGray
        }
      }.onCellSelection { [weak self] cell, row in
        guard let ss = self else { return }
        ss.popStyle = row.value!
        ss.tableView.reloadData()
      }
    } // for
  }
  
}

