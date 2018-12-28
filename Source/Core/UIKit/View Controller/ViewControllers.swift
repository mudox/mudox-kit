import UIKit

/// The general view controller factory. It provides basic methods to create or
/// load view controllers. User can extend it to create specific / view
/// controllers.
///
/// User can extension this class to add more specific view controller factory
/// methods into it.
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
  ///   - storyboard: The name of the storyboard file, without any leading path information.
  ///   - bundle: The bundle in which to search for the nib file. If you
  ///     specify nil, this method looks for the nib file in the main bundle.
  ///
  /// - Returns: The loaded view controller instance.
  public static func create<VC: UIViewController>(
    _: VC.Type,
    identifier: String? = nil,
    storyboard: String,
    bundle: Bundle? = nil
  )
    -> VC
  {
    let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
    if let id = identifier {
      return storyboard.instantiateViewController(withIdentifier: id) as! VC
    } else {
      return storyboard.instantiateInitialViewController() as! VC
    }
  }
  
  /// Load view controller from given storyboard as `UIViewController`.
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
  ///   - storyboard: The name of the storyboard file, without any leading path information.
  ///   - bundle: The bundle in which to search for the nib file. If you
  ///     specify nil, this method looks for the nib file in the main bundle.
  ///
  /// - Returns: The loaded view controller instance.
  public static func create(
    identifier: String? = nil,
    storyboard: String,
    bundle: Bundle? = nil
    )
    -> UIViewController
  {
    let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
    if let id = identifier {
      return storyboard.instantiateViewController(withIdentifier: id)
    } else {
      return storyboard.instantiateInitialViewController()!
    }
  }
  /// Load view controller from the given nib file.
  ///
  /// - Parameters:
  ///   - _: Type of the view controller.
  ///   - nib: File name of nib file.
  ///   - bundle: The bundle in which to search for the nib file. If you
  ///     specify nil, this method looks for the nib file in the main bundle.
  ///
  /// - Returns: The loaded view controller instance.
  public static func create<VC: UIViewController>(
    _: VC.Type,
    nib: String,
    bundle: Bundle? = nil
  )
    -> VC
  {
    let nib = UINib(nibName: nib, bundle: bundle)
    return nib.instantiate(withOwner: nil, options: [:]).first as! VC
  }
  
}
