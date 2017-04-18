//
//  IROEditProfileViewController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 4/17/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROEditProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationController?.isNavigationBarHidden = false
    }

}
