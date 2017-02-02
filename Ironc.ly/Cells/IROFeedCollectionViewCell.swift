//
//  IROFeedCollectionViewCell.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 1/23/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROFeedCollectionViewCell: UICollectionViewCell {
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        self.contentView.addSubview(self.postImageView)
        self.contentView.addSubview(self.userImageView)
        
        self.setUpConstraints()
        self.contentView.layoutIfNeeded()
        
        self.userImageView.layer.cornerRadius = self.userImageView.frame.width / 2.0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with post: IROPost) {
        self.userImageView.image = post.user.profileImage
        self.postImageView.image = post.contentImage
    }
    
    // MARK: - Lazy Initialization
    lazy var userImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.backgroundColor = UIColor.green
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var postImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var favoriteImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var favoriteLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var privateImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var privateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.postImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.postImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.postImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.postImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        
        self.userImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15.0).isActive = true
        self.userImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15.0).isActive = true
        self.userImageView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.userImageView.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
}
