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
        let profileViewController: IROProfileViewController = IROProfileViewController()
        let cameraViewController: IROCameraViewController = IROCameraViewController()
        let messagesViewController: IROMessagesViewController = IROMessagesViewController()
        let messagesViewController2: IROMessagesViewController = IROMessagesViewController()
        
        self.viewControllers = [feedViewController, profileViewController, cameraViewController, messagesViewController, messagesViewController2]
    }


}
