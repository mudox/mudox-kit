import UIKit

/// The general view controller factory. It provides basic methods to create or
/// load view controllers. User can extend it to create specific / view
/// controllers.
public enum ViewControllers {

  /// Load view controller from given storyboard.
  ///
  /// Load initial view controller of a storyboard in the main bundle.
  /// ```
  /// ViewControllers.create(storyboard: "main")
  /// ```
  ///
  /// Load view controller with given identifier from a storyboard in the main bundle.
  /// ```
  /// ViewControllers.create(
  ///   identifier: "login",
  ///   storyboard: "main"
  /// )
  /// ```
  ///
  /// Load view controller with given identifier from a storyboard in a given bundle.
  /// ```
  /// let bundle = Bundle(for: SomeClass.self)
  /// ViewControllers.create(
  ///   identifier: "login",
  ///   storyboard: "main",
  ///   bundle: bundle
  /// )
  /// ```
  ///
  /// - Parameters:
  ///   - _: Type of the view controller.
  ///   - identifier: Identifier of the view controller in the storyboard, if
  ///     nil, the initial view controller is loaded.
  ///   - storyboard: The name of the nib file, without any leading path information.
  ///   - bundle: The bundle in which to search for the nib file. If you
  ///     specify nil, this method looks for the nib file in the main bundle.
  ///
  /// - Returns: The loaded view controller instance.
  public func create<ViewController: UIViewController>(
    _: ViewController.Type,
    identifier: String? = nil,
    storyboard: String,
    bundle: Bundle? = nil
  )
    -> ViewController?
  {
    let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
    if let id = identifier {
      return storyboard.instantiateViewController(withIdentifier: id) as? ViewController
    } else {
      return storyboard.instantiateInitialViewController() as? ViewController
    }
  }

  
  /// Load view controller from the given nib file.
  ///
  /// - Parameters:
  ///   - _: Type of the view controller.
  ///   - nibName: File name of nib file.
  ///   - bundle: The bundle in which to search for the nib file. If you
  ///     specify nil, this method looks for the nib file in the main bundle.
  ///
  /// - Returns: The loaded view controller instance.
  public func create<ViewController: UIViewController>(
    _: ViewController.Type,
    nibName: String,
    bundle: Bundle? = nil
  )
    -> ViewController?
  {
    let nib = UINib(nibName: nibName, bundle: bundle)
    return nib.instantiate(withOwner: nil, options: [:]).first as? ViewController
  }
}
