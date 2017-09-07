//
//  TIPFeedCollectionViewCell.swift
//  Ironc.ly
//

import UIKit

protocol TIPFeedCollectionViewCellDelegate: class {
    func feedCellDidSelectItem(feedItem: TIPFeedItem)
    func feedCellDidTip(feedItem: TIPFeedItem, coins: Int)
    func feedCellDidTapSubscribe(feedItem: TIPFeedItem, cell: TIPFeedCollectionViewCell)
}

class TIPFeedCollectionViewCell: TIPStoryCollectionViewCell {
    
    var feedItem: TIPFeedItem?
    weak var delegate: TIPFeedCollectionViewCellDelegate?
    
    var sliderXAnchor: NSLayoutConstraint?
    var profileImageAnchor: NSLayoutConstraint?
    var usernameAnchor: NSLayoutConstraint?
    
    var coinsToTip: Float = 0
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(self.tipButton)
        //self.contentView.addSubview(self.sliderBarImageView)
        //self.contentView.addSubview(self.sliderImageView)
        self.contentView.addSubview(self.sliderView)
        self.contentView.addSubview(self.coinsLabel)
        self.contentView.addSubview(self.triangleButton)
        self.contentView.addSubview(self.followButton)
        self.contentView.addSubview(self.subscribeButton)
        self.contentView.bringSubview(toFront: self.profileImageView)
        self.contentView.bringSubview(toFront: self.usernameLabel)
        
        
        self.setUpFeedConstraints()
        self.setUpConstraints()
        self.contentView.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with feedItem: TIPFeedItem) {
        self.feedItem = feedItem
        
        print("FEED ITEM PIC URL: \(feedItem.storyImage)")
        
        self.usernameLabel.text = feedItem.username
        
        guard let user: TIPUser = TIPUser.currentUser else { return }
        
        var isSubbed: Bool = false
        
        if let subbedTo = user.subscribedTo {
            for sub in subbedTo{
                if sub == feedItem.userId {
                    isSubbed = true
                }
            }
        }
        
        if isSubbed == true {
            self.subscribeButton.isHidden = true
        } else {
            self.subscribeButton.isHidden = false
        }
        
        if feedItem.isPrivate == false || isSubbed == true {
            self.blurView.isHidden = true
            self.lockImageView.isHidden = true
        } else {
            self.blurView.isHidden = false
            self.lockImageView.isHidden = false
        }
        
//        self.postImageView.alpha = 0.0
//        UIImage.download(urlString: feedItem.storyImage) { (image: UIImage?) in
//            self.postImageView.image = image
//            UIView.animate(withDuration: 0.4, animations: {
//                self.postImageView.alpha = 1.0
//            })
//        }
//
//        UIImage.download(urlString: feedItem.profileImageURL, placeHolder: #imageLiteral(resourceName: "empty_profile"), completion: { (image: UIImage?) in
//            self.profileImageView.image = image
//        })
        
        
//        if let profileURL = feedItem.profileImageURL {
//            self.profileImageView.loadImageUsingCacheFromUrlString(urlString: profileURL, placeHolder: UIImage(named: "empty_profile")!) {}
//        } else {
//            self.profileImageView.loadImageUsingCacheFromUrlString(urlString: "no image", placeHolder: UIImage(named: "empty_profile")!) {}
//        }
        
//        self.postImageView.loadImageUsingCacheFromUrlString(urlString: feedItem.storyImage, placeHolder: UIImage(named: "empty_profile")!, completion: )
    
//        self.postImageView.loadImageUsingCacheFromUrlString(urlString: feedItem.storyImage, placeHolder: nil) {
//            
//            if (self.postImageView.image == nil) && (feedItem.storyImage.contains(".mp4")) {
//                
//                DispatchQueue.global(qos: .background).async {
//                    let image = TIPAPIClient.testImageFromVideo(urlString: feedItem.storyImage, at: 0)
//                    DispatchQueue.main.async {
//                       self.postImageView.image = image
//                    }
//                }
//                
//            }
//            
//            UIView.animate(withDuration: 0.4, animations: {
//                self.postImageView.alpha = 1.0
//            })
//            
//            
//        }
        
        if let actualImage = feedItem.actualStoryImage {
            self.postImageView.image = actualImage
        }
        
        if let actualProfileImage = feedItem.profileImage {
            self.profileImageView.image = actualProfileImage
        }
    }
    
    override func prepareForReuse() {
        self.profileImageView.image = nil
        self.postImageView.image = nil
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.gradient.frame = self.bounds
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2.0
        self.postImageView.layer.insertSublayer(self.gradient, at: 0)
    }
    
    // MARK: - Lazy Initialization
    lazy var gradient: CAGradientLayer = {
        let layer: CAGradientLayer = CAGradientLayer()
        let black: UIColor = UIColor(white: 0.0, alpha: 0.5)
        layer.colors = [black.cgColor, UIColor.clear.cgColor]
        layer.locations = [0.0, 0.2]
        return layer
    }()
    
    lazy var favoriteImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var favoriteLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var privateImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var privateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var tipButton: UIButton = {
        let button: UIButton = UIButton()
        //button.setTitle("Sign up", for: .normal)
        button.addTarget(self, action: #selector(self.tappedTipButton), for: .touchUpInside)
        //button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "tip_button"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "tip_button_pressed"), for: .highlighted)
        //button.addTarget(self, action: #selector(self.buttonHeldDown), for: .touchDown)
        //button.addTarget(self, action: #selector(self.buttonLetGo), for: .touchDragExit)
        button.tag = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var triangleButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(#imageLiteral(resourceName: "triangle_button"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "triangle_button_pressed"), for: .highlighted)
        button.addTarget(self, action: #selector(self.tappedProfileButton(sender:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(self.buttonHeldDown), for: .touchDown)
        button.addTarget(self, action: #selector(self.buttonLetGo), for: .touchDragExit)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var followButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(#imageLiteral(resourceName: "followPress"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "followDepress"), for: .highlighted)
        //button.addTarget(self, action: #selector(self.tappedProfileButton(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    lazy var subscribeButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(#imageLiteral(resourceName: "subscribeDepress"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "subscribePress"), for: .highlighted)
        button.addTarget(self, action: #selector(self.tappedSubButton(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.isHidden = true
        return button
    }()
    
    lazy var sliderView: UISlider = {
        let slider: UISlider = UISlider()
        slider.setThumbImage(#imageLiteral(resourceName: "small_slider"), for: .normal)
        slider.addTarget(self, action: #selector(self.sliderValueChanged), for: .valueChanged)
        slider.minimumTrackTintColor = .black
        slider.maximumTrackTintColor = .black
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    lazy var coinsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont(name: AppDelegate.shared.fontName, size: AppDelegate.shared.fontSize)
        label.text = "0 Coins"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Autolayout
    override func setUpConstraints() {
        //super.setUpConstraints()
        
        
//        let hMargin: CGFloat = 15.0
        
//        self.usernameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 18.0).isActive = true
//        self.usernameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15.0).isActive = true
//        self.usernameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
//        self.usernameLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
        
        usernameAnchor = self.usernameLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        usernameAnchor?.isActive = true
        self.usernameLabel.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 2).isActive = true
//        self.usernameLabel.bottomAnchor.constraint(equalTo: self.postImageView.topAnchor, constant: -10).isActive = true
        
//        self.profileImageView.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor, constant: 12.0).isActive = true
//        self.profileImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: hMargin).isActive = true
//        self.profileImageView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
//        self.profileImageView.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        profileImageAnchor = self.profileImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 0)
        profileImageAnchor?.isActive = true
        self.profileImageView.centerYAnchor.constraint(equalTo: self.triangleButton.centerYAnchor, constant: 0).isActive = true
        self.profileImageView.heightAnchor.constraint(equalTo: self.triangleButton.heightAnchor, multiplier: 0.45).isActive = true
        self.profileImageView.widthAnchor.constraint(equalTo: self.profileImageView.heightAnchor, multiplier: 1).isActive = true
        
//        self.profileButton.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
//        self.profileButton.bottomAnchor.constraint(equalTo: self.profileImageView.bottomAnchor).isActive = true
//        self.profileButton.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
//        self.profileButton.rightAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: hMargin).isActive = true

        
        self.tipButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: -self.contentView.frame.size.width/3).isActive = true
        self.tipButton.topAnchor.constraint(equalTo: self.postImageView.bottomAnchor, constant: 10).isActive = true
        self.tipButton.heightAnchor.constraint(equalTo: self.profileImageView.heightAnchor, multiplier: 1.5).isActive = true
        self.tipButton.widthAnchor.constraint(equalTo: self.tipButton.heightAnchor).isActive = true
        
        self.sliderView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: self.contentView.frame.size.width/6).isActive = true
        self.sliderView.topAnchor.constraint(equalTo: self.postImageView.bottomAnchor, constant: 15).isActive = true
        self.sliderView.heightAnchor.constraint(equalTo: self.tipButton.heightAnchor, multiplier: 1).isActive = true
        self.sliderView.widthAnchor.constraint(equalTo: self.postImageView.widthAnchor, multiplier: 0.5).isActive = true
        //self.sliderView.currentThumbImage?.size
        
        self.coinsLabel.topAnchor.constraint(equalTo: self.sliderView.bottomAnchor, constant: 0).isActive = true
        self.coinsLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: self.contentView.frame.size.width/6).isActive = true
        
        self.triangleButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 5).isActive = true
        self.triangleButton.bottomAnchor.constraint(equalTo: self.postImageView.topAnchor, constant: -2).isActive = true
        self.triangleButton.heightAnchor.constraint(equalTo: self.postImageView.heightAnchor, multiplier: 0.3).isActive = true
        self.triangleButton.widthAnchor.constraint(equalTo: self.triangleButton.heightAnchor, multiplier: 1.25).isActive = true
        
        self.followButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: -self.contentView.frame.size.width/3).isActive = true
        self.followButton.bottomAnchor.constraint(equalTo: self.postImageView.topAnchor, constant: -8).isActive = true
        self.followButton.heightAnchor.constraint(equalTo: self.profileImageView.heightAnchor, multiplier: 0.8).isActive = true
        self.followButton.widthAnchor.constraint(equalTo: self.followButton.heightAnchor, multiplier: 1.8).isActive = true
        
        self.subscribeButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: self.contentView.frame.size.width/3).isActive = true
        self.subscribeButton.bottomAnchor.constraint(equalTo: self.postImageView.topAnchor, constant: -8).isActive = true
        self.subscribeButton.heightAnchor.constraint(equalTo: self.profileImageView.heightAnchor, multiplier: 0.8).isActive = true
        self.subscribeButton.widthAnchor.constraint(equalTo: self.subscribeButton.heightAnchor, multiplier: 2.3).isActive = true
        
    }
    
    func setUpFeedConstraints() {
//        self.postImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 25).isActive = true
//        self.postImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 25).isActive = true
        self.postImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.postImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.6).isActive = true
        self.postImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.postImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        
        self.blurView.topAnchor.constraint(equalTo: self.postImageView.topAnchor).isActive = true
        self.blurView.bottomAnchor.constraint(equalTo: self.postImageView.bottomAnchor).isActive = true
        self.blurView.leftAnchor.constraint(equalTo: self.postImageView.leftAnchor).isActive = true
        self.blurView.rightAnchor.constraint(equalTo: self.postImageView.rightAnchor).isActive = true
        
        self.lockImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.lockImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.lockImageView.widthAnchor.constraint(equalToConstant: self.contentView.bounds.size.width/3).isActive = true
        self.lockImageView.heightAnchor.constraint(equalTo: self.lockImageView.widthAnchor).isActive = true
    }
    
    func buttonHeldDown() {
        profileImageAnchor?.constant += 5
        usernameAnchor?.constant += 5
    }
    
    func buttonLetGo() {
        profileImageAnchor?.constant = 0
        usernameAnchor?.constant = 0
    }
    
    func sliderValueChanged(slider: UISlider) {
        
        let value: Float = slider.value
        let multiply: Float = 10000
        
        coinsToTip = value * multiply
        coinsToTip = 500.0 * floor((coinsToTip/500.0)+0.5)
        self.coinsLabel.text = "\(Int(coinsToTip.rounded())) Coins"
        
        let minToAdd = coinsToTip.rounded() / 10
        //print("MIN TO ADD: \(minToAdd)")
    }
    
    override func tappedProfileButton(sender: UIButton) {
    
        profileImageAnchor?.constant = 0
        usernameAnchor?.constant = 0
        
        if let feedItem: TIPFeedItem = self.feedItem {
            self.delegate?.feedCellDidSelectItem(feedItem: feedItem)
        }
    }
    
    func tappedTipButton() {
        if let feedItem: TIPFeedItem = self.feedItem {
            self.delegate?.feedCellDidTip(feedItem: feedItem, coins: Int(self.coinsToTip.rounded()))
        }
    }
    
    func tappedSubButton(sender: UIButton) {
        
        let theCell = self as? TIPFeedCollectionViewCell
        
        if let feedItem: TIPFeedItem = self.feedItem {
            self.delegate?.feedCellDidTapSubscribe(feedItem: feedItem, cell: theCell!)
        }
    }
    
}
