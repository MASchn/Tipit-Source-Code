//
//  TIPStoryCollectionViewCell.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 6/29/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class TIPStoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.postImageView)
        self.contentView.addSubview(self.blurView)
        self.contentView.addSubview(self.lockImageView)
        self.contentView.addSubview(self.profileButton)
        self.contentView.addSubview(self.usernameLabel)
        self.contentView.addSubview(self.profileImageView)
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedProfileButton(sender:)))
//        self.profileImageView.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lazy Initialization
    lazy var postImageView: UIImageView = {
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
    
    // Invisible button for hit area behind profile image view and username label to go to profile
    lazy var profileButton: UIButton = {
        let button: UIButton = UIButton()
        button.addTarget(self, action: #selector(self.tappedProfileButton(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    lazy var usernameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12.0, weight: UIFontWeightHeavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.postImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.postImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.postImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.postImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        
        self.blurView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.blurView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.blurView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.blurView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        
        self.lockImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.lockImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.lockImageView.widthAnchor.constraint(equalToConstant: self.contentView.bounds.size.width/3).isActive = true
        self.lockImageView.heightAnchor.constraint(equalTo: self.lockImageView.widthAnchor).isActive = true
    }
    
    func tappedProfileButton(sender: UIButton) {
        // Subclasses should override
    }
    
}
