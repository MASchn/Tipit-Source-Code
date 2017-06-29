//
//  TIPFeedCollectionViewCell.swift
//  Ironc.ly
//

import UIKit

class TIPFeedCollectionViewCell: TIPStoryCollectionViewCell {
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUpConstraints()
        self.contentView.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with feedItem: TIPFeedItem) {
        self.userId = feedItem.userId
        self.usernameLabel.text = feedItem.username
        
        self.postImageView.alpha = 0.0
        UIImage.download(urlString: feedItem.storyImage) { (image: UIImage?) in
            self.postImageView.image = image
            UIView.animate(withDuration: 0.4, animations: {
                self.postImageView.alpha = 1.0
            })
        }
        
        UIImage.download(urlString: feedItem.profileImage, placeHolder: #imageLiteral(resourceName: "empty_profile"), completion: { (image: UIImage?) in
            self.profileImageView.image = image
        })
  
    }
    
    override func prepareForReuse() {
        self.profileImageView.image = nil
        self.postImageView.image = nil
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.gradient.frame = self.bounds
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2.0
        self.postImageView.layer.insertSublayer(self.gradient, at: 0)
    }
    
    // MARK: - Lazy Initialization
    lazy var gradient: CAGradientLayer = {
        let layer: CAGradientLayer = CAGradientLayer()
        let black: UIColor = UIColor(white: 0.0, alpha: 0.5)
        layer.colors = [black.cgColor, UIColor.clear.cgColor]
        layer.locations = [0.0, 0.2]
        return layer
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
        let hMargin: CGFloat = 15.0
        
        self.postImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.postImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.postImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.postImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        
        self.usernameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 18.0).isActive = true
        self.usernameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15.0).isActive = true
        self.usernameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.usernameLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
        
        self.profileImageView.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor, constant: 12.0).isActive = true
        self.profileImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: hMargin).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        self.profileButton.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.profileButton.bottomAnchor.constraint(equalTo: self.profileImageView.bottomAnchor).isActive = true
        self.profileButton.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.profileButton.rightAnchor.constraint(equalTo: self.usernameLabel.rightAnchor, constant: hMargin).isActive = true
    }
    
}
