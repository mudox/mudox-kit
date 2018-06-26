import UIKit

extension Mudoxive where Base: UITableView {
  
  public func hideSeparatorsForEmptyDataset() {
    base.tableFooterView = UIView()
  }
  
}
