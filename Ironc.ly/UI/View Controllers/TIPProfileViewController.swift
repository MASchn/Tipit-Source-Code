//
//  TIPProfileViewController.swift
//  Ironc.ly
//

import UIKit
import Alamofire
import AVFoundation

class TIPProfileViewController: TIPViewControllerWIthPullDown {
    
    var followButtonTop: NSLayoutConstraint?
    var unFollowButtonTop: NSLayoutConstraint?
    var myStoryTop: NSLayoutConstraint?
    
    //var pullDownMenuBottom: NSLayoutConstraint?
    
    // MARK: - Properties
    var userId: String?
    var story: TIPStory?
    var username: String?
    var profilePic: UIImage?
    var coinsToSub: Int?
    var followers: [String]?
    var following: [String]?
    var subscribers: [String]?
    var fontSize: CGFloat = 18.0
    let profileReuseID = "profile"
    var storyURLArray: [TIPPost]?
    var imageURLData: Data?
    var contentViewHeight: NSLayoutConstraint?
    
    // MARK: - View Lifecycle
    convenience init(searchUser: TIPSearchUser) {
        self.init(nibName: nil, bundle: nil)
        
        self.userId = searchUser.userId
        //self.usernameLabel.text = searchUser.username
        self.actualNameLabel.text = searchUser.username
        self.username = searchUser.username
        self.coinsToSub = searchUser.coinsToSub
        self.followers = searchUser.followersList
        self.following = searchUser.followingList
        self.subscribers = searchUser.subscribersList
        
        self.followButton.isHidden = false
        self.editButton.isHidden = true
        self.subscribeButton.isHidden = false
        self.coinsLabel.isHidden = true
        self.coinsEarnedLabel.isHidden = true
        self.pencilEditButton.isHidden = true
        
        if searchUser.following == false {
            //self.showFollowButton()
            self.drawnFollowButton.isHidden = false
            self.drawnUnFollowButton.isHidden = true
        } else {
            //self.showUnfollowButton()
            self.drawnFollowButton.isHidden = true
            self.drawnUnFollowButton.isHidden = false
        }
        
//        if TIPUser.currentUser?.subscribedTo?.contains(searchUser.userId) == true {
//            //self.showUnsubscribeButton()
//            self.keySubButton.isHidden = true
//        } else {
//            //self.showSubscribeButton()
//        }
        
//        UIImage.download(urlString: searchUser.profileImageURL, placeHolder: #imageLiteral(resourceName: "empty_profile"), completion: { [unowned self] (image: UIImage?) in
//            self.profileImageButton.setImage(image, for: .normal)
//        })
        
        
        if let profileURL = searchUser.profileImageURL {
            UIImage.loadImageUsingCache(urlString: profileURL, placeHolder: #imageLiteral(resourceName: "empty_profile"), completion: { (image) in
                //self.profileImageButton.setImage(image, for: .normal)
                self.profilePicImageView.image = image
            })
        }
        
//        if let backgroundURL = searchUser.backgroundImageURL {
//            self.backgroundImageView.loadImageUsingCacheFromUrlString(urlString: backgroundURL, placeHolder: #imageLiteral(resourceName: "tipitbackground3_7")) {}
//        } else {
//            self.backgroundImageView.loadImageUsingCacheFromUrlString(urlString: "no image", placeHolder: #imageLiteral(resourceName: "tipitbackground3_7")) {}
//        }
        
//        UIImage.download(urlString: searchUser.backgroundImageURL, placeHolder: #imageLiteral(resourceName: "tipitbackground3_7"), completion: { [unowned self] (image: UIImage?) in
//            self.backgroundImageView.image = image
//        })
    }
    
    convenience init(feedItem: TIPFeedItem) {
        self.init(nibName: nil, bundle: nil)

        self.userId = feedItem.userId
        //self.usernameLabel.text = feedItem.username
        self.actualNameLabel.text = feedItem.username
        self.username = feedItem.username
        self.coinsToSub = feedItem.coinsToSub
        self.followers = feedItem.followersList
        self.following = feedItem.followingList
        self.subscribers = feedItem.subscribersList
        
        self.followButton.isHidden = false
        self.editButton.isHidden = true
        self.subscribeButton.isHidden = false
        self.coinsLabel.isHidden = true
        self.coinsEarnedLabel.isHidden = true
        self.pencilEditButton.isHidden = true
        self.drawnFollowButton.isHidden = true
        
        //self.showUnfollowButton()
        
//        if TIPUser.currentUser?.subscribedTo?.contains(feedItem.userId) == true {
//            //self.showUnsubscribeButton()
//            self.keySubButton.isHidden = true
//        } else {
//            //self.showSubscribeButton()
//        }
//        UIImage.download(urlString: feedItem.profileImageURL, placeHolder: #imageLiteral(resourceName: "empty_profile"), completion: { [unowned self] (image: UIImage?) in
//            self.profileImageButton.setImage(image, for: .normal)
//        })
        
        if let profileURL = feedItem.profileImageURL {
            UIImage.loadImageUsingCache(urlString: profileURL, placeHolder: #imageLiteral(resourceName: "empty_profile"), completion: { (image) in
                //self.profileImageButton.setImage(image, for: .normal)
                self.profilePicImageView.image = image
            })
        }
        
//        if let backgroundURL = feedItem.backgroundImageURL {
//            self.backgroundImageView.loadImageUsingCacheFromUrlString(urlString: backgroundURL, placeHolder: #imageLiteral(resourceName: "tipitbackground3_7")) {}
//        } else {
//            self.backgroundImageView.loadImageUsingCacheFromUrlString(urlString: "no image", placeHolder: #imageLiteral(resourceName: "tipitbackground3_7")) {}
//        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.profileScrollView)
        self.profileScrollView.addSubview(self.contentView)
//        self.storyCollectionView.frame.size.height = storyCollectionView.contentSize.height
        
        
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: selector(self.DidScroll(collectionView:self.storyCollectionView)))
//        swipeLeft.direction = .left
        
        
        let screen = UIScreen.main
        self.fontSize = screen.bounds.size.height * (18.0 / 568.0)
        if (screen.bounds.size.height < 500) {
            self.fontSize = screen.bounds.size.height * (18.0 / 480.0)
        }
        //label.font = label.font.withSize(newFontSize)
        
        self.contentView.addSubview(self.noTapeProfileFrameImageView)
        self.contentView.addSubview(self.profileFrameImageView)
        self.contentView.addSubview(self.pencilEditButton)
        self.contentView.addSubview(self.keySubButton)
        self.contentView.addSubview(self.drawnNameLabel)
        self.contentView.addSubview(self.actualNameLabel)
        self.contentView.addSubview(self.drawnSubsLabel)
        self.contentView.addSubview(self.actualSubsLabel)
        self.contentView.addSubview(self.followersLabel)
        self.contentView.addSubview(self.followingLabel)
        self.contentView.addSubview(self.drawnFollowButton)
        self.contentView.addSubview(self.drawnUnFollowButton)
        self.contentView.addSubview(self.storyLabelImageView)
        self.contentView.addSubview(self.storyCollectionView)
        self.contentView.addSubview(self.drawnSwipeForMoreButton)
        
        storyCollectionView.register(TIPProfileStoryCollectionViewCell.self, forCellWithReuseIdentifier: profileReuseID)
        
        //self.contentView.bringSubview(toFront: self.profileFrameImageView)
        
        self.profileFrameImageView.addSubview(self.profilePicImageView)
        self.noTapeProfileFrameImageView.addSubview(self.storyPicImageView)
        
//        self.view.addSubview(self.backgroundImageView)
//        self.backgroundImageView.addSubview(self.shadeView)
//        self.view.addSubview(self.profileImageButton)
//        // APPSTORE: REMOVING FOR V1
////        self.view.addSubview(self.settingsButton)
//        self.view.addSubview(self.nameLabel)
//        self.view.addSubview(self.usernameLabel)
//        self.view.addSubview(self.coinsLabel)
//        self.view.addSubview(self.coinsEarnedLabel)
//        
//        // APPSTORE: REMOVING FOR V1
////        self.view.addSubview(self.followersButton)
////        self.view.addSubview(self.followersCountLabel)
////        self.view.addSubview(self.followersSubtitleLabel)
////        
////        self.view.addSubview(self.followingButton)
////        self.view.addSubview(self.followingCountLabel)
////        self.view.addSubview(self.followingSubtitleLabel)
////        
////        self.view.addSubview(self.coinsCountLabel)
////        self.view.addSubview(self.coinsSubtitleLabel)
//        
//        self.view.addSubview(self.editButton)
//        self.view.addSubview(self.followButton)
//        self.view.addSubview(self.subscribeButton)
//        
//        self.view.addSubview(self.storyPreviewButton)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedStoryPreviewButton))
        self.noTapeProfileFrameImageView.addGestureRecognizer(tap)
        self.noTapeProfileFrameImageView.isUserInteractionEnabled = true
        
//        let navTap = UITapGestureRecognizer(target: self, action: #selector(self.pullDownPressed))
//        self.navigationController?.navigationBar.isUserInteractionEnabled = true
//        self.navigationController?.navigationBar.addGestureRecognizer(navTap)
//        
//        let pullDownMenuTap = UITapGestureRecognizer(target: self, action: #selector(self.pullDownPressed))
//        self.pullDownView.isUserInteractionEnabled = true
//        self.pullDownView.addGestureRecognizer(pullDownMenuTap)
        
        self.setUpScrollConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("TOKEN: \(TIPUser.currentUser?.token)")
        
        //self.navigationItem.title = "Profile"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(self.tappedSettingsButton))
        
        self.configureTIPNavBar()
        
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navBarWithBackButton").resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch), for: .default)
        
        self.addPullDownMenu()
        
        
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(self.pullDownPressed))
        
        self.backgroundImageView.image = TIPLoginViewController.backgroundPicArray[TIPUser.currentUser?.backgroundPicSelection ?? 0]
        
        if let followers = self.followers {
            self.followersLabel.text = "Followers: \(followers.count)"
        } else {
            self.followersLabel.text = "Followers: 0"
        }
        
        if let following = self.following {
            self.followingLabel.text = "Following: \(following.count)"
        } else {
            self.followingLabel.text = "Following: 0"
        }
        
        if let subs = self.subscribers {
            self.actualSubsLabel.text = "\(subs.count)"
        } else {
            self.actualSubsLabel.text = "0"
        }
        
        if let userId: String = self.userId {
            self.getStory(userId: userId)
            
        }
       
    }
    
    func getStory(userId: String) {
        TIPAPIClient.getStory(userId: userId, completionHandler: { (story: TIPStory?) in
            if let story: TIPStory = story {
                self.story = story
                
                self.storyURLArray = story.posts
                
                self.storyCollectionView.reloadData()
                
                if self.storyURLArray?.isEmpty == true {
                    self.contentViewHeight?.constant =  UIScreen.main.bounds.size.height
                } else {
                    self.contentViewHeight?.constant = self.storyCollectionView.collectionViewLayout.collectionViewContentSize.height + UIScreen.main.bounds.size.height/1.3
                }
                
//                if let firstPost: TIPPost = story.posts.last {
//                    //self.storyURLArray?.append(firstPost.contentURL!)
//                    self.storyPicImageView.isHidden = true
//                    self.noTapeProfileFrameImageView.isHidden = true
//                    
//                    if firstPost.type == .video {
//                        
//                        DispatchQueue.global(qos: .background).async {
//                            
//                            let image = TIPAPIClient.imageFromVideo(urlString: firstPost.contentURL!, at: 0)
//                            DispatchQueue.main.async {
//                                //self.storyPreviewButton.setImage(image, for: .normal)
//                                //self.storyPreviewButton.layer.borderWidth = 10.0
//                                self.storyPicImageView.image = image
//                                
//                                self.storyCollectionView.reloadData()
//                                
//                                if (self.storyURLArray?.count)! > 9 {
//                                    //MAKE SHIT TO MAKE THIS DISAPPEAR LATER
//                                    self.drawnSwipeForMoreButton.isHidden = false
//                                }
//                                
//                                
//                                //need to cache the imageFromVideo to store here needs a URL
////                                self.Array?.append(firstPost.contentURL!)
//                            }
//                        }
//                        
//                    } else {
//                        //self.storyPreviewButton.setImage(firstPost.contentImage, for: .normal)
//                       // self.storyPreviewButton.layer.borderWidth = 10.0
//                        self.storyPicImageView.image = firstPost.contentImage
////                        self.storyURLArray?.append(firstPost.contentURL!)
//                    }
//                } else {
//                    self.storyPicImageView.isHidden = true
//                    self.noTapeProfileFrameImageView.isHidden = true
//                }
            }
            
        })
    }
    
    func tappedBackButton() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func configure(with user: TIPUser) {
        let backgroundImage: UIImage = user.backgroundImage ?? #imageLiteral(resourceName: "empty_background")
        self.backgroundImageView.image = backgroundImage
        
        let profileImage: UIImage = user.profileImage ?? #imageLiteral(resourceName: "empty_profile")
        self.profileImageButton.setImage(profileImage, for: .normal)
        
        self.nameLabel.text = user.fullName
        self.usernameLabel.text = user.username
        
        if user.userId == TIPUser.currentUser?.userId {
            self.editButton.isHidden = false
        } else {
            self.followButton.isHidden = false
        }
    }

    // MARK: - Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.storyPreviewButton.layer.cornerRadius = self.storyPreviewButton.frame.size.height / 2.0
        self.profileImageButton.layer.cornerRadius = self.profileImageButton.frame.size.height / 2.0
        self.editButton.layer.cornerRadius = self.editButton.frame.size.height / 2.0
        self.followButton.layer.cornerRadius = self.followButton.frame.size.height / 2.0
        self.subscribeButton.layer.cornerRadius = self.subscribeButton.frame.size.height / 2.0
    }
    
    // MARK: - Autolayout
    func setUpScrollConstraints() {
        
        let screenHeight: CGFloat = UIScreen.main.bounds.size.height
        
        self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.backgroundImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.profileScrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.profileScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.profileScrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.profileScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.contentView.topAnchor.constraint(equalTo: self.profileScrollView.topAnchor, constant: (self.navigationController?.navigationBar.bounds.size.height)!).isActive = true
        self.contentView.leftAnchor.constraint(equalTo: self.profileScrollView.leftAnchor).isActive = true
        self.contentView.rightAnchor.constraint(equalTo: self.profileScrollView.rightAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.profileScrollView.bottomAnchor).isActive = true
        self.contentView.widthAnchor.constraint(equalTo: self.profileScrollView.widthAnchor).isActive = true
        contentViewHeight = self.contentView.heightAnchor.constraint(equalToConstant: screenHeight)
        contentViewHeight?.isActive = true
        
        self.profileFrameImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        self.profileFrameImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5).isActive = true
        self.profileFrameImageView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width/2).isActive = true
        self.profileFrameImageView.heightAnchor.constraint(equalTo: self.profileFrameImageView.widthAnchor).isActive = true
        
        self.noTapeProfileFrameImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        self.noTapeProfileFrameImageView.centerXAnchor.constraint(equalTo: self.profileFrameImageView.rightAnchor).isActive = true
        self.noTapeProfileFrameImageView.widthAnchor.constraint(equalTo: self.profileFrameImageView.widthAnchor).isActive = true
        self.noTapeProfileFrameImageView.heightAnchor.constraint(equalTo: self.profileFrameImageView.heightAnchor).isActive = true
        
        self.pencilEditButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20).isActive = true
        self.pencilEditButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        self.pencilEditButton.widthAnchor.constraint(equalTo: self.profileFrameImageView.widthAnchor, multiplier: 0.3).isActive = true
        self.pencilEditButton.heightAnchor.constraint(equalTo: self.pencilEditButton.widthAnchor).isActive = true
        
        self.keySubButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20).isActive = true
        self.keySubButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        self.keySubButton.widthAnchor.constraint(equalTo: self.profileFrameImageView.widthAnchor, multiplier: 0.4).isActive = true
        self.keySubButton.heightAnchor.constraint(equalTo: self.keySubButton.widthAnchor, multiplier: 1.3).isActive = true
        
        self.drawnNameLabel.topAnchor.constraint(equalTo: self.profileFrameImageView.bottomAnchor, constant: 20).isActive = true
        self.drawnNameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10).isActive = true
        
        self.actualNameLabel.leftAnchor.constraint(equalTo: self.drawnNameLabel.rightAnchor, constant: 10).isActive = true
        self.actualNameLabel.topAnchor.constraint(equalTo: self.profileFrameImageView.bottomAnchor, constant: 20).isActive = true
        
        self.drawnSubsLabel.topAnchor.constraint(equalTo: self.drawnNameLabel.bottomAnchor, constant: 20).isActive = true
        self.drawnSubsLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10).isActive = true
        
        self.actualSubsLabel.leftAnchor.constraint(equalTo: self.drawnSubsLabel.rightAnchor, constant: 10).isActive = true
        self.actualSubsLabel.topAnchor.constraint(equalTo: self.drawnNameLabel.bottomAnchor, constant: 20).isActive = true
        
        self.followersLabel.topAnchor.constraint(equalTo: self.drawnSubsLabel.bottomAnchor, constant: 20).isActive = true
        self.followersLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10).isActive = true
        
        self.followingLabel.topAnchor.constraint(equalTo: self.followersLabel.bottomAnchor, constant: 20).isActive = true
        self.followingLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10).isActive = true
        
        self.profileFrameImageView.layoutIfNeeded()
        let picConstant = self.profileFrameImageView.bounds.width/19
        print("PIC CONSTANT: \(picConstant)")
        
        self.profilePicImageView.centerXAnchor.constraint(equalTo: self.profileFrameImageView.centerXAnchor, constant: 0).isActive = true
        self.profilePicImageView.centerYAnchor.constraint(equalTo: self.profileFrameImageView.centerYAnchor, constant: -picConstant).isActive = true
        self.profilePicImageView.widthAnchor.constraint(equalTo: self.profileFrameImageView.widthAnchor, multiplier: 0.57).isActive = true
        self.profilePicImageView.heightAnchor.constraint(equalTo: self.profileFrameImageView.heightAnchor, multiplier: 0.57).isActive = true
        self.profilePicImageView.transform = self.profilePicImageView.transform.rotated(by: CGFloat.pi/70)
        
        self.storyPicImageView.centerXAnchor.constraint(equalTo: self.noTapeProfileFrameImageView.centerXAnchor, constant: 0).isActive = true
        self.storyPicImageView.centerYAnchor.constraint(equalTo: self.noTapeProfileFrameImageView.centerYAnchor, constant: -picConstant).isActive = true
        self.storyPicImageView.widthAnchor.constraint(equalTo: self.profilePicImageView.widthAnchor).isActive = true
        self.storyPicImageView.heightAnchor.constraint(equalTo: self.profilePicImageView.heightAnchor).isActive = true
        self.storyPicImageView.transform = self.storyPicImageView.transform.rotated(by: CGFloat.pi/70)
        
        followButtonTop = self.drawnFollowButton.topAnchor.constraint(equalTo: self.keySubButton.bottomAnchor, constant: 10)
//        self.drawnFollowButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 225).isActive = true
        followButtonTop?.isActive = true
//        self.drawnFollowButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.drawnFollowButton.widthAnchor.constraint(equalToConstant: self.view.frame.size.width/3).isActive  = true
        self.drawnFollowButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.drawnFollowButton.heightAnchor.constraint(equalTo: self.drawnFollowButton.widthAnchor, multiplier: 0.3).isActive = true
        
        unFollowButtonTop = self.drawnUnFollowButton.topAnchor.constraint(equalTo: self.keySubButton.bottomAnchor, constant: 10)
//        self.drawnUnFollowButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 225).isActive = true
        unFollowButtonTop?.isActive = true
//        self.drawnUnFollowButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.drawnUnFollowButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.drawnUnFollowButton.widthAnchor.constraint(equalToConstant: self.view.frame.size.width/3).isActive  = true
        self.drawnUnFollowButton.heightAnchor.constraint(equalTo: self.drawnFollowButton.widthAnchor, multiplier: 0.3).isActive = true
        
//        self.myStoryTop = self.storyLabelImageView.topAnchor.constraint(equalTo: self.followingLabel.bottomAnchor, constant: 0)
//        self.myStoryTop?.isActive = true
        //storyLabelImageViewTop? = self.storyLabelImageView.topAnchor.constraint(equalTo: self.followingLabel.bottomAnchor, constant: 20)
        //storyLabelImageViewTop?.isActive = true
        //        self.storyImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.storyLabelImageView.topAnchor.constraint(equalTo: self.followingLabel.bottomAnchor, constant: 25).isActive = true
        self.storyLabelImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.storyLabelImageView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width/1.5).isActive = true
        self.storyLabelImageView.heightAnchor.constraint(equalTo: self.storyLabelImageView.widthAnchor, multiplier: 0.2).isActive = true

        self.storyCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.storyCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.storyCollectionView.topAnchor.constraint(equalTo: self.storyLabelImageView.bottomAnchor, constant: 20).isActive = true
        self.storyCollectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        //self.storyCollectionView.heightAnchor.constraint(equalToConstant: self.storyCollectionView.contentSize.height).isActive = true
//        self.storyCollectionView.heightAnchor.constraint(equalTo: self.storyCollectionView.contentSize.height, multiplier: 1).isActive = true
        
        
//        self.drawnSwipeForMoreButton.topAnchor.constraint(equalTo: self.storyCollectionView.bottomAnchor, constant: 15).isActive = true
//        self.drawnSwipeForMoreButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
//        self.drawnSwipeForMoreButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2).isActive = true
//        self.drawnSwipeForMoreButton.heightAnchor.constraint(equalTo: self.drawnSwipeForMoreButton.widthAnchor, multiplier: 0.5).isActive = true
        
    }
    
    
    
    // MARK: - Lazy Initialization
    
    lazy var profileScrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view: UIView = UIView() 
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var profileFrameImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        //imageView.contentMode = .scaleAspectFill
        //imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "clear_polaroid")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var noTapeProfileFrameImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        //imageView.contentMode = .scaleAspectFill
        //imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "no_tape_polaroid")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var pencilEditButton: UIButton = {
        let button: UIButton = UIButton()
        //button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(self.tappedEditButton), for: .touchUpInside)
        //button.imageView?.contentMode = .scaleAspectFill
        //button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "pencil"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var keySubButton: UIButton = {
        let button: UIButton = UIButton()
        //button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(self.tappedSubscribeButton), for: .touchUpInside)
        //button.imageView?.contentMode = .scaleAspectFill
        //button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "key"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var drawnNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        //label.textColor = .black
        label.font = UIFont(name: AppDelegate.shared.fontName, size: self.fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "USERNAME:"
        return label
    }()
    
    lazy var actualNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        //label.textColor = .black
        label.font = UIFont(name: AppDelegate.shared.fontName, size: self.fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.text = "NAME:"
        return label
    }()
    
    lazy var drawnSubsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        //label.textColor = .black
        label.font = UIFont(name: AppDelegate.shared.fontName, size: self.fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SUBSCRIBERS:"
        //label.isHidden = true
        return label
    }()
    
    lazy var actualSubsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        //label.textColor = .black
        label.font = UIFont(name: AppDelegate.shared.fontName, size: self.fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.isHidden = true
        return label
    }()
    
    lazy var profilePicImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        //imageView.contentMode = .scaleAspectFill
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var storyPicImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        //imageView.contentMode = .scaleAspectFill
        //imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var coinsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        //label.textColor = .white
        label.font = UIFont(name: AppDelegate.shared.fontName, size: self.fontSize)
        label.text = "Coins: 0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var coinsEarnedLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        //label.textColor = .white
        label.font = UIFont(name: AppDelegate.shared.fontName, size: self.fontSize)
        label.text = "Earned: 0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var followersLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        //label.textColor = .white
        label.font = UIFont(name: AppDelegate.shared.fontName, size: self.fontSize)
        label.text = "Followers: 0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var followingLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        //label.textColor = .white
        label.font = UIFont(name: AppDelegate.shared.fontName, size: self.fontSize)
        label.text = "Following: 0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var drawnFollowButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(#imageLiteral(resourceName: "FollowUnpressedEdit"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "FollowEdited"), for: .highlighted)
        button.addTarget(self, action: #selector(self.tappedFollowButton), for: .touchUpInside)
        button.addTarget(self, action: #selector(self.buttonHeldDown), for: .touchDown)
        button.addTarget(self, action: #selector(self.buttonLetGo), for: .touchDragExit)
        //button.imageView?.contentMode = .scaleAspectFill
        //button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 0
        return button
    }()
    
    lazy var drawnUnFollowButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(#imageLiteral(resourceName: "UnfollowUnpressed"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "Unfollow"), for: .highlighted)
        button.addTarget(self, action: #selector(self.tappedUnfollowButton), for: .touchUpInside)
        button.addTarget(self, action: #selector(self.buttonHeldDown), for: .touchDown)
        button.addTarget(self, action: #selector(self.buttonLetGo), for: .touchDragExit)
        //button.imageView?.contentMode = .scaleAspectFill
        //button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 1
        return button
    }()
    
    lazy var drawnSwipeForMoreButton: UIImageView = {
        let thisImageView: UIImageView = UIImageView()
        thisImageView.image = #imageLiteral(resourceName: "swipeRightForMore")
        thisImageView.translatesAutoresizingMaskIntoConstraints = false
        thisImageView.isHidden = true
        return thisImageView
    }()
    
    
    /////////////////////////// OLD PROFILE STUFF ////////////////////////////////////////////////////////////////
    lazy var backgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "crumpled")
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
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // APPSTORE: REMOVING FOR V1
//    lazy var settingsButton: UIButton = {
//        let button: UIButton = UIButton()
//        button.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
//        button.addTarget(self, action: #selector(self.tappedSettingsButton), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
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
    
    lazy var editButton: TIPButton = {
        let button: TIPButton = TIPButton(style: .green)
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: UIFontWeightMedium)
        button.addTarget(self, action: #selector(self.tappedEditButton), for: .touchUpInside)
        button.clipsToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var followButton: TIPButton = {
        let button: TIPButton = TIPButton(style: .green)
        button.setTitle("Follow", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: UIFontWeightMedium)
        button.addTarget(self, action: #selector(self.tappedFollowButton), for: .touchUpInside)
        button.clipsToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true // Follow will be hidden if profile is current user
        return button
    }()
    
    lazy var subscribeButton: TIPButton = {
        let button: TIPButton = TIPButton(style: .green)
        button.setTitle("Subscribe", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: UIFontWeightMedium)
        button.addTarget(self, action: #selector(self.tappedSubscribeButton), for: .touchUpInside)
        button.clipsToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true // Subscribe will be hidden if profile is current user
        return button
    }()
    
    lazy var storyLabelImageView : UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "my_story")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var storyCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
        
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
//        collectionView.addTarget(self, action: #selector(self.isDragging), for: .valueChanged)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
       


        return collectionView
    }()
    
    
    // APPSTORE: REMOVING FOR V1
//
//    lazy var followersButton: UIButton = {
//        let button: UIButton = UIButton()
//        button.backgroundColor = .magenta
//        button.addTarget(self, action: #selector(self.tappedFollowersButton(sender:)), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    lazy var followingButton: UIButton = {
//        let button: UIButton = UIButton()
//        button.backgroundColor = .purple
//        button.addTarget(self, action: #selector(self.tappedFollowingButton(sender:)), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    lazy var followersCountLabel: UILabel = self.valueLabel(value: "0")
//    lazy var followersSubtitleLabel: UILabel = self.subtitleLabel(subtitle: "followers")
//    lazy var followingCountLabel: UILabel = self.valueLabel(value: "0")
//    lazy var followingSubtitleLabel: UILabel =  self.subtitleLabel(subtitle: "following")
//    lazy var coinsCountLabel: UILabel = self.valueLabel(value: "0")
//    lazy var coinsSubtitleLabel: UILabel = self.subtitleLabel(subtitle: "coins")
    
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
        button.layer.borderColor = UIColor.iroBlue.cgColor
        button.addTarget(self, action: #selector(self.tappedStoryPreviewButton), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
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
    
    
//    func setUpConstraints() {
//        
//        self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        self.backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        self.backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        self.backgroundImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//        
//        self.shadeView.topAnchor.constraint(equalTo: self.backgroundImageView.topAnchor).isActive = true
//        self.shadeView.bottomAnchor.constraint(equalTo: self.backgroundImageView.bottomAnchor).isActive = true
//        self.shadeView.leftAnchor.constraint(equalTo: self.backgroundImageView.leftAnchor).isActive = true
//        self.shadeView.rightAnchor.constraint(equalTo: self.backgroundImageView.rightAnchor).isActive = true
//        
//        self.profileImageButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0).isActive = true
//        self.profileImageButton.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
//        self.profileImageButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
//        self.profileImageButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        
//        // APPSTORE: REMOVING FOR V1
//        
////        self.settingsButton.centerYAnchor.constraint(equalTo: self.profileImageButton.centerYAnchor).isActive = true
////        self.settingsButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10.0).isActive = true
////        self.settingsButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
////        self.settingsButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
//        
//        self.nameLabel.topAnchor.constraint(equalTo: self.profileImageButton.bottomAnchor, constant: 10.0).isActive = true
//        self.nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        
//        self.usernameLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 10.0).isActive = true
//        self.usernameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//    
//        self.editButton.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor, constant: 15.0).isActive = true
//        self.editButton.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
//        self.editButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
//        self.editButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//
//        self.followButton.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor, constant: 15.0).isActive = true
//        self.followButton.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
//        self.followButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
//        self.followButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        
//        self.subscribeButton.topAnchor.constraint(equalTo: self.storyPreviewButton.bottomAnchor, constant: 30).isActive = true
//        self.subscribeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        self.subscribeButton.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
//        self.subscribeButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
//        
//        self.coinsLabel.topAnchor.constraint(equalTo: self.subscribeButton.bottomAnchor, constant: 10.0).isActive = true
//        self.coinsLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        
//        self.coinsEarnedLabel.topAnchor.constraint(equalTo: self.coinsLabel.bottomAnchor, constant: 10.0).isActive = true
//        self.coinsEarnedLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        // APPSTORE: REMOVING FOR V1
////
////        self.followersButton.topAnchor.constraint(equalTo: self.followersCountLabel.topAnchor).isActive = true
////        self.followersButton.bottomAnchor.constraint(equalTo: self.followersSubtitleLabel.bottomAnchor).isActive = true
////        self.followersButton.leftAnchor.constraint(equalTo: self.followersSubtitleLabel.leftAnchor).isActive = true
////        self.followersButton.rightAnchor.constraint(equalTo: self.followersSubtitleLabel.rightAnchor).isActive = true
////        
////        self.followingButton.topAnchor.constraint(equalTo: self.followingCountLabel.topAnchor).isActive = true
////        self.followingButton.bottomAnchor.constraint(equalTo: self.followingSubtitleLabel.bottomAnchor).isActive = true
////        self.followingButton.leftAnchor.constraint(equalTo: self.followingSubtitleLabel.leftAnchor).isActive = true
////        self.followingButton.rightAnchor.constraint(equalTo: self.followingSubtitleLabel.rightAnchor).isActive = true
////        
////        self.followingCountLabel.topAnchor.constraint(equalTo: self.editButton.bottomAnchor, constant: 20.0).isActive = true
////        self.followingCountLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
////        
////        self.followersCountLabel.topAnchor.constraint(equalTo: self.followingCountLabel.topAnchor).isActive = true
////        self.followersCountLabel.rightAnchor.constraint(equalTo: self.followingCountLabel.leftAnchor, constant: -60.0).isActive = true
////        
////        self.coinsCountLabel.topAnchor.constraint(equalTo: self.followingCountLabel.topAnchor).isActive = true
////        self.coinsCountLabel.leftAnchor.constraint(equalTo: self.followingCountLabel.rightAnchor, constant: 60.0).isActive = true
////        
////        self.followersSubtitleLabel.topAnchor.constraint(equalTo: self.followersCountLabel.bottomAnchor).isActive = true
////        self.followersSubtitleLabel.centerXAnchor.constraint(equalTo: self.followersCountLabel.centerXAnchor).isActive = true
////        
////        self.followingSubtitleLabel.topAnchor.constraint(equalTo: self.followingCountLabel.bottomAnchor).isActive = true
////        self.followingSubtitleLabel.centerXAnchor.constraint(equalTo: self.followingCountLabel.centerXAnchor).isActive = true
////        
////        self.coinsSubtitleLabel.topAnchor.constraint(equalTo: self.coinsCountLabel.bottomAnchor).isActive = true
////        self.coinsSubtitleLabel.centerXAnchor.constraint(equalTo: self.coinsCountLabel.centerXAnchor).isActive = true
//        
//        self.storyPreviewButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
//        self.storyPreviewButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        self.storyPreviewButton.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
//        self.storyPreviewButton.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
//        
//        
////        self.storyImageView.heightAnchor.constraint(equalTo: self.myWalletImageView.widthAnchor, multiplier: 0.2).isActive = true
//    }
    
    // MARK: - Actions
    
    func DidScroll(collectionView: UICollectionView)
    {
        if (collectionView.isDragging == true)
        {
            self.drawnSwipeForMoreButton.isHidden = true
        }
    }
    
    func tappedPencilButton() {
        print("PENCIL TAPPED")
    }
    
    func tappedStoryPreviewButton() {
        //let username: String = TIPUser.currentUser?.username ?? ""
        print("STORY: \(self.story)")
        
        if self.story?.posts.isEmpty == true{
            return
        }
        
        if let currentStory: TIPStory = self.story {
            let storyViewController: TIPStoryViewController = TIPStoryViewController(story: currentStory, username: self.actualNameLabel.text, profileImage: self.profilePicImageView.image, userID: self.userId!, postIndex: 0)
            self.present(storyViewController, animated: true, completion: nil)
            
        }
    }
    
    func tappedProfileButton() {
        if self.userId == TIPUser.currentUser?.userId {
            self.showPhotoActionSheet()
        }
    }
    
    func tappedSettingsButton() {
        
        let settingsViewController: TIPSettingsViewController = TIPSettingsViewController()
        let settingsNavController: UINavigationController = UINavigationController(rootViewController: settingsViewController)
        self.present(settingsNavController, animated: true, completion: nil)
    }
    
    override func imagePickerSelectedImage(image: UIImage) {
        TIPUser.currentUser?.profileImage = image
        TIPUser.currentUser?.save()
        self.profileImageButton.setImage(image, for: .normal)
        if let data: Data = UIImageJPEGRepresentation(image, 0.5) {
            TIPAPIClient.updateUserImage(data: data, type: .profile) { (success: Bool) in
                //
            }
        }
    }
        
    func tappedEditButton() {
        let editProfileViewController: TIPEditProfileViewController = TIPEditProfileViewController(style: .grouped)
        let editNavController: UINavigationController = UINavigationController(rootViewController: editProfileViewController)
        self.present(editNavController, animated: true, completion: nil)
    }
    
    func tappedFollowButton() {
        if let userId: String = userId {
            self.follow(userId: userId)
            self.drawnUnFollowButton.isHidden = false
            self.drawnFollowButton.isHidden = true
            self.followButtonTop?.constant = 30
//            if followButton.titleLabel?.text == "Follow" {
//                self.showUnfollowButton()
//                self.follow(userId: userId)
//            } else if followButton.titleLabel?.text == "Unfollow" {
//                self.showFollowButton()
//                self.unfollow(userId: userId)
//            }
        }
    }
    
    func tappedUnfollowButton() {
            if let userId: String = userId {
                self.unfollow(userId: userId)
            }
        self.drawnUnFollowButton.isHidden = true
        self.drawnFollowButton.isHidden = false
        self.unFollowButtonTop?.constant = 30
}
    
    func tappedSubscribeButton() {
        if let userId: String = self.userId {
            

            if TIPUser.currentUser?.subscribedTo?.contains(userId) == true {
                self.unsubscribe(userId: userId)
                self.showAlert(title: "Unsubbed", message: nil, completion: { 
                    //
                })
            } else {
                self.subscribe(userId: userId)
            }
            
        }
    }
    
//    func showSubscribeAlert() -> Bool {
//        let alert: UIAlertController = UIAlertController(
//            title: "Subscribe",
//            message: "Subscribe to \(self.usernameLabel.text!)?",
//            preferredStyle: .alert
//        )
//        let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { (action) in
//            
//            
//        }
//        
//        let noAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
//            //
//        }
//        alert.addAction(yesAction)
//        alert.addAction(noAction)
//        self.present(alert, animated: true, completion: nil)
//    }
    
    func showUnsubscribeButton() {
        self.subscribeButton.setTitle("Unsubscribe", for: .normal)
        self.subscribeButton.configure(style: .white)
        
    }
    
    func showSubscribeButton() {
        self.subscribeButton.setTitle("Subscribe", for: .normal)
        self.subscribeButton.configure(style: .green)
        
    }
    
    func subscribe(userId: String) {
        
        self.showLockedAlert()
    }
    
    func unsubscribe(userId: String) {
        TIPAPIClient.userAction(action: .unsubscribe, userId: userId) { (success: Bool) in
            if success == true {
                let index = TIPUser.currentUser?.subscribedTo?.index(of: userId)
                TIPUser.currentUser?.subscribedTo?.remove(at: index!)
                TIPUser.currentUser?.save()
            } else {
                print("COULD NOT UNSUBSCRIBE")
            }
        }
    }
    
    func showUnfollowButton() {
        self.followButton.setTitle("Unfollow", for: .normal)
        self.followButton.configure(style: .white)

    }
    
    func follow(userId: String) {
//        self.drawnFollowButton.isHidden = true
        TIPAPIClient.userAction(action: .follow, userId: userId, completionHandler: { (success: Bool) in
            //
        })
    }
    
    func showFollowButton() {
        self.followButton.setTitle("Follow", for: .normal)
        self.followButton.configure(style: .green)

    }
    
    func unfollow(userId: String) {
        print("BRAD USER ID: \(userId)")
        TIPAPIClient.userAction(action: .unfollow, userId: userId, completionHandler: { (success: Bool) in
            //
        })
    }
    
    func tappedFollowersButton(sender: UIButton) {
        let followersViewController: TIPFollowersViewController = TIPFollowersViewController()
        self.navigationController?.pushViewController(followersViewController, animated: true)
    }
    
    func tappedFollowingButton(sender: UIButton) {
        let followingViewController: TIPFollowingViewController = TIPFollowingViewController()
        self.navigationController?.pushViewController(followingViewController, animated: true)
    }
    
//    func pullDownPressed() {
//        
//        if self.pullDownMenuBottom?.constant == (self.navigationController?.navigationBar.frame.size.height)! * 1.25 {
//            self.pullDownMenuBottom?.constant += (self.pullDownView.bounds.size.height - (self.navigationController?.navigationBar.frame.size.height)! * 1.25)
//        } else {
//            self.pullDownMenuBottom?.constant = (self.navigationController?.navigationBar.frame.size.height)! * 1.25
//        }
//        
//        UIView.animate(withDuration: 0.5, animations: { [weak self] in
//            self?.view.layoutIfNeeded()
//        }) { (completed: Bool) in
//            
//        }
//    }
    
    func buttonHeldDown(button: UIButton) {
        
        switch button.tag {
        case 0:
            self.followButtonTop?.constant += 5
        case 1:
            self.unFollowButtonTop?.constant += 5

        default:
            break
        }
        
        
    }
    
    func buttonLetGo(button: UIButton) {
        
        switch button.tag {
        case 0:
            self.followButtonTop?.constant = 30
        case 1:
            self.unFollowButtonTop?.constant = 30
        default:
            break
        }
        
    }
       // self.followButtonTop?.constant = 30
        
    
    
    func showLockedAlert() {
        
        if self.coinsToSub == nil {
            self.coinsToSub = 1000
        }
        
        let alert: UIAlertController = UIAlertController(
            title: "Subscribe",
            message: "Subscribe to \(self.username!) for \(self.coinsToSub!) coins?",
            preferredStyle: .alert
        )
        let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            if (TIPUser.currentUser?.coins)! < self.coinsToSub! {
                print("not enough coins")
                self.showAlert(title: "Oops!", message: "Not Enough Coins", completion: {
                    //
                })
                return
            }
            
            TIPAPIClient.updateUserCoins(coinsToAdd: self.coinsToSub!, userID: self.userId!, completionHandler: { (success: Bool) in
                
                if success == true {
                    
                    let parameters: [String: Any] = [
                        "coins" : ((TIPUser.currentUser?.coins)! - self.coinsToSub!)
                    ]
                    
                    TIPAPIClient.updateUser(parameters: parameters, completionHandler: { (success: Bool) in
                        
                        if success == true {
                            
                            TIPAPIClient.userAction(action: .subscribe, userId: self.userId!, completionHandler: { (success: Bool) in
                                if success == true {
                                    print("SUCCESS")
                                    //self.isSubscribed = true
                                    
                                    //TIPUser.currentUser?.coins -= 1000
                                    TIPUser.currentUser?.subscribedTo?.append(self.userId!)
                                    TIPUser.currentUser?.save()
                                    self.storyCollectionView.reloadData()
                                    self.showAlert(title: "Thanks!", message: "You are now subbed!", completion: {
                                        //
                                    })
                                } else {
                                    print("ERROR SUBSCRIBING")
                                }
                                
                            })
                            
                        }
                        
                    })
                    
                } else {
                    print("ERROR ADDING COINS")
                }
                
            })
            
            
        }
        
        let noAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    


}



extension TIPProfileViewController: UICollectionViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        let scrollWidth = scrollView.frame.size.width
        
        
        
//        let scrollOffset = scrollView.contentOffset.y;
        
        
//        if scrollOffset <  10 || (self.storyURLArray?.count)! > 9 {
        
//            self.drawnSwipeForMoreButton.isHidden = false

            
//        }else{
        
        self.drawnSwipeForMoreButton.isHidden = true
//        }
    }
    
  }


extension TIPProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return filters.count
        if nil == self.storyURLArray?.count{
            return 0
        } else {
            return self.storyURLArray!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell: TIPProfileStoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.profileReuseID, for: indexPath) as! TIPProfileStoryCollectionViewCell

        let currentPost = self.storyURLArray?[indexPath.item]
        
        var isSubbed: Bool = false
        
        if let subbedTo = TIPUser.currentUser?.subscribedTo {
            for sub in subbedTo{
                if sub == self.userId {
                    isSubbed = true
                }
            }
        }
        
        if isSubbed == true || currentPost?.isPrivate == false || self.userId == TIPUser.currentUser?.userId {
            cell.blurView.isHidden = true
            cell.lockImageView.isHidden = true
        } else {
            cell.blurView.isHidden = false
            cell.lockImageView.isHidden = false
        }
        
        if self.storyURLArray == nil {
            cell.storyImage.image = #imageLiteral(resourceName: "blue_crumpled")
        } else {
            
            cell.storyImage.image = #imageLiteral(resourceName: "red_crumpled")
            
                if currentPost?.type == .video && currentPost?.contentImage == nil {
                    
                    DispatchQueue.global(qos: .background).async {
                        let img = TIPAPIClient.imageFromVideo(urlString: (self.storyURLArray?[indexPath.item].contentURL)!, at: 0)
                        DispatchQueue.main.async {
                            cell.storyImage.image = img
                        }
                    }
                    
                } else {
                    
                    cell.storyImage.image = self.storyURLArray?[indexPath.item].contentImage
                }
            
        }
        
       return cell
    }
        

//    func collectionView
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        

        
            if let currentStory: TIPStory = self.story {
                let storyViewController: TIPStoryViewController = TIPStoryViewController(story: currentStory, username: self.actualNameLabel.text, profileImage: self.profilePicImageView.image, userID: self.userId!, postIndex: indexPath.item)
                self.present(storyViewController, animated: true, completion: nil)
                
            }
            
        }

        
    }




extension TIPProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
      //let size =  CGSize(width: (collectionView.bounds.height - 10) / 3.13 , height: (collectionView.bounds.height)/3.035)
        let size =  CGSize(width: (collectionView.bounds.width - 10) / 2.95 , height: (collectionView.bounds.width - 10) / 3)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}

