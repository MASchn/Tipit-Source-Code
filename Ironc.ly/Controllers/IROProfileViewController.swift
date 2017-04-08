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
        
        IROAPIClient.getPersonalStory { (mediaItems: [IROMediaItem]?) in
            if let mediaItems: [IROMediaItem] = mediaItems {
                IROStory.story(with: IROUser.currentUser!, mediaItems: mediaItems, completion: { (story: IROStory?) in
                    if let story: IROStory = story {
                        self.story = story
                        if let firstPost: IROPost = story.posts.first {
                            self.storyPreviewButton.setImage(firstPost.contentImage, for: .normal)
                            self.storyPreviewButton.layer.borderColor = IROConstants.green.cgColor
                            self.storyPreviewButton.layer.borderWidth = 10.0
                        }
                    }
                })
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationController?.isNavigationBarHidden = true
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
        imageView.image = #imageLiteral(resourceName: "register_background")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var storyPreviewButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = UIColor.lightGray
        button.addTarget(self, action: #selector(self.tappedStoryPreviewButton), for: .touchUpInside)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var logOutButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightMedium)
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
        
        self.storyPreviewButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60.0).isActive = true
        self.storyPreviewButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -60.0).isActive = true
        self.storyPreviewButton.heightAnchor.constraint(equalTo: self.storyPreviewButton.widthAnchor).isActive = true
        self.storyPreviewButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        self.logOutButton.topAnchor.constraint(equalTo: self.storyPreviewButton.bottomAnchor, constant: 50.0).isActive = true
        self.logOutButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30.0).isActive = true
        self.logOutButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30.0).isActive = true
        self.logOutButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
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
        let logInViewController: IROLoginViewController = IROLoginViewController()
        self.navigationController?.present(logInViewController, animated: true, completion: nil)
    }

}
