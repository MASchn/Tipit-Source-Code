//
//  IROProfileViewController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 1/23/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit
import Alamofire

class IROProfileViewController: UIViewController {
    
    // MARK: - Properties
    var story: IROStory?

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.storyPreviewButton)
        self.view.addSubview(self.logOutButton)
        
        self.setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationController?.isNavigationBarHidden = true
        
        IROAPIClient.getPersonalStory { (mediaItems: [IROMediaItem]?) in
            if let mediaItems: [IROMediaItem] = mediaItems {
                IROStory.story(with: IROUser.currentUser!, mediaItems: mediaItems, completion: { (story: IROStory?) in
                    if let story: IROStory = story {
                        self.story = story
                        if let firstPost: IROPost = story.posts.first {
                            self.storyPreviewButton.setImage(firstPost.contentImage, for: .normal)
                        }
                    }
                })
            }
        }
    }
    
    // MARK: - Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.storyPreviewButton.layer.cornerRadius = self.storyPreviewButton.frame.size.height / 2.0
        self.logOutButton.layer.cornerRadius = self.logOutButton.frame.size.height / 2.0
    }
    
    // MARK: - Lazy Initialization
    lazy var backgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var profileImageButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var storyPreviewButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = .lightGray
        button.layer.borderColor = IROConstants.green.cgColor
        button.layer.borderWidth = 10.0
        button.addTarget(self, action: #selector(self.tappedStoryPreviewButton), for: .touchUpInside)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var followersButton: IROButton = {
        let button: IROButton = IROButton(style: .text)
        button.setTitle("Followers", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var addFriendsButton: IROButton = {
        let button: IROButton = IROButton(style: .text)
        button.setTitle("Add Friends", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var myFriendsButton: IROButton = {
        let button: IROButton = IROButton(style: .text)
        button.setTitle("My Friends", for: .normal)
        return button
    }()
    
    lazy var logOutButton: IROButton = {
        let button: IROButton = IROButton(style: .red)
        button.setTitle("Log out", for: .normal)
        button.addTarget(self, action: #selector(self.tappedLogOutButton), for: .touchUpInside)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.backgroundImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.storyPreviewButton.widthAnchor.constraint(equalToConstant: 120.0).isActive = true
        self.storyPreviewButton.heightAnchor.constraint(equalToConstant: 120.0).isActive = true
        self.storyPreviewButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.storyPreviewButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        self.logOutButton.topAnchor.constraint(equalTo: self.storyPreviewButton.bottomAnchor, constant: 50.0).isActive = true
        self.logOutButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30.0).isActive = true
        self.logOutButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30.0).isActive = true
        self.logOutButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
    // MARK: - Actions
    func tappedStoryPreviewButton() {
        if let story: IROStory = self.story {
            let storyViewController: IROStoryViewController = IROStoryViewController(story: story)
            self.present(storyViewController, animated: true, completion: nil)
        }
    }
    
    func tappedLogOutButton() {
        IROUser.logOut()
        AppDelegate.shared.navigationController?.configureForSignIn()
        AppDelegate.shared.navigationController?.popToRootViewController(animated: true)
    }

}
