import UIKit

// MARK: Resume Animations

//  Technical Q&A QA1673:
//  https://developer.apple.com/library/content/qa/qa1673/_index.html#//apple_ref/doc/uid/DTS40010053

public extension CALayer {
  var isAnimationsPaused: Bool {
    return speed == 0.0
  }

  func pauseAnimations() {
    if !isAnimationsPaused {
      let currentTime = CACurrentMediaTime()
      let pausedTime = convertTime(currentTime, from: nil)
      speed = 0.0
      timeOffset = pausedTime
    }
  }

  func resumeAnimations() {
    let pausedTime = timeOffset
    speed = 1.0
    timeOffset = 0.0
    beginTime = 0.0
    let currentTime = CACurrentMediaTime()
    let timeSincePause = convertTime(currentTime, from: nil) - pausedTime
    beginTime = timeSincePause
  }

  func toggleAnimations() {
    if isAnimationsPaused {
      resumeAnimations()
    } else {
      pauseAnimations()
    }
  }
}

// MARK: - Persist Animations

private var _key = "CALayer.LayerPersistentHelper"

public extension CALayer {

  var shouldPersistAnimations: Bool {
    get {
      return animationStore != nil
    }
    set {
      if newValue {
        installAnimationStoreIfNeeded()
      } else {
        animationStore = nil
      }
    }
  }

}

private extension CALayer {

  private func installAnimationStoreIfNeeded() {
    guard animationStore == nil else { return }
    animationStore = CALayerAnimationStore(layer: self)
  }

  private var animationStore: CALayerAnimationStore? {
    get {
      return objc_getAssociatedObject(self, &_key) as? CALayerAnimationStore
    }
    set {
      objc_setAssociatedObject(self, &_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

}
