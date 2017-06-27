//
//  AppDelegate.swift
//  XMLTask
//
//  Created by Blake Lockley on 26/06/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import UIKit

//how often the app should retrieve new data
let reloadInterval: TimeInterval = 10
let dataURL = "http://aim.appdata.abc.net.au.edgesuite.net/data/abc/triplej/onair.xml"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    return true
  }

}
