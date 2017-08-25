//
//  TIPPersonalProfileViewController.swift
//  Ironc.ly
//

import UIKit

class TIPPersonalProfileViewController: TIPProfileViewController {

    var buyCoinsTop: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.contentView.addSubview(self.myWalletImageView)
        self.contentView.addSubview(self.coinsImageView)
        self.contentView.addSubview(self.coinsLabel)
        self.contentView.addSubview(self.coinsEarnedLabel)
        self.contentView.addSubview(self.buyCoinsButton)
        self.setUpPersonalConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.userId = TIPUser.currentUser?.userId
        
        super.viewWillAppear(animated)
        
        guard let user: TIPUser = TIPUser.currentUser else {
            return
        }
        
        self.followers = user.followersList
        self.following = user.followingList
        
        self.drawnSubsLabel.isHidden = false
        self.actualSubsLabel.isHidden = false
        self.coinsLabel.isHidden = false
        self.coinsEarnedLabel.isHidden = false
        self.keySubButton.isHidden = true
        
        self.buyCoinsTop?.constant = 20
        
        if let mySubs = user.subscribers {
            self.actualSubsLabel.text = "\(mySubs.count)"
        } else {
            self.actualSubsLabel.text = "0"
        }
        
        if let myFollowers = self.followers {
            self.followersLabel.text = "Followers: \(myFollowers.count)"
        } else {
            self.followersLabel.text = "Followers: 0"
        }
        
        if let following = self.following {
            self.followingLabel.text = "Following: \(following.count)"
        } else {
            self.followingLabel.text = "Following: 0"
        }
        
        self.nameLabel.text = user.fullName
        self.actualNameLabel.text = user.username
        self.coinsLabel.text = "Coins: \(user.coins)"
        
        if let coinsEarned = user.coinsEarned {
            self.coinsEarnedLabel.text = "Coins Earned: \(coinsEarned)"
        } else {
            self.coinsEarnedLabel.text = "Coins Earned: 0"
        }
        
        
//        if(TIPUser.currentUser?.profileImage != nil){
//            //self.profileImageButton.setImage(TIPUser.currentUser?.profileImage, for: .normal)
//            self.profilePicImageView.image = TIPUser.currentUser?.profileImage
//        } else {
//            UIImage.download(urlString: user.profileImageURL, placeHolder: #imageLiteral(resourceName: "empty_profile")) { (image: UIImage?) in
//                self.profilePicImageView.image = image
//                //self.profileImageButton.setImage(image, for: .normal)
//                TIPUser.currentUser?.profileImage = image
//                TIPUser.currentUser?.save()
//            }
//        }
        
        
        
        UIImage.loadImageUsingCache(urlString: user.profileImageURL, placeHolder: #imageLiteral(resourceName: "empty_profile"), completion: { (image) in
            //self.profileImageButton.setImage(image, for: .normal)
            self.profilePicImageView.image = image
        })
        
        
        
        
        
        if(TIPUser.currentUser?.backgroundImage != nil){
            self.backgroundImageView.image = TIPUser.currentUser?.backgroundImage
        } else {
            UIImage.download(urlString: user.backgroundImageURL, placeHolder: #imageLiteral(resourceName: "tipitbackground3_7")) { (image: UIImage?) in
                self.backgroundImageView.image = image
                TIPUser.currentUser?.backgroundImage = image
                TIPUser.currentUser?.save()
            }
        }
        
        self.getPersonalStory()
    }
    
    lazy var myWalletImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        //imageView.contentMode = .scaleAspectFill
        //imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "my_wallet")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var coinsImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        //imageView.contentMode = .scaleAspectFill
        //imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "coin_stack")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var buyCoinsButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(#imageLiteral(resourceName: "buy_coins"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "pressed_buy_coins"), for: .highlighted)
        button.addTarget(self, action: #selector(self.buyCoinsTapped), for: .touchUpInside)
        button.addTarget(self, action: #selector(self.buyCoinsHeldDown), for: .touchDown)
        button.addTarget(self, action: #selector(self.buyCoinsLetGo), for: .touchDragExit)
        //button.imageView?.contentMode = .scaleAspectFill
        //button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setUpPersonalConstraints() {
        
        self.myWalletImageView.topAnchor.constraint(equalTo: self.followingLabel.bottomAnchor, constant: 50.0).isActive = true
        self.myWalletImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.myWalletImageView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width/1.5).isActive = true
        self.myWalletImageView.heightAnchor.constraint(equalTo: self.myWalletImageView.widthAnchor, multiplier: 0.2).isActive = true
        
        self.coinsImageView.topAnchor.constraint(equalTo: self.myWalletImageView.bottomAnchor, constant: 20).isActive = true
        self.coinsImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.coinsImageView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width/3.5).isActive = true
        //self.coinsImageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        self.coinsImageView.heightAnchor.constraint(equalTo: self.coinsImageView.widthAnchor, constant: 1.5).isActive = true
        
        self.coinsLabel.topAnchor.constraint(equalTo: self.coinsImageView.bottomAnchor, constant: 20).isActive = true
        self.coinsLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.coinsEarnedLabel.topAnchor.constraint(equalTo: self.coinsLabel.bottomAnchor, constant: 20).isActive = true
        self.coinsEarnedLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        buyCoinsTop = self.buyCoinsButton.topAnchor.constraint(equalTo: self.coinsEarnedLabel.bottomAnchor, constant: 20)
        buyCoinsTop?.isActive = true
        self.buyCoinsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.buyCoinsButton.widthAnchor.constraint(equalToConstant: self.view.frame.size.width/2.5).isActive  = true
        self.buyCoinsButton.heightAnchor.constraint(equalTo: self.buyCoinsButton.widthAnchor, constant: 0.7).isActive = true
    }
    
    func getPersonalStory() {
        TIPAPIClient.getPersonalStory { (story: TIPStory?) in
            if let story: TIPStory = story {
                self.story = story
                if let firstPost: TIPPost = story.posts.first {
                    //self.storyPreviewButton.setImage(firstPost.contentImage, for: .normal)
                    self.storyPreviewButton.layer.borderWidth = 10.0
                } else {
                    self.storyPreviewButton.setImage(nil, for: .normal)
                    self.storyPreviewButton.layer.borderWidth = 0.0
                }
            } else {
                self.storyPreviewButton.setImage(nil, for: .normal)
                self.storyPreviewButton.layer.borderWidth = 0.0
            }
        }
    }
    
    func buyCoinsTapped() {
        let buyCoinsViewController: TIPBuyCoinsViewController = TIPBuyCoinsViewController(style: .grouped)
        //buyCoinsViewController.delegate = self
        let navigationController: UINavigationController = UINavigationController(rootViewController: buyCoinsViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func buyCoinsHeldDown() {
        self.buyCoinsTop?.constant += 10
    }
    
    func buyCoinsLetGo() {
        self.buyCoinsTop?.constant = 20
    }

}
