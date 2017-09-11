//
//  TIPPreviewViewController.swift
//  Ironc.ly
//

import UIKit
import Alamofire

enum TIPContentType: String {
    case photo = "photo"
    case video = "video"
}

class TIPPreviewViewController: TIPViewControllerWIthPullDown {
    
    var contentType: TIPContentType = .photo
    
    enum TIPContentPrivacy: String {
        case `public` = "public"
        case `private` = "private"
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white

        //self.view.addSubview(self.privateButton)
        self.view.addSubview(self.publicButton)
        //self.view.addSubview(self.sendToFriendButton)
        
        self.setUpConstraints()
        
        self.configureTIPNavBar()
        self.addPullDownMenu()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.privateButton.layer.cornerRadius = self.privateButton.frame.height / 2.0
        self.publicButton.layer.cornerRadius = self.publicButton.frame.height / 2.0
    }
    
    // MARK: - Lazy Initialization
    lazy var privateButton: TIPButton = {
        let button: TIPButton = TIPButton(style: .green)
        button.setTitle("Private", for: .normal)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var publicButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(#imageLiteral(resourceName: "newSendButton"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "newSendButtonPressed"), for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var sendToFriendButton: TIPButton = {
        let button: TIPButton = TIPButton(style: .text)
        button.setTitle("Send to a friend", for: .normal)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        
//        self.sendToFriendButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -hMargin).isActive = true
//        self.sendToFriendButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
//        self.sendToFriendButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
//        self.sendToFriendButton.heightAnchor.constraint(equalToConstant: vMargin).isActive = true
        
        self.publicButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.publicButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.size.height/2.6).isActive = true
        self.publicButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.17).isActive = true
        self.publicButton.widthAnchor.constraint(equalTo: self.publicButton.heightAnchor, multiplier: 2.3).isActive = true
        
//        self.privateButton.bottomAnchor.constraint(equalTo: self.publicButton.topAnchor, constant: -vMargin).isActive = true
//        self.privateButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: hMargin).isActive = true
//        self.privateButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -hMargin).isActive = true
//        self.privateButton.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
}
