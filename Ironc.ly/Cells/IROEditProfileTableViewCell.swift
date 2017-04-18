//
//  IROEditProfileTableViewCell.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 4/18/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROEditProfileTableViewCell: UITableViewCell {
    
    // MARK: - View Lifecycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.textView)
        
        self.setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lazy Initialization
    lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: UIFontWeightBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView: UITextView = UITextView()
        textView.font = .systemFont(ofSize: 15.0, weight: UIFontWeightRegular)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15.0).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        
        self.textView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor).isActive = true
        self.textView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.textView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.textView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }

}
