//
//  IROPostViewController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 2/2/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class IROPostViewController: UIViewController {
    
    let post: IROPost
    var videoURL: URL?
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    var isProfile: Bool = false // Set this so we don't add blur when you're viewing your own story
    
    lazy var tipViewTopAnchor: NSLayoutConstraint = self.tipView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.size.height)
    
    // MARK: - View Lifecycle
    init(post: IROPost, isProfile: Bool) {
        self.post = post
        self.isProfile = isProfile
    
        super.init(nibName: nil, bundle: nil)
        
        if post.type == .video {
            if let urlString: String = post.contentURL {
                if let url: URL = URL(string: urlString) {
                    self.view.backgroundColor = UIColor.gray
                    player = AVPlayer(url: url)
                    playerController = AVPlayerViewController()
                    
                    guard player != nil && playerController != nil else {
                        return
                    }
                    playerController!.showsPlaybackControls = false
                    
                    playerController!.player = player!
                    self.addChildViewController(playerController!)
                    self.view.addSubview(playerController!.view)
                    playerController!.view.frame = view.frame
                    NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
                    
                    self.view.bringSubview(toFront: self.profileImageView)
                    self.view.bringSubview(toFront: self.nameLabel)
                }
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.postImageView)
        self.view.addSubview(self.blurView)
        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.profileImageView)
        self.view.addSubview(self.lockButton)
        self.view.addSubview(self.tipButton)
        self.view.addSubview(self.tipView)
        
        if self.post.isPrivate == false || self.isProfile == true {
            self.blurView.isHidden = true
            self.lockButton.isHidden = true
        }
        
        self.setUpConstraints()

        self.postImageView.image = self.post.contentImage
        self.nameLabel.text = self.post.user.username
        self.profileImageView.image = self.post.user.profileImage
        
        if self.post.user.profileImage == nil {
            self.profileImageView.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2.0
        self.tipButton.layer.cornerRadius = self.tipButton.frame.size.height / 2.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    
    // MARK: - Lazy Initialization
    lazy var postImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12.0, weight: UIFontWeightHeavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1.0
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var tipButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("TIP", for: .normal)
        button.setTitleColor(.iroGreen, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: UIFontWeightHeavy)
        button.layer.borderColor = UIColor.iroGreen.cgColor
        button.layer.borderWidth = 2.0
        button.addTarget(self, action: #selector(self.tappedTipButton(sender:)), for: .touchUpInside)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var lockButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(#imageLiteral(resourceName: "lock"), for: .normal)
        button.addTarget(self, action: #selector(self.tappedLockButton(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var tipView: IROTipView = {
        let view: IROTipView = IROTipView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Autolayout
    func setUpConstraints() {
        self.postImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.postImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.postImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.postImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.blurView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.blurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.blurView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.blurView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.nameLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32.0).isActive = true
        self.nameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15.0).isActive = true
        self.nameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200.0).isActive = true
        self.nameLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
        
        self.profileImageView.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 10.0).isActive = true
        self.profileImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15.0).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        self.lockButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.lockButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.lockButton.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.lockButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        self.tipButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50.0).isActive = true
        self.tipButton.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.tipButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.tipButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        // Off screen to begin
        self.tipViewTopAnchor.isActive = true
        self.tipView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tipView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tipView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height).isActive = true
    }
    
    // MARK: - Video
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: kCMTimeZero)
            self.player!.play()
        }
    }
    
    // MARK: - Actions
    func tappedLockButton(sender: UIButton) {
        let name: String = self.nameLabel.text ?? "this user"
        let alert: UIAlertController = UIAlertController(
            title: "Subscribe",
            message: "Unlock this content by subscribing to \(name) for 100 coins per month?",
            preferredStyle: .alert
        )
        let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            UIView.animate(withDuration: 0.4, animations: { 
                self.blurView.alpha = 0.0
                self.lockButton.alpha = 0.0
            }, completion: { (success) in
                self.blurView.isHidden = true
                self.lockButton.isHidden = true
            })
        }
        let noAction: UIAlertAction = UIAlertAction(title: "No", style: .cancel) { (action) in
            //
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tappedTipButton(sender: UIButton) {
        self.showTipView()
    }
    
    // MARK: - Animations
    func hidePostDetails() {
        self.tipButton.alpha = 0.0
        self.nameLabel.alpha = 0.0
        self.profileImageView.alpha = 0.0
    }
    
    func showPostDetails() {
        self.tipButton.alpha = 1.0
        self.nameLabel.alpha = 1.0
        self.profileImageView.alpha = 1.0
    }
    
    func showTipView() {
        self.tipViewTopAnchor.constant = 0.0
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
            self.hidePostDetails()
        }
    }
    
    func dismissTipView() {
        self.tipViewTopAnchor.constant = self.view.frame.size.height
        UIView.animate(withDuration: 0.4) { 
            self.view.layoutIfNeeded()
            self.showPostDetails()
        }
    }

}

extension IROPostViewController: IROTipViewDelegate {
    
    func tipView(view: IROTipView, didSelectCloseButton button: UIButton) {
        self.dismissTipView()
    }
    
}
