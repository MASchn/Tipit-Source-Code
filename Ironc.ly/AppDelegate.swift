//
//  AppDelegate.swift
//  Ironc.ly
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
        if let user: TIPUser = TIPUser.fetchUserFromDefaults() {
            TIPUser.currentUser = user
            print(user)
        }
        
        self.initializeFeed()
        
        return true
    }
    
    func initializeFeed() {
        self.tabBarController = TIPTabBarController()
        self.tabBarController?.delegate = self
        self.window?.rootViewController = self.tabBarController
        self.window?.makeKeyAndVisible()
        
        // Show log in scren if no current user
        if TIPUser.currentUser == nil {
            let navController: UINavigationController = self.initializeSignInController()
            self.tabBarController?.present(navController, animated: false, completion: nil)
        }
    }
    
    func initializeSignInController() -> UINavigationController {
        let registerViewController: TIPLoginViewController = TIPLoginViewController()
        let navController: UINavigationController = UINavigationController(rootViewController: registerViewController)
        navController.isNavigationBarHidden = false
        navController.navigationBar.isTranslucent = true
        navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.tintColor = .white
        navController.navigationBar.barStyle = .black
        return navController
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if let token: String = url.query?.components(separatedBy: "=").last {
            let user: TIPUser = TIPUser(
                username: nil,
                email: nil,
                token: token,
                profileImage: nil
            )
            user.save()
            TIPUser.currentUser = user
            self.initializeFeed()
        }
        return true
    }

}

extension AppDelegate: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 2 {
            let cameraViewController: TIPCamViewController = TIPCamViewController()
            self.tabBarController?.present(cameraViewController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
}


