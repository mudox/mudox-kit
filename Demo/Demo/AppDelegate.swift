import UIKit

import JacKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    Jack.reportAppInfo()
    Jack.startReportingAppStateChanges()

    setupEurekaFormStyle()
    
    return true
  }

}
