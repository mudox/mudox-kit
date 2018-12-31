import UIKit

import RxCocoa
import RxSwift

import Eureka

import MudoxKit

import JacKit
private let jack = Jack("AlertVC")

private struct ViewModel {
  // outputs
  let tip: Driver<String>
  let showButtonEnabled: Driver<Bool>
  let showAlert: Driver<(style: UIAlertController.Style, layout: String)>

  init(
    showButtonTap: ControlEvent<Void>,
    style: Driver<UIAlertController.Style>,
    layout: Driver<String>
  ) {
    let parseResult = layout
      .distinctUntilChanged()
      .map { text -> (tip: String, layout: String?, error: Error?) in
        do {
          let alertLayout = try AlertLayout(layout: text)
          return (ViewModel.tip(for: alertLayout), text, nil)
        } catch {
          if text.isEmpty {
            return ("Try input `Title:Message->OK`", nil, error)
          } else {
            return (ViewModel.tip(for: error), nil, error)
          }
        }
      }

    tip = parseResult.map { $0.tip }

    let layout = parseResult
      .filter { $0.error == nil }
      .map { $0.layout! }

    let paramters = Driver.combineLatest(style, layout) {
      return (style: $0, layout: $1)
    }

    showAlert = showButtonTap.asDriver().withLatestFrom(paramters)

    showButtonEnabled = parseResult.map { $0.error == nil }
  }

  static func tip(for alertLayout: AlertLayout) -> String {
    func string(for style: UIAlertAction.Style) -> String {
      switch style {
      case .default: return "default"
      case .cancel: return "cancel"
      case .destructive: return "destructive"
      }
    }
    var tip = """
    Title: \(alertLayout.title ?? "n/a")
    Message: \(alertLayout.message ?? "n/a")
    Actions:
    """
    alertLayout.actions.forEach {
      tip.append("\n  - \($0.title) @\(string(for: $0.style))")
    }
    return tip
  }

  static func tip(for error: Error) -> String {
    return """
    Error: \(error)
    """
  }
}

class AlertVC: FormViewController {

  var disposeBag = DisposeBag()

  let layout = BehaviorRelay<String>(value: "")
  let style = BehaviorRelay<UIAlertController.Style>(value: .alert)

  fileprivate func setupForm() {

    form +++ Section("STYLE")

      <<< SegmentedRow<UIAlertController.Style>("style") {
        $0.options = [.alert, .actionSheet]
        $0.value = .alert
        $0.displayValueFor = { $0!.caseName.capitalized }
      }.onChange { [weak self] row in
        guard let ss = self else { return }
        if row.value == nil {
          jack.failure("Should not be nil")
        }
        ss.style.accept(row.value ?? .alert)
      }

    form +++ Section("LAYOUT")

      <<< TextAreaRow("layout") {
        $0.title = "Alert Layout Format"
        $0.placeholder = "Input layout string"
        $0.textAreaHeight = .dynamic(initialTextViewHeight: 80)
      }.cellUpdate { cell, _ in
        cell.textView.font = UIFont.systemFont(ofSize: 14)
      }.onChange { [weak self] row in
        guard let ss = self else { return }
        ss.layout.accept(row.value ?? "")
      }

    form +++ Section("PARSING RESULT")

      <<< TextAreaRow("tip") {
        $0.textAreaHeight = .dynamic(initialTextViewHeight: 140)
      }.cellUpdate { cell, _ in
        cell.textView.do { v in
          cell.isUserInteractionEnabled = false
          v.font = UIFont.systemFont(ofSize: 14)
          v.backgroundColor = .clear
        }
      }
  }

  func setupViewModel() {
    let showButton = navigationItem.rightBarButtonItem!

    let vm = ViewModel(
      showButtonTap: showButton.rx.tap,
      style: style.asDriver(),
      layout: layout.asDriver()
    )

    vm.showButtonEnabled.drive(showButton.rx.isEnabled).disposed(by: disposeBag)

    vm.tip.drive(
      onNext: { [weak self] text in
        guard let ss = self else { return }
        let row = ss.form.rowBy(tag: "tip") as! TextAreaRow
        row.value = text
        row.updateCell()
      }
    ).disposed(by: disposeBag)

    vm.showAlert.asObservable()
      .flatMap { param in
        return UIAlertController.mdx.present(layout: param.layout, style: param.style)
      }
      .subscribe(
        onNext: {
          jack.info("User select action: \($0)")
        }
      ).disposed(by: disposeBag)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.do { nav in
      nav.title = "Alert Layout"
      nav.rightBarButtonItem = UIBarButtonItem()
      nav.rightBarButtonItem?.title = "Show"
    }

    tableView!.do { tv in
      tv.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }

    setupForm()
    setupViewModel()
  }

}
