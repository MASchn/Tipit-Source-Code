//
//  TIPYourSubsCollectionViewCell.swift
//  Ironc.ly
//
//  Created by Maxwell Schneider on 9/10/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.


import UIKit

class TIPYourSubsCollectionViewCell: UICollectionViewCell {

//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.addSubview(subsBackground)
//        self.setUpYourSubConstraints()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(subsBackground)
        self.setUpYourSubConstraints()
        //self.contentView.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    lazy var subsBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "SubTriangle")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    func setUpYourSubConstraints(){
        subsBackground.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 1).isActive = true
        subsBackground.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0).isActive = true
        subsBackground.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0).isActive = true
        subsBackground.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
    
        }
    }



