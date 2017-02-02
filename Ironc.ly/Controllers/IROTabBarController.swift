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
        
        let searchViewController: IROSearchViewController = IROSearchViewController()
        searchViewController.tabBarItem = UITabBarItem(title: nil, image: searchImage, selectedImage: nil)

        let cameraViewController: IROCameraViewController = IROCameraViewController()
        cameraViewController.tabBarItem = UITabBarItem(title: nil, image: nil, selectedImage: nil)

        let messagesViewController: IROMessagesViewController = IROMessagesViewController()
        messagesViewController.tabBarItem = UITabBarItem(title: nil, image: messageImage, selectedImage: nil)
        
        let profileViewController: IROMessagesViewController = IROMessagesViewController()
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: profileImage, selectedImage: nil)
        
        self.viewControllers = [homeViewController, searchViewController, cameraViewController, messagesViewController, profileViewController]
        
    }


}
