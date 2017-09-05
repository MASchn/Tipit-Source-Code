//
//  TIPPullDownCollectionViewCell.swift
//  Ironc.ly
//
//  Created by Alex Laptop on 9/4/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class TIPPullDownCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.iconImage)
        
        self.contentView.layoutIfNeeded()
        self.setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //        self.storyImage.image = nil
        
    }
    
    
    // MARK: - Lazy Initialization
    lazy var iconImage: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.iconImage.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.iconImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.iconImage.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.6).isActive = true
        self.iconImage.widthAnchor.constraint(equalTo: self.iconImage.heightAnchor).isActive = true
    }
    
}
