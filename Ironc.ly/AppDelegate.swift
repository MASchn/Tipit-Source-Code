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
    var navigationController: IRONavigationController?
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        
        self.showSignIn()
        
        if let user: IROUser = IROUser.fetchUserFromDefaults() {
            IROUser.currentUser = user
            self.showFeed(animated: false)
        }
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func showFeed(animated: Bool) {
        if self.navigationController == nil {
            self.showSignIn()
        }
        let tabBarController: IROTabBarController = IROTabBarController()
        tabBarController.delegate = self
        self.navigationController?.configureForTabBar()
        self.navigationController?.pushViewController(tabBarController, animated: animated)
    }
    
    func showSignIn() {
        let registerViewController: IROLoginViewController = IROLoginViewController()
        self.navigationController = IRONavigationController(rootViewController: registerViewController)
        self.window?.rootViewController = self.navigationController
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
            self.showFeed(animated: true)
        }
        return true
    }

}

extension AppDelegate: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 2 {
            let cameraViewController: IROCamViewController = IROCamViewController()
            self.navigationController?.present(cameraViewController, animated: true, completion: nil)
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
        self.isNavigationBarHidden = false // Need this because some of the tab bar view controllers set it true
        self.navigationBar.isTranslucent = true
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.tintColor = .white
        self.navigationBar.barStyle = .black
    }
    
    func configureForTabBar() {
        self.isNavigationBarHidden = false // Need this because some of the tab bar view controllers set it true
        self.navigationBar.isTranslucent = false
        self.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationBar.shadowImage = nil
        self.navigationBar.barStyle = .default
    }
    
}


