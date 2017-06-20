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
    lazy var storyPreviewWidth: NSLayoutConstraint = self.storyPreviewButton.widthAnchor.constraint(equalToConstant: 0.0)
    lazy var storyPreviewHeight: NSLayoutConstraint = self.storyPreviewButton.heightAnchor.constraint(equalToConstant: 0.0)
    
//    required init(username: String) {
//        super.init(nibName: nil, bundle: nil)
//        
//        if username == IROUser.currentUser?.username {
//            self.editButton.isHidden = false
//        } else {
//            self.followButton.isHidden = false
//        }
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.view.addSubview(self.backgroundImageView)
        self.backgroundImageView.addSubview(self.shadeView)
        self.view.addSubview(self.profileImageButton)
        self.view.addSubview(self.settingsButton)
        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.usernameLabel)
        
        self.view.addSubview(self.followersButton)
        self.view.addSubview(self.followersCountLabel)
        self.view.addSubview(self.followersSubtitleLabel)
        
        self.view.addSubview(self.followingButton)
        self.view.addSubview(self.followingCountLabel)
        self.view.addSubview(self.followingSubtitleLabel)
        
        self.view.addSubview(self.coinsCountLabel)
        self.view.addSubview(self.coinsSubtitleLabel)
        
        self.view.addSubview(self.editButton)
        self.view.addSubview(self.followButton)
        
        self.view.addSubview(self.storyPreviewButton)
        
        self.setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IROAPIClient.getPersonalStory { (story: IROStory?) in
            if let story: IROStory = story {
                self.story = story
                if let firstPost: IROPost = story.posts.first {
                    self.storyPreviewButton.setImage(firstPost.contentImage, for: .normal)
                    self.storyPreviewWidth.constant = 120.0
                    self.storyPreviewHeight.constant = 120.0
                }
            }
        }
    }
    
    func configure(with user: IROUser) {
        let backgroundImage: UIImage = user.backgroundImage ?? #imageLiteral(resourceName: "empty_background")
        self.backgroundImageView.image = backgroundImage
        
        let profileImage: UIImage = user.profileImage ?? #imageLiteral(resourceName: "empty_profile")
        self.profileImageButton.setImage(profileImage, for: .normal)
        
        self.nameLabel.text = user.fullName
        self.usernameLabel.text = user.username
    }
        
    // MARK: - Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.storyPreviewButton.layer.cornerRadius = self.storyPreviewButton.frame.size.height / 2.0
        self.profileImageButton.layer.cornerRadius = self.profileImageButton.frame.size.height / 2.0
        self.editButton.layer.cornerRadius = self.editButton.frame.size.height / 2.0
    }
    
    // MARK: - Lazy Initialization
    lazy var backgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var shadeView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var profileImageButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(self.tappedProfileButton), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var settingsButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
        button.addTarget(self, action: #selector(self.tappedSettingsButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 18.0, weight: UIFontWeightHeavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var usernameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 12.0, weight: UIFontWeightRegular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var editButton: IROButton = {
        let button: IROButton = IROButton(style: .green)
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: UIFontWeightMedium)
        button.addTarget(self, action: #selector(self.tappedEditButton), for: .touchUpInside)
        button.clipsToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true // Edit will be hidden if profile is not for current user
        return button
    }()
    
    lazy var followButton: IROButton = {
        let button: IROButton = IROButton(style: .green)
        button.setTitle("Follow", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: UIFontWeightMedium)
        button.addTarget(self, action: #selector(self.tappedFollowButton), for: .touchUpInside)
        button.clipsToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true // Follow will be hidden if profile is current user
        return button
    }()
    
    lazy var followersButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = .magenta
        button.addTarget(self, action: #selector(self.tappedFollowersButton(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var followingButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = .purple
        button.addTarget(self, action: #selector(self.tappedFollowingButton(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var followersCountLabel: UILabel = self.valueLabel(value: "0")
    lazy var followersSubtitleLabel: UILabel = self.subtitleLabel(subtitle: "followers")
    lazy var followingCountLabel: UILabel = self.valueLabel(value: "0")
    lazy var followingSubtitleLabel: UILabel =  self.subtitleLabel(subtitle: "following")
    lazy var coinsCountLabel: UILabel = self.valueLabel(value: "0")
    lazy var coinsSubtitleLabel: UILabel = self.subtitleLabel(subtitle: "coins")
    
    // Helper method
    func valueLabel(value: String) -> UILabel {
        let label: UILabel = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12.0, weight: UIFontWeightMedium)
        label.textAlignment = .center
        label.text = value
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    // Helper method
    func subtitleLabel(subtitle: String) -> UILabel {
        let label: UILabel = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12.0, weight: UIFontWeightLight)
        label.textAlignment = .center
        label.text = subtitle
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    lazy var storyPreviewButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = .lightGray
        button.layer.borderColor = UIColor.iroGreen.cgColor
        button.layer.borderWidth = 10.0
        button.addTarget(self, action: #selector(self.tappedStoryPreviewButton), for: .touchUpInside)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var bioLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 12.0, weight: UIFontWeightLight)
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.backgroundImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.shadeView.topAnchor.constraint(equalTo: self.backgroundImageView.topAnchor).isActive = true
        self.shadeView.bottomAnchor.constraint(equalTo: self.backgroundImageView.bottomAnchor).isActive = true
        self.shadeView.leftAnchor.constraint(equalTo: self.backgroundImageView.leftAnchor).isActive = true
        self.shadeView.rightAnchor.constraint(equalTo: self.backgroundImageView.rightAnchor).isActive = true
        
        self.profileImageButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0).isActive = true
        self.profileImageButton.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.profileImageButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.profileImageButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.settingsButton.centerYAnchor.constraint(equalTo: self.profileImageButton.centerYAnchor).isActive = true
        self.settingsButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10.0).isActive = true
        self.settingsButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        self.settingsButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        self.nameLabel.topAnchor.constraint(equalTo: self.profileImageButton.bottomAnchor, constant: 10.0).isActive = true
        self.nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.usernameLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 10.0).isActive = true
        self.usernameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.editButton.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor, constant: 15.0).isActive = true
        self.editButton.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        self.editButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.editButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.followButton.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor, constant: 15.0).isActive = true
        self.followButton.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        self.followButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.followButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.followersButton.topAnchor.constraint(equalTo: self.followersCountLabel.topAnchor).isActive = true
        self.followersButton.bottomAnchor.constraint(equalTo: self.followersSubtitleLabel.bottomAnchor).isActive = true
        self.followersButton.leftAnchor.constraint(equalTo: self.followersSubtitleLabel.leftAnchor).isActive = true
        self.followersButton.rightAnchor.constraint(equalTo: self.followersSubtitleLabel.rightAnchor).isActive = true
        
        self.followingButton.topAnchor.constraint(equalTo: self.followingCountLabel.topAnchor).isActive = true
        self.followingButton.bottomAnchor.constraint(equalTo: self.followingSubtitleLabel.bottomAnchor).isActive = true
        self.followingButton.leftAnchor.constraint(equalTo: self.followingSubtitleLabel.leftAnchor).isActive = true
        self.followingButton.rightAnchor.constraint(equalTo: self.followingSubtitleLabel.rightAnchor).isActive = true
        
        self.followingCountLabel.topAnchor.constraint(equalTo: self.editButton.bottomAnchor, constant: 20.0).isActive = true
        self.followingCountLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.followersCountLabel.topAnchor.constraint(equalTo: self.followingCountLabel.topAnchor).isActive = true
        self.followersCountLabel.rightAnchor.constraint(equalTo: self.followingCountLabel.leftAnchor, constant: -60.0).isActive = true
        
        self.coinsCountLabel.topAnchor.constraint(equalTo: self.followingCountLabel.topAnchor).isActive = true
        self.coinsCountLabel.leftAnchor.constraint(equalTo: self.followingCountLabel.rightAnchor, constant: 60.0).isActive = true
        
        self.followersSubtitleLabel.topAnchor.constraint(equalTo: self.followersCountLabel.bottomAnchor).isActive = true
        self.followersSubtitleLabel.centerXAnchor.constraint(equalTo: self.followersCountLabel.centerXAnchor).isActive = true
        
        self.followingSubtitleLabel.topAnchor.constraint(equalTo: self.followingCountLabel.bottomAnchor).isActive = true
        self.followingSubtitleLabel.centerXAnchor.constraint(equalTo: self.followingCountLabel.centerXAnchor).isActive = true
        
        self.coinsSubtitleLabel.topAnchor.constraint(equalTo: self.coinsCountLabel.bottomAnchor).isActive = true
        self.coinsSubtitleLabel.centerXAnchor.constraint(equalTo: self.coinsCountLabel.centerXAnchor).isActive = true
        
        self.storyPreviewButton.topAnchor.constraint(equalTo: self.followingSubtitleLabel.bottomAnchor, constant: 42.0).isActive = true
        self.storyPreviewButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.storyPreviewWidth.isActive = true
        self.storyPreviewHeight.isActive = true
    }
    
    // MARK: - Actions
    func tappedStoryPreviewButton() {
        if let story: IROStory = self.story {
            let storyViewController: IROStoryViewController = IROStoryViewController(story: story, isProfile: true)
            self.present(storyViewController, animated: true, completion: nil)
        }
    }
    
    func tappedProfileButton() {
        self.showPhotoActionSheet()
    }
    
    func tappedSettingsButton() {
        let settingsViewController: IROSettingsViewController = IROSettingsViewController()
        let settingsNavController: UINavigationController = UINavigationController(rootViewController: settingsViewController)
        self.present(settingsNavController, animated: true, completion: nil)
    }
    
    override func imagePickerSelectedImage(image: UIImage) {
        IROUser.currentUser?.profileImage = image
        IROUser.currentUser?.save()
        self.profileImageButton.setImage(image, for: .normal)
        if let data: Data = UIImageJPEGRepresentation(image, 0.5) {
            IROAPIClient.updateUserImage(data: data, type: .profile) { (success: Bool) in
                //
            }
        }
    }
        
    func tappedEditButton() {
        let editProfileViewController: IROEditProfileViewController = IROEditProfileViewController(style: .grouped)
        let editNavController: UINavigationController = UINavigationController(rootViewController: editProfileViewController)
        self.present(editNavController, animated: true, completion: nil)
    }
    
    func tappedFollowButton() {
        // Follow network request
    }
    
    func tappedFollowersButton(sender: UIButton) {
        let followersViewController: IROUserTableViewController = IROUserTableViewController()
        self.navigationController?.pushViewController(followersViewController, animated: true)
    }
    
    func tappedFollowingButton(sender: UIButton) {
        let followingViewController: IROUserTableViewController = IROUserTableViewController()
        self.navigationController?.pushViewController(followingViewController, animated: true)
    }

}
