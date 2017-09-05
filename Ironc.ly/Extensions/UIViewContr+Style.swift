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
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navBarWithRoom").resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "rsz_backtomenuedited"), style: .plain, target: self, action: #selector(self.pullUpMainMenu))
    }
    
    
    func pullUpMainMenu() {
        let navController: UINavigationController = AppDelegate.shared.initializeMainViewController()
        self.tabBarController?.present(navController, animated: false, completion: nil)
    }
    
}

extension UINavigationBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 60.0)
    }
    
}
