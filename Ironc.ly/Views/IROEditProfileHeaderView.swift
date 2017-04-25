//
//  IROEditProfileHeaderView.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 4/24/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

protocol IROEditProfileHeaderViewDelegate: class {
    func tappedChangeProfileButton()
    func tappedChangeBackgroundButton()
}

class IROEditProfileHeaderView: UIView {
    
    // MARK: - Properties
    weak var delegate: IROEditProfileHeaderViewDelegate?

    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .groupTableViewBackground
        
        self.addSubview(self.changeProfileButton)
        self.addSubview(self.profileImageView)
        self.addSubview(self.changeProfileLabel)
        
        self.addSubview(self.changeBackgroundButton)
        self.addSubview(self.backgroundImageView)
        self.addSubview(self.changeBackgroundLabel)
        
        self.setUpConstraints()
        
        self.layoutIfNeeded()
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2.0
        self.backgroundImageView.layer.cornerRadius = self.backgroundImageView.frame.size.height / 2.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lazy Initialization
    lazy var profileImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var changeProfileLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor(red: 0/255.0, green: 118/255.0, blue: 255/255.0, alpha: 1.0)
        label.font = .systemFont(ofSize: 15.0)
        label.textAlignment = .center
        label.text = "change profile pic"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var changeProfileButton: UIButton = {
        let button: UIButton = UIButton()
        button.addTarget(self, action: #selector(self.tappedChangeProfileButton(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var changeBackgroundLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor(red: 0/255.0, green: 118/255.0, blue: 255/255.0, alpha: 1.0)
        label.font = .systemFont(ofSize: 15.0)
        label.textAlignment = .center
        label.text = "change background"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var changeBackgroundButton: UIButton = {
        let button: UIButton = UIButton()
        button.addTarget(self, action: #selector(self.tappedChangeBackgroundButton(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.changeProfileButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.changeProfileButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.changeProfileButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.changeProfileButton.rightAnchor.constraint(equalTo: self.changeBackgroundButton.leftAnchor).isActive = true
        self.changeProfileButton.widthAnchor.constraint(equalTo: self.changeBackgroundButton.widthAnchor).isActive = true
        
        self.changeBackgroundButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.changeBackgroundButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.changeBackgroundButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        self.profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.0).isActive = true
        self.profileImageView.centerXAnchor.constraint(equalTo: self.changeProfileButton.centerXAnchor).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 45.0).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        
        self.backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.0).isActive = true
        self.backgroundImageView.centerXAnchor.constraint(equalTo: self.changeBackgroundButton.centerXAnchor).isActive = true
        self.backgroundImageView.widthAnchor.constraint(equalToConstant: 45.0).isActive = true
        self.backgroundImageView.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        
        self.changeProfileLabel.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 10.0).isActive = true
        self.changeProfileLabel.leftAnchor.constraint(equalTo: self.changeProfileButton.leftAnchor).isActive = true
        self.changeProfileLabel.rightAnchor.constraint(equalTo: self.changeProfileButton.rightAnchor).isActive = true
        self.changeProfileLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        self.changeBackgroundLabel.topAnchor.constraint(equalTo: self.backgroundImageView.bottomAnchor, constant: 10.0).isActive = true
        self.changeBackgroundLabel.leftAnchor.constraint(equalTo: self.changeBackgroundButton.leftAnchor).isActive = true
        self.changeBackgroundLabel.rightAnchor.constraint(equalTo: self.changeBackgroundButton.rightAnchor).isActive = true
        self.changeBackgroundLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
    }
    
    // MARK: - Actions
    func tappedChangeProfileButton(sender: UIButton) {
        self.delegate?.tappedChangeProfileButton()
    }
    
    func tappedChangeBackgroundButton(sender: UIButton) {
        self.delegate?.tappedChangeBackgroundButton()
    }
    
}
