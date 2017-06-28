//
//  UIViewController+Style.swift
//  Ironc.ly
//

import UIKit

extension UIViewController {
    
    func configureTIPNavBar() {
        self.navigationController?.navigationBar.titleTextAttributes = TIPStyle.navBarTitleAttributes
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
}
