//
//  UIViewController+Style.swift
//  Ironc.ly
//

import UIKit

extension UIViewController {
    
    func configureTIPNavBar() {
        self.navigationController?.navigationBar.titleTextAttributes = TIPStyle.navBarTitleAttributes
        //self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.tintColor = .clear
        self.navigationController?.navigationBar.barTintColor = .clear
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "newNavBar").resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "grid"), style: .plain, target: self, action: #selector(self.pullUpMainMenu))
    }
    
    func pullUpMainMenu() {
        let navController: UINavigationController = AppDelegate.shared.initializeMainViewController()
        self.tabBarController?.present(navController, animated: true, completion: nil)
    }
    
}
