//
//  AppDelegate.swift
//  Ironc.ly
//

import UIKit
import FBSDKCoreKit
import SendBirdSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarController: UITabBarController?
    let sendBirdAppID = "EB96DFC6-5314-4901-9CDF-5791FDEE157A"
    var fontSize: CGFloat = 18.0
    
    let fontName = "scratchy"
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //UIApplication.shared.statusBarStyle = .
        
        SBDMain.initWithApplicationId(sendBirdAppID)
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        //self.window?.backgroundColor = .clear
        
        let screen = UIScreen.main
        self.fontSize = screen.bounds.size.height * (18.0 / 568.0)
        if (screen.bounds.size.height < 500) {
            self.fontSize = screen.bounds.size.height * (18.0 / 480.0)
        }
        
        // Get current user
        if let user: TIPUser = TIPUser.fetchUserFromDefaults() {
            TIPUser.currentUser = user
            print(user)
        }
        
//        if let currentUserID = TIPUser.currentUser?.userId {
//            print("SSSSSSSS CURRENT USER ID: \(currentUserID)")
//            
//            SBDMain.connect(withUserId: currentUserID) { (user, error) in
//                
//                if error != nil {
//                    print("ERROR CONNECTING CURRENT USER: \(error)")
//                    return
//                }
//                
//                print("USER: \(user)")
//                print("USER CONNECTION STATUS: \(user?.connectionStatus)")
//            }
//        }
        
        self.initializeFeed()
        
        //UINavigationBar.appearance().setBackgroundImage(#imageLiteral(resourceName: "register_button"), for: .default)
        
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
        } else {
            let navController: UINavigationController = self.initializeMainViewController()
            self.tabBarController?.present(navController, animated: false, completion: nil)
            TIPAPIClient.connectToSendBird()
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
    
    func initializeMainViewController() -> UINavigationController {
        let mainViewController: TIPMainPageViewController = TIPMainPageViewController()
        let navController: UINavigationController = UINavigationController(rootViewController: mainViewController)
        navController.isNavigationBarHidden = true
        //navController.navigationBar.isTranslucent = true
        //navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //navController.navigationBar.shadowImage = UIImage()
        //navController.navigationBar.tintColor = .white
        //navController.navigationBar.barStyle = .black
        return navController
    }
    
    func pullUpCamera() {
        let cameraViewController: TIPCamViewController = TIPCamViewController()
        self.tabBarController?.present(cameraViewController, animated: true, completion: nil)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
//        if let token: String = url.query?.components(separatedBy: "=").last {
//            let user: TIPUser = TIPUser(
//                username: nil,
//                email: nil,
//                token: token,
//                profileImage: nil
//            )
//            user.save()
//            TIPUser.currentUser = user
//            self.initializeFeed()
//        }
        return handled
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


