//
//  IROTabBarController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 1/23/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let feedViewController: IROFeedViewController = IROFeedViewController()
        feedViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "icon_search"), selectedImage: nil)
        
        let profileViewController: IROProfileViewController = IROProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "icon_profile"), selectedImage: nil)

        let cameraViewController: IROCameraViewController = IROCameraViewController()
        cameraViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "icon_profile"), selectedImage: nil)

        let messagesViewController: IROMessagesViewController = IROMessagesViewController()
        messagesViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "icon_message"), selectedImage: nil)
        
        let messagesViewController2: IROMessagesViewController = IROMessagesViewController()
        messagesViewController2.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "icon_settings"), selectedImage: nil)
        
        self.viewControllers = [feedViewController, profileViewController, cameraViewController, messagesViewController, messagesViewController2]
        
    }


}
