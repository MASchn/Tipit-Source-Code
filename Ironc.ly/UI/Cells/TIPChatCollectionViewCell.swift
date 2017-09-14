//
//  TIPChatCollectionViewCell.swift
//  Ironc.ly
//
//  Created by Alex Laptop on 7/27/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class TIPChatCollectionViewCell: UICollectionViewCell {
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    
    let lightBlu = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(self.bubbleView)
        self.addSubview(self.textView)
        self.addSubview(self.profileImageView)
        
        self.setUpConstraints()
        //self.contentView.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with feedItem: TIPFeedItem) {
        
        
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
    }
    
    
    // MARK: - Lazy Initialization
    lazy var bubbleView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        //view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var textView: UITextView = {
        let tv: UITextView = UITextView()
        tv.textColor = .black
        //tv.font = .systemFont(ofSize: 12.0, weight: UIFontWeightHeavy)
        //tv.font = UIFont.systemFont(ofSize: 16)
        tv.font = UIFont(name: AppDelegate.shared.fontName, size: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = imageView.frame.size.height/2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        
        bubbleRightAnchor = self.bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleRightAnchor?.isActive = true
        
        bubbleLeftAnchor = self.bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        
        self.bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        bubbleWidthAnchor = self.bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        self.textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        self.textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        self.textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        
        self.profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        self.profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
    }
    
}
