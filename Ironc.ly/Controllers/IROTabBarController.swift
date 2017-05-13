//
//  IROTabBarController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 1/23/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROTabBarController: UITabBarController {
    
    let homeImage: UIImage = UIImage(cgImage: #imageLiteral(resourceName: "home").cgImage!, scale: 3.0, orientation: .up)
    let privateImage: UIImage = UIImage(cgImage: #imageLiteral(resourceName: "private").cgImage!, scale: 3.0, orientation: .up)
    let cameraImage: UIImage = UIImage(cgImage: #imageLiteral(resourceName: "camera").cgImage!, scale: 4.0, orientation: .up).withRenderingMode(.alwaysOriginal)
    let messageImage: UIImage = UIImage(cgImage: #imageLiteral(resourceName: "message").cgImage!, scale: 3.0, orientation: .up)
    let profileImage: UIImage = UIImage(cgImage: #imageLiteral(resourceName: "profile").cgImage!, scale: 3.0, orientation: .up)
    
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

        let messagesViewController: IROMessagesViewController = IROMessagesViewController()
        messagesViewController.tabBarItem = UITabBarItem(title: nil, image: self.messageImage.withRenderingMode(.alwaysOriginal), selectedImage: self.messageImage)
        messagesViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: -5.0, right: 0.0)
        messagesViewController.tabBarItem.tag = 3
        
        let profileViewController: IROProfileViewController = IROProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: self.profileImage.withRenderingMode(.alwaysOriginal), selectedImage: self.profileImage)
        profileViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: -5.0, right: 0.0)
        profileViewController.tabBarItem.tag = 4
        
        self.viewControllers = [homeNavController, searchNavController, cameraViewController, messagesViewController, profileViewController]
        
    }


}
