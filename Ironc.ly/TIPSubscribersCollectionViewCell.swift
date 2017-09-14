//
//  TIPSubscribersCollectionViewCell.swift
//  Ironc.ly
//
//  Created by Maxwell Schneider on 9/10/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit


class TIPSubscribersCollectionViewCell: UICollectionViewCell {
    
    //    required init?(coder aDecoder: NSCoder) {
    //        super.init(coder: aDecoder)
    //        self.addSubview(subsBackground)
    //        self.setUpYourSubConstraints()
    //    }
    
    var searchUser: TIPSearchUser?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(subsBackground)
        self.addSubview(subsImage)
        self.setUpYourSubConstraints()
//        self.layoutSubviews()
        self.contentView.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    lazy var subsBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "SubscriberRibbon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var subsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.subsImage.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.subsImage.layer.cornerRadius = self.subsImage.frame.width / 2.0
        
    }

    
    func setUpYourSubConstraints(){
//        self.subsImage.layer.cornerRadius = self.subsImage.frame.width / 2.0

        //        subsBackground.topAnchor.constraint(equalTo: self.contentView.topAnchor , constant: 40).isActive = true
        subsBackground.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 1).isActive = true
        subsBackground.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0).isActive = true
        subsBackground.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0).isActive = true
        subsBackground.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        
        self.subsImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: -self.contentView.frame.size.height/5.3).isActive = true
        self.subsImage.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 1).isActive = true
        self.subsImage.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.68).isActive = true
        self.subsImage.heightAnchor.constraint(equalTo: self.subsImage.widthAnchor, multiplier: 1).isActive = true
        
    }
    
}
