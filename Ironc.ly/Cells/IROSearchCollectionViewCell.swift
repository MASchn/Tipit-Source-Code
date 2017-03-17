//
//  IROSearchCollectionViewCell.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 3/17/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROSearchCollectionViewCell: UICollectionViewCell {
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.profileImageView)
        self.contentView.addSubview(self.usernameLabel)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.subscribeButton)
        
        self.setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2.0
        self.subscribeButton.layer.cornerRadius = self.subscribeButton.frame.size.height / 2.0
    }
    
    // MARK: - Lazy Initialization
    lazy var profileImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "user1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var usernameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        label.textAlignment = .center
        label.text = "hannajmarie"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .gray
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 12.0)
        label.textAlignment = .center
        label.text = "Hanna Julie Marie"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var subscribeButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = IROConstants.green
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 12.0)
        button.setTitle("Subscribe", for: .normal)
        button.setTitle("Unsubscribe", for: .selected)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        let verticalMargin: CGFloat = 10.0
        
        self.profileImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.profileImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        self.usernameLabel.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: verticalMargin).isActive = true
        self.usernameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.usernameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.usernameLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        self.nameLabel.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor).isActive = true
        self.nameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.nameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.nameLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        self.subscribeButton.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: verticalMargin).isActive = true
        self.subscribeButton.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.subscribeButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.subscribeButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
    }
    
}
