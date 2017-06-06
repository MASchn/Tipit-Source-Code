//
//  IROCoinTableViewCell.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 6/6/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit
import StoreKit

class IROCoinsFormatter {
    
    class func coins(productIdentifier: String) -> String {
        let id: NSString = productIdentifier as NSString
        let coins: String = id.components(separatedBy: ".").last!
        return coins
    }
    
}

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
    
    func configure(with product: SKProduct) {
        self.priceFormatter.locale = product.priceLocale
        let coins: String = IROCoinsFormatter.coins(productIdentifier: product.productIdentifier)
        let price: String = self.priceFormatter.string(from: product.price)!
        
        self.coinsLabel.text = coins
        self.priceButton.setTitle(price, for: .normal)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.priceButton.layer.cornerRadius = self.priceButton.frame.size.height / 2.0
    }
    
    // MARK: - Lazy Initialization
    lazy var coinsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15.0, weight: UIFontWeightBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = .iroGreen
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: UIFontWeightMedium)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var priceFormatter: NumberFormatter = {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        return formatter
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
        self.priceButton.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
    }

}
