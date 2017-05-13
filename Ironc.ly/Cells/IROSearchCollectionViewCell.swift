//
//  IROSearchCollectionViewCell.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 3/17/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

protocol IROSearchCollectionViewCellDelegate: class {
    func tappedFollowButton(with userId: String)
    func tappedSubscribeButton(with userId: String)
}

enum IROSearchSection: Int {
    case follow = 0
    case subscribe = 1
}

class IROSearchCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    var userId: String?
    weak var delegate: IROSearchCollectionViewCellDelegate?
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.profileImageView)
        self.contentView.addSubview(self.usernameLabel)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.followButton)
        self.contentView.addSubview(self.subscribeButton)
        
        self.setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.profileImageView.image = nil
        self.subscribeButton.isHidden = true
        self.followButton.isHidden = true
    }
    
    func configure(with searchUser: IROSearchUser, section: IROSearchSection) {
        self.userId = searchUser.userId
        
        self.usernameLabel.text = searchUser.username
        self.nameLabel.text = searchUser.name
        
        self.followButton.isHidden = section == .subscribe
        self.subscribeButton.isHidden = section == .follow
        
        if let url: String = searchUser.profileImageURL {
            UIImage.download(urlString: url, placeHolder: #imageLiteral(resourceName: "empty_profile"), completion: { (image: UIImage?) in
                self.profileImageView.image = image
            })
        } else {
            self.profileImageView.image = #imageLiteral(resourceName: "empty_profile")
        }
        
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2.0
        self.followButton.layer.cornerRadius = self.followButton.frame.size.height / 2.0
        self.subscribeButton.layer.cornerRadius = self.subscribeButton.frame.size.height / 2.0
    }
    
    // MARK: - Lazy Initialization
    lazy var profileImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var usernameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12.0, weight: UIFontWeightBold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12.0, weight: UIFontWeightMedium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var followButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = .iroGreen
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: UIFontWeightMedium)
        button.setTitle("Follow", for: .normal)
        button.setTitle("Unfollow", for: .selected)
        button.addTarget(self, action: #selector(self.tappedFollowButton), for: .touchUpInside)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    lazy var subscribeButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = .iroGreen
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: UIFontWeightMedium)
        button.setTitle("Subscribe", for: .normal)
        button.setTitle("Unsubscribe", for: .selected)
        button.addTarget(self, action: #selector(self.tappedSubscribeButton), for: .touchUpInside)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
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
        
        self.followButton.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: verticalMargin).isActive = true
        self.followButton.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.followButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.followButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        self.subscribeButton.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: verticalMargin).isActive = true
        self.subscribeButton.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.subscribeButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.subscribeButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
    }
    
    // MARK: - Actions
    func tappedFollowButton() {
        if let userId: String = self.userId {
            self.delegate?.tappedFollowButton(with: userId)
        }
    }
    
    func tappedSubscribeButton() {
        if let userId: String = self.userId {
            self.delegate?.tappedSubscribeButton(with: userId)
        }
    }
    
}
