//
//  TIPProfileStoryCollectionViewCell.swift
//  Ironc.ly
//
//  Created by Maxwell Schneider on 8/30/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

//
//  TIPFilterCollectionViewCell.swift
//  Ironc.ly
//
//  Created by Maxwell Schneider on 8/29/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class TIPProfileStoryCollectionViewCell: UICollectionViewCell {
    
//    var storyImage: UIImage? = nil
    
    // MARK: - Properties
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.storyImage)
        
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
    lazy var storyImage: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.storyImage.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.storyImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.storyImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.storyImage.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        
    }
    
    
}

