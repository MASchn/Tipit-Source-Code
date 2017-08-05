//
//  TIPPagingTabViewController.swift
//  Ironc.ly
//

import UIKit

class TIPPagingTabViewController: UIPageViewController {
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let homeImage: UIImage = #imageLiteral(resourceName: "home")
        let searchImage: UIImage = #imageLiteral(resourceName: "search")
        let cameraImage: UIImage = #imageLiteral(resourceName: "camera")
        let profileImage: UIImage = #imageLiteral(resourceName: "profile")
        
        let feed: UITabBarItem = UITabBarItem(title: nil, image: homeImage.withRenderingMode(.alwaysOriginal), selectedImage: homeImage)
        let search: UITabBarItem = UITabBarItem(title: nil, image: searchImage.withRenderingMode(.alwaysOriginal), selectedImage: searchImage)
        let camera: UITabBarItem = UITabBarItem(title: nil, image: cameraImage.withRenderingMode(.alwaysOriginal), selectedImage: cameraImage)
        let profile: UITabBarItem = UITabBarItem(title: nil, image: profileImage.withRenderingMode(.alwaysOriginal), selectedImage: profileImage)
        
        self.tabBar.items = [feed, search, camera, profile]
        
        self.view.addSubview(self.tabBar)
        self.setUpConstraints()
    }
    
    // MARK: - Lazy Initialization
    lazy var tabBar: UITabBar = {
        let tabBar: UITabBar = UITabBar()
        tabBar.tintColor = .iroBlue
        tabBar.barTintColor = UIColor(white: 0.0, alpha: 0.7)
        return tabBar
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.tabBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tabBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tabBar.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tabBar.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
    

}
