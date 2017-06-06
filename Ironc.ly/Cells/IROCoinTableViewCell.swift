//
//  IROCoinTableViewCell.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 6/6/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROCoinTableViewCell: UITableViewCell {

    // MARK: - View Lifecycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.coinsLabel)
        self.contentView.addSubview(self.priceButton)
        
        self.setUpConstraints()
        self.contentView.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with product: IROProduct) {
        self.coinsLabel.text = "\(product.coins)"
        self.priceButton.setTitle(product.price, for: .normal)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.priceButton.layer.cornerRadius = self.priceButton.frame.size.height / 2.0
    }
    
    // MARK: - Lazy Initialization
    lazy var coinsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: UIFontWeightMedium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = .iroGreen
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: UIFontWeightMedium)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        let hMargin: CGFloat = 20.0
        
        self.coinsLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.coinsLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.coinsLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: hMargin).isActive = true
        
        self.priceButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.priceButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -hMargin).isActive = true
        self.priceButton.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
    }

}
