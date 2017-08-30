//
//  TIPFilterCollectionViewCell.swift
//  Ironc.ly
//
//  Created by Maxwell Schneider on 8/29/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class TIPFilterCollectionViewCell: UICollectionViewCell {
    
    var finishedImage: UIImage? = nil

// MARK: - Properties
override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.contentView.addSubview(self.filterImageView)
    
     self.contentView.layoutIfNeeded()
    self.setUpConstraints()
}

required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
}
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.filterImageView.image = nil
        
    }


// MARK: - Lazy Initialization
lazy var filterImageView: UIImageView = {
    let imageView: UIImageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
}()


// MARK: - Autolayout
func setUpConstraints() {
    self.filterImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
    self.filterImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    self.filterImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
    self.filterImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
    
}


}
