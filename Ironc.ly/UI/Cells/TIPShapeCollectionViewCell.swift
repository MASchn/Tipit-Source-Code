//
//  TIPShapeCollectionViewCell.swift
//  Ironc.ly
//

import UIKit

class TIPShapeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.shapeImageView)
        
        self.setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.shapeImageView.image = nil
    }
    
    // MARK: - Lazy Initialization
    lazy var shapeImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.shapeImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.shapeImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.shapeImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.shapeImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
    }
    
}
