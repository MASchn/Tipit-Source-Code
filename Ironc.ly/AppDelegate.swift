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
    var navigationController: UINavigationController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
//        if let user: IROUser = IROUser.fetchUserFromDefaults() {
//            IROUser.currentUser = user
//            self.showFeed()
//        } else {
            self.showSignIn()
//        }
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func showFeed() {
        let tabBarController: IROTabBarController = IROTabBarController()
        tabBarController.delegate = self
        self.navigationController = UINavigationController(rootViewController: tabBarController)
        self.navigationController.navigationBar.isTranslucent = false
        self.window?.rootViewController = self.navigationController
    }
    
    func showSignIn() {
        let registerViewController: IROLoginViewController = IROLoginViewController()
        self.navigationController = IRONavigationController(rootViewController: registerViewController)
        self.navigationController.navigationBar.isTranslucent = true
        self.navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController.navigationBar.shadowImage = UIImage()
        self.navigationController.navigationBar.tintColor = .white
        self.window?.rootViewController = self.navigationController
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }

}

extension AppDelegate: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 2 {
            let cameraViewController: IROCamViewController = IROCamViewController()
            self.navigationController.present(cameraViewController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
}

class IRONavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


