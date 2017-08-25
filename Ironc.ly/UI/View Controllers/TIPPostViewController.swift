//
//  TIPPostViewController.swift
//  Ironc.ly
//

import UIKit
import AVFoundation
import AVKit
import Lottie
import MessageUI

protocol TIPPostViewControllerDelegate: class {
    func postViewController(viewController: TIPPostViewController, isShowingTipScreen: Bool)
}

class TIPPostViewController: UIViewController {
    
    var post: TIPPost
    var videoURL: URL?
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    var delegate: TIPPostViewControllerDelegate?
    var animationView: LOTAnimationView?
    var userID: String
    var isSubscribed: Bool?
    var coinsToSub: Int
    
    lazy var tipViewTopAnchor: NSLayoutConstraint = self.tipView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.size.height)
    
    // MARK: - View Lifecycle
    init(post: TIPPost, username: String?, profileImage: UIImage?, userID: String, coinsToSub: Int) {
        self.post = post
        self.userID = userID
        self.isSubscribed = false
        self.coinsToSub = coinsToSub
        
        if let subbedTo = TIPUser.currentUser?.subscribedTo {
            for sub in subbedTo{
                if sub == userID {
                    self.isSubscribed = true
                }
            }
        }
        
        if self.userID == TIPUser.currentUser?.userId {
            self.isSubscribed = true
        }
    
        super.init(nibName: nil, bundle: nil)
        
        self.profileImageView.image = profileImage ?? #imageLiteral(resourceName: "empty_profile")
        self.usernameLabel.text = username
        self.timeRemainingLabel.text = post.timeRemaining
        
        if post.type == .video {
            if let urlString: String = post.contentURL {
                if let url: URL = URL(string: urlString) {
                    self.view.backgroundColor = UIColor.gray
                    player = AVPlayer(url: url)
                    playerController = AVPlayerViewController()
//                    let playerLayer = AVPlayerLayer(player: player)
//                    
//                    self.view.layer.addSublayer(playerLayer)
//                    playerLayer.frame = view.frame
                    
                    guard player != nil && playerController != nil else {
                        return
                    }
                    playerController!.showsPlaybackControls = false
                    
                    playerController!.player = player!
                    self.addChildViewController(playerController!)
                    self.view.addSubview(playerController!.view)
                    playerController!.view.frame = view.frame
                    NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
                    
                    self.view.bringSubview(toFront: self.blurView)
                    self.view.bringSubview(toFront: self.lockButton)
                    self.view.bringSubview(toFront: self.profileImageView)
                    self.view.bringSubview(toFront: self.usernameLabel)
                    self.view.bringSubview(toFront: self.settingsButton)
                    self.view.bringSubview(toFront: self.tipButton)
                    self.view.bringSubview(toFront: self.timeRemainingLabel)
                    self.view.bringSubview(toFront: self.shadeView)
                    self.view.bringSubview(toFront: self.tipView)
                    
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
        self.view.addSubview(self.usernameLabel)
        self.view.addSubview(self.profileImageView)
        self.view.addSubview(self.settingsButton)
        self.view.addSubview(self.lockButton)
        self.view.addSubview(self.tipButton)
        self.view.addSubview(self.timeRemainingLabel)
        self.view.addSubview(self.shadeView)
        self.view.addSubview(self.tipView)
        
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(tappedProfilePic))
        self.profileImageView.addGestureRecognizer(profileTap)
        
        guard let user: TIPUser = TIPUser.currentUser else { return }
        
        if self.userID == user.userId {
            self.tipButton.isHidden = true
        } else {
            self.tipButton.isHidden = false
        }
        
        if self.post.isPrivate == false  || self.isSubscribed == true{
            self.blurView.isHidden = true
            self.lockButton.isHidden = true
        }
        
        self.postImageView.image = self.post.contentImage
        
        self.setUpConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2.0
        self.tipButton.layer.cornerRadius = self.tipButton.frame.size.height / 2.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.post.isPrivate == false  || self.isSubscribed == true{
            player?.play()
        }
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.pause()
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
    
    lazy var shadeView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        view.alpha = 0.0 // Fade in when Tip is selected
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var usernameLabel: UILabel = {
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
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var settingsButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
        button.addTarget(self, action: #selector(self.tappedSettingsButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var tipButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("TIP", for: .normal)
        button.setTitleColor(.iroBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: UIFontWeightHeavy)
        button.layer.borderColor = UIColor.iroBlue.cgColor
        button.layer.borderWidth = 2.0
        button.addTarget(self, action: #selector(self.tappedTipButton(sender:)), for: .touchUpInside)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var timeRemainingLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 12.0, weight: UIFontWeightHeavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var lockButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(#imageLiteral(resourceName: "lock"), for: .normal)
        button.addTarget(self, action: #selector(self.tappedLockButton(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var tipView: TIPTipView = {
        let view: TIPTipView = TIPTipView()
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
        
        self.shadeView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.shadeView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.shadeView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.shadeView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.usernameLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32.0).isActive = true
        self.usernameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15.0).isActive = true
        self.usernameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200.0).isActive = true
        self.usernameLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
        
        self.profileImageView.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor, constant: 10.0).isActive = true
        self.profileImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15.0).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        self.settingsButton.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.settingsButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.settingsButton.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        self.settingsButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        self.lockButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.lockButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.lockButton.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.lockButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        self.tipButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50.0).isActive = true
        self.tipButton.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.tipButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.tipButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.timeRemainingLabel.topAnchor.constraint(equalTo: self.tipButton.bottomAnchor).isActive = true
        self.timeRemainingLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.timeRemainingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.timeRemainingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
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
    
    func tappedProfilePic() {
        
        if self.userID == TIPUser.currentUser?.userId {
            self.parent?.dismiss(animated: true, completion: nil)
        }
        
        guard let parentVC = self.parent as? TIPStoryViewController else {return}
        
        if parentVC.feedItem != nil {
            
            let tabVC = parentVC.presentingViewController as? TIPTabBarController
            
            parentVC.dismiss(animated: true, completion: { 
                let profileViewController: TIPProfileViewController = TIPProfileViewController(feedItem: parentVC.feedItem!)
                profileViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "back"), style: .plain, target: profileViewController, action: #selector(profileViewController.tappedBackButton))
                
                let navVC = tabVC?.viewControllers?[0] as? UINavigationController
                navVC?.pushViewController(profileViewController, animated: true)
            })
            
        }
        else if parentVC.searchUser != nil {
            let tabVC = parentVC.presentingViewController as? TIPTabBarController
            
            parentVC.dismiss(animated: true, completion: {
                let profileViewController: TIPProfileViewController = TIPProfileViewController(searchUser: parentVC.searchUser!)
                profileViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "back"), style: .plain, target: profileViewController, action: #selector(profileViewController.tappedBackButton))
                
                let navVC = tabVC?.viewControllers?[1] as? UINavigationController
                navVC?.pushViewController(profileViewController, animated: true)
            })
        }
        else if parentVC.feedItem == nil && parentVC.searchUser == nil {
            self.parent?.dismiss(animated: true, completion: nil)
        }
    }
    
    func tappedLockButton(sender: UIButton) {
        self.showLockedAlert()
    }
    
    func showLockedAlert() {
        
        if self.coinsToSub == 0 {
            self.coinsToSub = 1000
        }
        
        let alert: UIAlertController = UIAlertController(
            title: "Subscribe",
            message: "Subscribe to \(self.usernameLabel.text!) for \(self.coinsToSub) coins?",
            preferredStyle: .alert
        )
        let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            if (TIPUser.currentUser?.coins)! < self.coinsToSub {
                print("not enough coins")
                return
            }
            
            TIPAPIClient.updateUserCoins(coinsToAdd: self.coinsToSub, userID: self.userID, completionHandler: { (success: Bool) in
                
                if success == true {
                    
                    let parameters: [String: Any] = [
                        "coins" : ((TIPUser.currentUser?.coins)! - self.coinsToSub)
                    ]
                    
                    TIPAPIClient.updateUser(parameters: parameters, completionHandler: { (success: Bool) in
                        
                        if success == true {
                            
                        TIPAPIClient.userAction(action: .subscribe, userId: self.userID, completionHandler: { (success: Bool) in
                            if success == true {
                                print("SUCCESS")
                                self.isSubscribed = true
                                
                               // TIPUser.currentUser?.coins -= 1000
                                TIPUser.currentUser?.subscribedTo?.append(self.userID)
                                TIPUser.currentUser?.save()
                                
                                UIView.animate(withDuration: 0.4, animations: {
                                    self.blurView.alpha = 0.0
                                    self.lockButton.alpha = 0.0
                                }, completion: { (success) in
                                    self.blurView.isHidden = true
                                    self.lockButton.isHidden = true
                                    self.player?.play()
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
    
    func tappedTipButton(sender: UIButton) {
        guard let user: TIPUser = TIPUser.currentUser else { return }
        
        if self.post.isPrivate == false || self.isSubscribed == true {
            self.showTipView()
        }
    }
    
    func tappedSettingsButton(sender: UIButton) {
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let reportAction: UIAlertAction = UIAlertAction(title: "Report", style: .destructive) { (action) in
            let mailComposeVC = self.mailComposeViewController()
            self.present(mailComposeVC, animated: true, completion: nil)
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(reportAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func mailComposeViewController() -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["support@tipapp.io"])
        mailComposeVC.setSubject("Report Abusive Content")
        
        let contentId: String = self.post.contentId
        
        mailComposeVC.setMessageBody("Content ID: \(contentId)", isHTML: false)
        return mailComposeVC
    }
    
    // MARK: - Animations
    func hidePostDetails() {
        self.tipButton.alpha = 0.0
        self.usernameLabel.alpha = 0.0
        self.profileImageView.alpha = 0.0
        self.timeRemainingLabel.alpha = 0.0
    }
    
    func showPostDetails() {
        self.tipButton.alpha = 1.0
        self.usernameLabel.alpha = 1.0
        self.profileImageView.alpha = 1.0
        self.timeRemainingLabel.alpha = 1.0
    }
    
    func showTipView() {
        self.tipViewTopAnchor.constant = 0.0
        
        self.updateCoinsButton()
        
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
            self.hidePostDetails()
            self.shadeView.alpha = 1.0
        }) { (completed: Bool) in
            self.delegate?.postViewController(viewController: self, isShowingTipScreen: true)
        }
    }
    
    func updateCoinsButton() {
        // Update coins amount
        guard let user: TIPUser = TIPUser.currentUser else { return }
        let formattedCoins: String = TIPCoinsFormatter.formattedCoins(coins: user.coins)
        let coinsTitle: String = "buy coins: \(formattedCoins)"
        self.tipView.buyCoinsButton.setTitle(coinsTitle, for: .normal)
    }
    
    func dismissTipView(fadeShade: Bool = true, completionHandler: ((Bool) -> Void)?) {
        self.tipViewTopAnchor.constant = self.view.frame.size.height
        UIView.animate(withDuration: 0.4, animations: { 
            self.view.layoutIfNeeded()
            self.showPostDetails()
            if fadeShade == true {
                self.shadeView.alpha = 0.0
            }
        }) { (completed: Bool) in
            self.delegate?.postViewController(viewController: self, isShowingTipScreen: false)
            completionHandler?(completed)
        }
    }
    
    func presentBuyCoinsModal() {
        let buyCoinsViewController: TIPBuyCoinsViewController = TIPBuyCoinsViewController(style: .grouped)
        buyCoinsViewController.delegate = self
        let navigationController: UINavigationController = UINavigationController(rootViewController: buyCoinsViewController)
        self.present(navigationController, animated: true, completion: nil)
    }

}

extension TIPPostViewController: TIPTipViewDelegate {
    
    func tipView(view: TIPTipView, didSelectShape shape: TIPShape) {
        guard let user: TIPUser = TIPUser.currentUser else { return }
        
        let milliseconds: Int = shape.minutes * 60 * 1000
        
        if user.coins > shape.coins {
            TIPAPIClient.tip(contentId: self.post.contentId, coins: shape.coins, milliseconds: milliseconds) { (coins: Int?, dateString: String?, error: Error?) in
                if
                    let coins: Int = coins,
                    let dateString: String = dateString
                {
                    user.updateCoins(newValue: coins)
                    
                    self.timeRemainingLabel.text = Date.fromString(dateString: dateString).formattedTimeRemaining()
                    
                    self.showTipAnimation(shape: shape)
                } else {
                    print("Error tipping")
                }
            }
        } else {
            self.presentBuyCoinsModal()
        }        

    }

    func showTipAnimation(shape: TIPShape) {
        self.dismissTipView(fadeShade: false) { (completed: Bool) in
            self.animationView = LOTAnimationView(name: shape.name)
            self.animationView?.contentMode = .scaleAspectFit
            self.view.addSubview(self.animationView!)
            self.animationView?.frame = self.view.bounds
            self.animationView?.play(completion: { (completed: Bool) in
                self.animationView?.removeFromSuperview()
                self.animationView = nil
                UIView.animate(withDuration: 0.4, animations: {
                    self.shadeView.alpha = 0.0
                })
            })
        }
    }
    
    func tipView(view: TIPTipView, didSelectBuyCoinsButton button: UIButton) {
        self.presentBuyCoinsModal()
    }
    
    func tipView(view: TIPTipView, didSelectCloseButton button: UIButton) {
        self.dismissTipView(completionHandler: nil)
    }
    
}

extension TIPPostViewController: TIPBuyCoinsViewControllerDelegate {
    
    func buyCoinsViewControllerDidDismiss() {
        self.updateCoinsButton()
    }
    
}

extension TIPPostViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
