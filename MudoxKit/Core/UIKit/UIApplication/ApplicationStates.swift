import UIKit

import JacKit

fileprivate let jack = Jack()

internal let applicationStatesAndDescriptions: [Notification.Name: String] = [
  // launching state
  .UIApplicationDidFinishLaunching: "Application did finish launching",

  // active state
  .UIApplicationDidBecomeActive: "Application did become active",
  .UIApplicationWillResignActive: "Application will resign active",

  // background state
  .UIApplicationDidEnterBackground: "Application did enter background",
  .UIApplicationWillEnterForeground: "Application will enter foreground",

  // terminat state
  .UIApplicationWillTerminate: "Application will terminate",

  // memory warning
  .UIApplicationDidReceiveMemoryWarning: "Application did receive memory warning",

  // significant time changing
  .UIApplicationSignificantTimeChange: "Application siginificant time change",

  // status bar
  .UIApplicationWillChangeStatusBarOrientation: "Application will change status bar orientation",
  .UIApplicationDidChangeStatusBarOrientation: "Application did change status bar orientation",
  .UIApplicationWillChangeStatusBarFrame: "Application will change status bar frame",
  .UIApplicationDidChangeStatusBarFrame: "Application did change status bar frame",

  // background refresh
  .UIApplicationBackgroundRefreshStatusDidChange: "Application did change background refresh status",

  // protected data
  .UIApplicationProtectedDataWillBecomeUnavailable: "Application prototected data will become unavailable",
  .UIApplicationProtectedDataDidBecomeAvailable: "Application protected data did become available",
]
