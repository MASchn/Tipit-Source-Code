//
//  IROPreviewViewController.swift
//  Ironc.ly
//

import UIKit
import Alamofire

enum IROContentType: String {
    case photo = "photo"
    case video = "video"
}

class IROPreviewViewController: UIViewController {
    
    var contentType: IROContentType = .photo
    
    enum IROContentPrivacy: String {
        case `public` = "public"
        case `private` = "private"
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white

        self.view.addSubview(self.privateButton)
        self.view.addSubview(self.publicButton)
        self.view.addSubview(self.sendToFriendButton)
        
        self.setUpConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.privateButton.layer.cornerRadius = self.privateButton.frame.height / 2.0
        self.publicButton.layer.cornerRadius = self.publicButton.frame.height / 2.0
    }
    
    // MARK: - Lazy Initialization
    lazy var privateButton: IROButton = {
        let button: IROButton = IROButton(style: .green)
        button.setTitle("Private", for: .normal)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var publicButton: IROButton = {
        let button: IROButton = IROButton(style: .green)
        button.setTitle("Public", for: .normal)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var sendToFriendButton: IROButton = {
        let button: IROButton = IROButton(style: .text)
        button.setTitle("Send to a friend", for: .normal)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        let hMargin: CGFloat = 40.0
        let vMargin: CGFloat = 20.0
        let height: CGFloat = 50.0
        
        self.sendToFriendButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -hMargin).isActive = true
        self.sendToFriendButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        self.sendToFriendButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.sendToFriendButton.heightAnchor.constraint(equalToConstant: vMargin).isActive = true
        
        self.publicButton.bottomAnchor.constraint(equalTo: self.sendToFriendButton.topAnchor, constant: -vMargin).isActive = true
        self.publicButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        self.publicButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.publicButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        self.privateButton.bottomAnchor.constraint(equalTo: self.publicButton.topAnchor, constant: -vMargin).isActive = true
        self.privateButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
        self.privateButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
        self.privateButton.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
}
