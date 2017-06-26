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
    var tabBarController: UITabBarController?
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        // Get current user
        if let user: IROUser = IROUser.fetchUserFromDefaults() {
            IROUser.currentUser = user
            print(user)
        }
        
        self.initializeFeed()
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func initializeFeed() {
        self.tabBarController = IROTabBarController()
        self.tabBarController?.delegate = self
        self.window?.rootViewController = tabBarController
        
        // Show log in scren if no current user
        if IROUser.currentUser == nil {
            let registerViewController: IROLoginViewController = IROLoginViewController()
            let navController: UINavigationController = UINavigationController(rootViewController: registerViewController)
            self.tabBarController?.present(navController, animated: false, completion: nil)
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if let token: String = url.query?.components(separatedBy: "=").last {
            let user: IROUser = IROUser(
                username: nil,
                email: nil,
                token: token,
                profileImage: nil
            )
            user.save()
            IROUser.currentUser = user
            self.initializeFeed()
        }
        return true
    }

}

extension AppDelegate: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 2 {
            let cameraViewController: IROCamViewController = IROCamViewController()
            self.tabBarController?.present(cameraViewController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
}

class IRONavigationController: UINavigationController {
    
    // MARK: - View Lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.configureForSignIn()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureForSignIn() {
        self.isNavigationBarHidden = false
        self.navigationBar.isTranslucent = true
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.tintColor = .white
        self.navigationBar.barStyle = .black
    }
    
}


