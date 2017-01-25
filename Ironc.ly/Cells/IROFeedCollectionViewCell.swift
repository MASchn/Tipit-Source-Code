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
        
        self.contentView.layer.borderColor = UIColor.white.cgColor
        self.contentView.layer.borderWidth = 5.0
        self.contentView.backgroundColor = UIColor.blue
        
        self.contentView.addSubview(self.postImageView)
        self.contentView.addSubview(self.userImageView)
        
        self.setUpConstraints()
        self.contentView.layoutIfNeeded()
        
        self.userImageView.layer.cornerRadius = self.userImageView.frame.width / 2.0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lazy Initialization
    lazy var userImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.backgroundColor = UIColor.green
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var postImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.backgroundColor = UIColor.blue
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
        let margins: UILayoutGuide = self.contentView.layoutMarginsGuide
        
        self.userImageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 15.0).isActive = true
        self.userImageView.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 15.0).isActive = true
        self.userImageView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.userImageView.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
}
