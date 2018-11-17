import UIKit

import JacKit

fileprivate let jack = Jack()

internal let applicationStatesAndDescriptions: [Notification.Name: String] = [
  // launching state
  UIApplication.didFinishLaunchingNotification
  : "Application did finish launching",

  // active state
  UIApplication.didBecomeActiveNotification
  : "Application did become active",
  UIApplication.willResignActiveNotification
  : "Application will resign active",

  // background state
  UIApplication.didEnterBackgroundNotification
  : "Application did enter background",
  UIApplication.willEnterForegroundNotification
  : "Application will enter foreground",

  // terminat state
  UIApplication.willTerminateNotification
  : "Application will terminate",

  // memory warning
  UIApplication.didReceiveMemoryWarningNotification
  : "Application did receive memory warning",

  // significant time changing
  UIApplication.significantTimeChangeNotification
  : "Application siginificant time change",

  // status bar
  UIApplication.willChangeStatusBarOrientationNotification
  : "Application will change status bar orientation",
  UIApplication.didChangeStatusBarOrientationNotification
  : "Application did change status bar orientation",
  UIApplication.willChangeStatusBarFrameNotification
  : "Application will change status bar frame",
  UIApplication.didChangeStatusBarFrameNotification
  : "Application did change status bar frame",

  // background refresh
  UIApplication.backgroundRefreshStatusDidChangeNotification
  : "Application did change background refresh status",

  // protected data
  UIApplication.protectedDataWillBecomeUnavailableNotification
  : "Application prototected data will become unavailable",
  UIApplication.protectedDataDidBecomeAvailableNotification
  : "Application protected data did become available",
]
