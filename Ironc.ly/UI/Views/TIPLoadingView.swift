//
//  TIPLoadingView.swift
//  Ironc.ly
//
//  Created by Alex Laptop on 8/17/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class TIPLoadingView: UIView {
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.iconImageView)
        
        self.backgroundColor = UIColor(red: 191/255, green: 255/255, blue: 231/255, alpha: 1.0)
        //R: 191 G: 255 B: 231
        self.setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lazy Initialization
    lazy var iconImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    
    // MARK: - Autolayout
    func setUpConstraints() {
        
        self.iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.iconImageView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        self.iconImageView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        
    }
    
}
