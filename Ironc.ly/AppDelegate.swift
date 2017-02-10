//
//  AppDelegate.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 1/23/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "viewController")
        self.window?.rootViewController = vc
        
//        let tabBarController: IROTabBarController = IROTabBarController()
//        let navigationController: UINavigationController = UINavigationController(rootViewController: tabBarController)
//        navigationController.navigationBar.isTranslucent = false
//        self.window?.rootViewController = navigationController
        
        self.window?.makeKeyAndVisible()
        
        return true
    }


}

