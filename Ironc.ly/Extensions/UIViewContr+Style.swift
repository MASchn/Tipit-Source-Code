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
        
        let screenHeight = UIScreen.main.bounds.size.width
        
        return CGSize(width: UIScreen.main.bounds.size.width, height: screenHeight/6)
    }
    
}

class TriangleView : UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        context.closePath()
        
        //context.setFillColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.60)
        context.fillPath()
    }
}
