//
//  IROTabBarController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 1/23/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROTabBarController: UITabBarController {
    
    let homeImage: UIImage = #imageLiteral(resourceName: "home")
    let privateImage: UIImage = #imageLiteral(resourceName: "private")
    let cameraImage: UIImage = #imageLiteral(resourceName: "camera")
    let profileImage: UIImage = #imageLiteral(resourceName: "profile")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = .iroGreen
        self.tabBar.barTintColor = UIColor(white: 0.0, alpha: 0.7)
        
        let homeViewController: IROFeedViewController = IROFeedViewController()
        homeViewController.tabBarItem = UITabBarItem(title: nil, image: self.homeImage.withRenderingMode(.alwaysOriginal), selectedImage: self.homeImage)
        homeViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: -5.0, right: 0.0)
        homeViewController.tabBarItem.tag = 0
        let homeNavController: UINavigationController = UINavigationController(rootViewController: homeViewController)
        homeNavController.navigationBar.isTranslucent = false
        
        let searchViewController: IROSearchViewController = IROSearchViewController()
        searchViewController.tabBarItem = UITabBarItem(title: nil, image: self.privateImage.withRenderingMode(.alwaysOriginal), selectedImage: self.privateImage)
        searchViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: -5.0, right: 0.0)
        searchViewController.tabBarItem.tag = 1
        let searchNavController: UINavigationController = UINavigationController(rootViewController: searchViewController)
        searchNavController.navigationBar.isTranslucent = false

        let cameraViewController: UIViewController = UIViewController()
        cameraViewController.tabBarItem = UITabBarItem(title: nil, image: self.cameraImage.withRenderingMode(.alwaysOriginal), selectedImage: self.cameraImage)
        cameraViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: -5.0, right: 0.0)
        cameraViewController.tabBarItem.tag = 2
        
        let profileViewController: IROProfileViewController = IROProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: self.profileImage.withRenderingMode(.alwaysOriginal), selectedImage: self.profileImage)
        profileViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: -5.0, right: 0.0)
        profileViewController.tabBarItem.tag = 3
        
        self.viewControllers = [homeNavController, searchNavController, cameraViewController, profileViewController]
    }


}
