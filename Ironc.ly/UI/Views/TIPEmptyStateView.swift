//
//  TIPEmptyStateView.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 7/1/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class TIPEmptyStateView: UIView {
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.iconImageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subtitleLabel)
        self.addSubview(self.actionButton)
        
        self.setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.actionButton.layer.cornerRadius = self.actionButton.frame.size.height / 2.0
    }
    
    // MARK: - Lazy Initialization
    lazy var iconImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 18.0, weight: UIFontWeightRegular)
        label.textColor = .iroMediumGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: UIFontWeightMedium)
        label.textColor = .iroDarkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var actionButton: TIPButton = {
        let button: TIPButton = TIPButton(style: .green)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        
        self.iconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 120.0).isActive = true
        self.iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.iconImageView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        self.iconImageView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        self.titleLabel.topAnchor.constraint(equalTo: self.iconImageView.bottomAnchor, constant: 20.0).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        self.subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 34.0).isActive = true
        self.subtitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.subtitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        self.actionButton.topAnchor.constraint(equalTo: self.subtitleLabel.bottomAnchor, constant: 34.0).isActive = true
        self.actionButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40.0).isActive = true
        self.actionButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -40.0).isActive = true
        self.actionButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }

}
