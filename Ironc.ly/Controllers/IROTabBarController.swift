//
//  IROTabBarController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 1/23/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROTabBarController: UITabBarController {
    
    let homeImage: UIImage = UIImage(cgImage: UIImage(named: "home")!.cgImage!, scale: 3.0, orientation: .up).withRenderingMode(.alwaysOriginal)
    let searchImage: UIImage = UIImage(cgImage: UIImage(named: "search")!.cgImage!, scale: 3.0, orientation: .up).withRenderingMode(.alwaysOriginal)
    let messageImage: UIImage = UIImage(cgImage: UIImage(named: "message")!.cgImage!, scale: 3.0, orientation: .up).withRenderingMode(.alwaysOriginal)
    let profileImage: UIImage = UIImage(cgImage: UIImage(named: "profile")!.cgImage!, scale: 3.0, orientation: .up).withRenderingMode(.alwaysOriginal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = UIColor(white: 0.0, alpha: 0.7)
        
        let homeViewController: IROFeedViewController = IROFeedViewController()
        homeViewController.tabBarItem = UITabBarItem(title: nil, image: homeImage, selectedImage: nil)
        homeViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: -5.0, right: 0.0)
        
        let searchViewController: IROSearchViewController = IROSearchViewController()
        searchViewController.tabBarItem = UITabBarItem(title: nil, image: searchImage, selectedImage: nil)
        searchViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: -5.0, right: 0.0)

        let cameraViewController: IROCameraViewController = IROCameraViewController()
        cameraViewController.tabBarItem = UITabBarItem(title: nil, image: nil, selectedImage: nil)
        cameraViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: -5.0, right: 0.0)

        let messagesViewController: IROMessagesViewController = IROMessagesViewController()
        messagesViewController.tabBarItem = UITabBarItem(title: nil, image: messageImage, selectedImage: nil)
        messagesViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: -5.0, right: 0.0)
        
        let profileViewController: IROProfileViewController = IROProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: profileImage, selectedImage: nil)
        profileViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: -5.0, right: 0.0)
        
        self.viewControllers = [homeViewController, searchViewController, cameraViewController, messagesViewController, profileViewController]
        
    }


}
