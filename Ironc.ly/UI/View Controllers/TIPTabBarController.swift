//
//  TIPTabBarController.swift
//  Ironc.ly
//

import UIKit

class TIPTabBarController: UITabBarController {
    
    let homeImage: UIImage = #imageLiteral(resourceName: "home")
    let searchImage: UIImage = #imageLiteral(resourceName: "search")
    let cameraImage: UIImage = #imageLiteral(resourceName: "camera")
    let messageImage: UIImage = #imageLiteral(resourceName: "message")
    let profileImage: UIImage = #imageLiteral(resourceName: "profile")
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    lazy var splashView: TIPLoadingView = {
        let view: TIPLoadingView = TIPLoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    func addTopRoundedCornerToView(targetView:UIView?, desiredCurve:CGFloat?) {
        let offset:CGFloat =  targetView!.frame.width/desiredCurve!
        let bounds: CGRect = targetView!.bounds
        
        let rectBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y+bounds.size.height / 2, width: bounds.size.width, height: bounds.size.height / 2)
        
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        
        let ovalBounds = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset, height: bounds.size.height)
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        // Create the shape layer and set its path
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        
        // Set the newly created shape layer as the mask for the view's layer
        targetView!.layer.mask = maskLayer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UIApplication.shared.statusBarStyle = .default
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.tabBar.tintColor = UIColor.iroBlue
        //self.tabBar.barTintColor = UIColor(white: 0.0, alpha: 0.7)
        self.tabBar.barTintColor = .clear
        self.tabBar.isTranslucent = true
        
        self.tabBar.layer.backgroundColor = UIColor.black.cgColor
        self.view.backgroundColor = .clear
        self.tabBarController?.view.backgroundColor = .clear
        self.tabBar.backgroundImage = UIImage(named: "nothing")
        
        self.tabBar.isTranslucent = true
        self.tabBar.isHidden = true
        
        self.addTopRoundedCornerToView(targetView: self.tabBar, desiredCurve: 1.5)
        
        self.view.addSubview(self.splashView)
        self.splashView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.splashView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.splashView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.splashView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        //self.splashView.isHidden = false
        
        let homeViewController: TIPFeedViewController = TIPFeedViewController()
        homeViewController.tabBarItem = UITabBarItem(title: nil, image: self.homeImage.withRenderingMode(.alwaysOriginal), selectedImage: self.homeImage)
        homeViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: -5.0, right: 0.0)
        homeViewController.tabBarItem.tag = 0
        let homeNavController: UINavigationController = UINavigationController(rootViewController: homeViewController)
        
        let searchViewController: TIPSearchViewController = TIPSearchViewController()
        searchViewController.tabBarItem = UITabBarItem(title: nil, image: self.searchImage.withRenderingMode(.alwaysOriginal), selectedImage: self.searchImage)
        searchViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: -5.0, right: 0.0)
        searchViewController.tabBarItem.tag = 1
        let searchNavController: UINavigationController = UINavigationController(rootViewController: searchViewController)

        let cameraViewController: UIViewController = UIViewController()
        cameraViewController.tabBarItem = UITabBarItem(title: nil, image: self.cameraImage.withRenderingMode(.alwaysOriginal), selectedImage: self.cameraImage)
        cameraViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: -5.0, right: 0.0)
        cameraViewController.tabBarItem.tag = 2
        
        let messagesViewController: TIPMessagesViewController = TIPMessagesViewController()
        messagesViewController.tabBarItem = UITabBarItem(title: nil, image: self.messageImage.withRenderingMode(.alwaysOriginal), selectedImage: self.messageImage)
        messagesViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: -5.0, right: 0.0)
        messagesViewController.tabBarItem.tag = 3
        let messagesNavController: UINavigationController = UINavigationController(rootViewController: messagesViewController)
        
        let profileViewController: TIPPersonalProfileViewController = TIPPersonalProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: self.profileImage.withRenderingMode(.alwaysOriginal), selectedImage: self.profileImage)
        profileViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: -5.0, right: 0.0)
        profileViewController.tabBarItem.tag = 3
        let profileNavController: UINavigationController = UINavigationController(rootViewController: profileViewController)
    
//        let walletViewController: TIPWalletViewController = TIPWalletViewController()
//        profileViewController.tabBarItem = UITabBarItem(title: nil, image: self.profileImage.withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "coin_stack"))
//        profileViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: -5.0, right: 0.0)
//        profileViewController.tabBarItem.tag = 4
//        let walletNavController: UINavigationController = UINavigationController(rootViewController: walletViewController)
        
        self.viewControllers = [homeNavController, searchNavController, cameraViewController, messagesNavController ,profileNavController]
    }


}
