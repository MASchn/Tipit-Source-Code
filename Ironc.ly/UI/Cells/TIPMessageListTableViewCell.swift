//
//  TIPMessageListTableViewCell.swift
//  Ironc.ly
//
//  Created by Alex Laptop on 7/26/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import Foundation
import UIKit

class TIPMessageListTableViewCell: UITableViewCell {
    
    var feedItem: TIPFeedItem?
    
    // MARK: - View Lifecycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.profileImageView)
        self.contentView.addSubview(self.usernameLabel)
        
        self.setUpConstraints()
        self.contentView.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with feedItem: TIPFeedItem) {
        self.feedItem = feedItem
        
        self.usernameLabel.text = feedItem.username
        
        guard let user: TIPUser = TIPUser.currentUser else { return }
        
        UIImage.download(urlString: feedItem.profileImageURL, placeHolder: #imageLiteral(resourceName: "empty_profile"), completion: { (image: UIImage?) in
            self.profileImageView.image = image
        })
        
    }
    
    
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2.0
    }
    
    // MARK: - Lazy Initialization
    lazy var profileImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var usernameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12.0, weight: UIFontWeightHeavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: - Autolayout
    func setUpConstraints() {
        let hMargin: CGFloat = 20.0
        
        self.profileImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        self.profileImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0).isActive = true
        self.profileImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        self.profileImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive = true
        self.profileImageView.widthAnchor.constraint(equalTo: self.profileImageView.heightAnchor).isActive = true
        
        self.usernameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5.0).isActive = true
        self.usernameLabel.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 0).isActive = true
        self.usernameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0).isActive = true
        
    }
    
}
