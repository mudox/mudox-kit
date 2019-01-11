import UIKit

class CALayerAnimationStore {
  
  private weak var layer: CALayer?
  
  init(layer: CALayer) {
    self.layer = layer
    addNotificationObservers()
  }
  
  deinit {
    removeNotificationObservers()
  }
  
  // MARK: - Persist Animations
  
  //  Persistent CoreAnimations extension
  //  https://stackoverflow.com/questions/7568567/restoring-animation-where-it-left-off-when-app-resumes-from-background
  
  private var animations: [String: CAAnimation] = [:]
  private var speed: Float = 0.0
  
  func persistAnimations() {
    guard let layer = self.layer else { return }
    
    animations.removeAll(keepingCapacity: true)
    layer.animationKeys()?.forEach { key in
      if let animation = layer.animation(forKey: key) {
        animations[key] = animation
      }
    }
  }
  
  func restoreAnimations() {
    guard let layer = self.layer else { return }
    
    animations.forEach { key, animation in
      layer.add(animation, forKey: key)
    }
    animations.removeAll(keepingCapacity: true)
  }
  
  // MARK: - Monitor App States Changes
  
  func addNotificationObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(willEnterForeground),
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(didEnterBackground),
      name: UIApplication.didEnterBackgroundNotification,
      object: nil
    )
  }
  
  func removeNotificationObservers() {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc
  func willEnterForeground() {
    guard let layer = self.layer else { return }
    
    restoreAnimations()
    // If layer was playing before background, resume it
    if speed == 1.0 {
      layer.resumeAnimations()
    }
  }
  
  @objc
  func didEnterBackground() {
    guard let layer = self.layer else { return }
    
    // In case layer was paused from outside, set speed to 1.0 to get all animations
    speed = layer.speed
    layer.speed = 1.0
    persistAnimations()
    // Restore original speed
    layer.speed = speed
    
    layer.pauseAnimations()
  }
  
}
