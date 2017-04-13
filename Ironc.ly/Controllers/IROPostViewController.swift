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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.postImageView)
        self.setUpConstraints()

        self.postImageView.image = self.post.contentImage
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

    // MARK: - Autolayout
    func setUpConstraints() {
        self.postImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.postImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.postImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.postImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
    
    // MARK: - Video
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: kCMTimeZero)
            self.player!.play()
        }
    }

}
