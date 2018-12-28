import UIKit

import RxCocoa
import RxSwift

import JacKit

private let jack = Jack().set(format: .short)

public extension Flow {

  public enum Stage {

    case window(UIWindow)
    case viewController(UIViewController)

    public var window: UIWindow! {
      if case let Flow.Stage.window(window) = self {
        return window
      } else {
        return nil
      }
    }

    public var viewController: UIViewController! {
      if case let Flow.Stage.viewController(viewController) = self {
        return viewController
      } else {
        return nil
      }
    }

    public var navigationController: UINavigationController! {
      if case let Flow.Stage.viewController(vc) = self {
        return vc as? UINavigationController
      } else {
        return nil
      }
    }

    public var tabBarController: UITabBarController! {
      if case let Flow.Stage.viewController(vc) = self {
        return vc as? UITabBarController
      } else {
        return nil
      }
    }

  }

}
