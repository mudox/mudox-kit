//
//  AppDelegate.swift
//  iOSKit
//
//  Created by mudox on 11/13/2017.
//  Copyright (c) 2017 mudox. All rights reserved.
//

import UIKit
import MudoxKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    The.app.mdx.startTrackingStateChanges()
    The.app.mdx.dumpBasicInfo()
    
    setupEurekaFormStyle()
    
    return true
  }

}
