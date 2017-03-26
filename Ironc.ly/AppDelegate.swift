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
                
        let registerViewController: IRORegisterViewController = IRORegisterViewController()
        self.navigationController = UINavigationController(rootViewController: registerViewController)
        self.navigationController.navigationBar.isTranslucent = true
        self.navigationController.isNavigationBarHidden = true
        self.window?.rootViewController = self.navigationController
        
        self.window?.makeKeyAndVisible()
        
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


