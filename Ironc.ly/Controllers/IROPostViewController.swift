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
    
    // MARK: - View Lifecycle
    init(post: IROPost) {
        self.post = post
    
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
        
        self.setUpConstraints()

        self.postImageView.image = self.post.contentImage
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2.0
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
        label.text = "Hannah Julie Marie"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "user1")
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1.0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var lockButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(#imageLiteral(resourceName: "lock"), for: .normal)
        button.addTarget(self, action: #selector(self.tappedLockButton(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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

}
