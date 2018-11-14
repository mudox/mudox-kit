import Eureka


extension Eureka.PresentationMode {
  
  public static func show(_ viewControllerFactory: @escaping () -> VCType) -> PresentationMode {
    return PresentationMode.show(controllerProvider: .callback(builder: viewControllerFactory), onDismiss: nil)
  }
  
  public static func presentModally(_ viewControllerFactory: @escaping () -> VCType) -> PresentationMode {
    return PresentationMode.presentModally(controllerProvider: .callback(builder: viewControllerFactory), onDismiss: nil)
  }
  
}
