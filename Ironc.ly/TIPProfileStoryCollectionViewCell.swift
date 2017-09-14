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
        self.contentView.addSubview(self.blurView)
        self.contentView.addSubview(self.lockImageView)
        
        self.contentView.layoutIfNeeded()
        self.setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    // MARK: - Lazy Initialization
    lazy var storyImage: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    lazy var lockImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "lock")
        //imageView.contentMode = .scaleAspectFill
        //imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.storyImage.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.storyImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.storyImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.storyImage.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        
        self.blurView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.blurView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.blurView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.blurView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        self.lockImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.lockImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.lockImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.4).isActive = true
        self.lockImageView.heightAnchor.constraint(equalTo: self.lockImageView.widthAnchor).isActive = true
        
    }
    
    
}

