//
//  TIPSearchCollectionViewCell.swift
//  Ironc.ly
//

import UIKit

protocol TIPSearchCollectionViewCellDelegate: class {
    func searchCellDidSelectUser(user: TIPSearchUser)
}

class TIPSearchCollectionViewCell: TIPStoryCollectionViewCell {
    
    var user: TIPSearchUser?
    weak var delegate: TIPSearchCollectionViewCellDelegate?
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        self.setUpConstraints()
        self.contentView.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.profileImageView.image = nil
        self.postImageView.image = nil
    }
    
    func configure(with searchUser: TIPSearchUser) {
        self.user = searchUser
        
        self.usernameLabel.text = searchUser.username
        
//        UIImage.download(urlString: searchUser.profileImageURL, placeHolder: #imageLiteral(resourceName: "empty_profile"), completion: { [unowned self] (image: UIImage?) in
//            self.profileImageView.image = image
//        })
        
        if let profileURL = searchUser.profileImageURL {
            self.profileImageView.loadImageUsingCacheFromUrlString(urlString: profileURL, placeHolder: UIImage(named: "empty_profile")!) {}
        } else {
            self.profileImageView.loadImageUsingCacheFromUrlString(urlString: "no image", placeHolder: UIImage(named: "empty_profile")!) {}
        }
        
//        UIImage.download(urlString: searchUser.mediaItemURL, completion: { [unowned self] (image: UIImage?) in
//            self.postImageView.image = image
//        })
        
        if let mediaURL = searchUser.mediaItemURL {
            self.postImageView.loadImageUsingCacheFromUrlString(urlString: mediaURL, placeHolder: nil) {}
        } else {
            self.postImageView.loadImageUsingCacheFromUrlString(urlString: "no image", placeHolder: nil) {}
        }
        
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2.0
    }
    
    // MARK: - Autolayout
    override func setUpConstraints() {
        super.setUpConstraints()
        
        let hMargin: CGFloat = 10.0
        let vMargin: CGFloat = 10.0
        
        self.usernameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: vMargin).isActive = true
        self.usernameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: hMargin).isActive = true
        self.usernameLabel.rightAnchor.constraint(lessThanOrEqualTo: self.contentView.rightAnchor, constant: -hMargin).isActive = true
        self.usernameLabel.rightAnchor.constraint(greaterThanOrEqualTo: self.profileImageView.rightAnchor, constant: hMargin).isActive = true
        
        self.profileImageView.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor, constant: vMargin).isActive = true
        self.profileImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: hMargin).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        self.profileButton.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.profileButton.bottomAnchor.constraint(equalTo: self.profileImageView.bottomAnchor).isActive = true
        self.profileButton.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.profileButton.rightAnchor.constraint(equalTo: self.usernameLabel.rightAnchor, constant: hMargin).isActive = true
    }
    
    override func tappedProfileButton(sender: UIButton) {
        if let user: TIPSearchUser = self.user {
            self.delegate?.searchCellDidSelectUser(user: user)
        }
    }

    
}
