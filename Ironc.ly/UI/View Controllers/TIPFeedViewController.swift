//
//  TIPFeedViewController.swift
//  Ironc.ly
//

import UIKit

class TIPFeedViewController: TIPViewControllerWIthPullDown {
    
    // MARK: - Properties
    var feedItems: [TIPFeedItem] = [TIPFeedItem]()
    var columns: Int = 1
    let feedReuseId: String = "iro.reuseId.feed"
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        private let fixedImage : UIImage = UIImage(named: "your-header-logo.png")!
//        private let imageView : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 37.5))
//        
//        required init?(coder aDecoder: NSCoder) {
//            super.init(coder: aDecoder)
//            let tView = imageView
//            tView.contentMode = .scaleAspectFit
//            tView.image = fixedImage
//            self.titleView = tView
//            
//        }
        
        //self.view.backgroundColor = UIColor.iroGray
        
        
        
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.emptyView)
        self.view.addSubview(self.noInternetView)
        self.view.addSubview(self.feedCollectionView)
        self.view.addSubview(self.loadingView)
        //self.view.addSubview(self.splashView)
        
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: self.tabBarController!.tabBar.frame.height, right: 0.0)
        
        self.feedCollectionView.contentInset = adjustForTabbarInsets
        self.feedCollectionView.scrollIndicatorInsets = adjustForTabbarInsets
        self.feedCollectionView.scrollIndicatorInsets.bottom -= 10
        self.feedCollectionView.contentInset.bottom -= 10
        
        
        self.setUpConstraints()
        
    
//        let navImageView = UIImageView(frame: (self.navigationController?.navigationBar.frame)!)
//        navImageView.image = #imageLiteral(resourceName: "register_button")
//        //self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "register_button"), for: .default)
//        self.navigationController?.navigationItem.titleView = navImageView
    }
    
    func getFeed() {
        //self.loadingView.startAnimating()
        TIPAPIClient.getFeed { (feedItems: [TIPFeedItem]?) in
            //self.loadingView.stopAnimating()
            
            if let feedItems: [TIPFeedItem] = feedItems {
                self.feedItems = feedItems
                //self.feedCollectionView.reloadData()
                
                if feedItems.count > 0 {
                    self.optimpizedPreLoadImages()
                } else {
                    self.showEmptyView()
                }
            } else {
                self.showNoInternetView()
                print("NO INTERNET")
            }
            
            self.refreshControl.endRefreshing()
        }
    }
    
    func showEmptyView() {
        self.feedCollectionView.isHidden = true
        self.emptyView.isHidden = false
        self.noInternetView.isHidden = true
        //self.hideSplashView()
    }
    
    func showNoInternetView() {
        self.feedCollectionView.isHidden = true
        self.noInternetView.isHidden = false
        self.emptyView.isHidden = true
        //self.hideSplashView()
    }
    
    func hideSplashView() {
        if let tabControl = self.tabBarController as? TIPTabBarController {
            UIView.animate(withDuration: 0.4, animations: {
                tabControl.splashView.alpha = 0.1
            }, completion: { (success) in
                tabControl.splashView.isHidden = true
            })
        }
    }
    
//    func preLoadImages() {
//        var feedCount = 1
//        
//        for feedItem in self.feedItems {
//            
//            UIImage.loadImageUsingCache(urlString: feedItem.storyImage, placeHolder: nil, completion: { (image: UIImage?) in
//                
//                if (image == nil) && (feedItem.storyImage.contains(".mp4")) {
//                    
//                    let videoImage = TIPAPIClient.testImageFromVideo(urlString: feedItem.storyImage, at: 0)
//                    feedItem.actualStoryImage = videoImage
//                    
//                    if self.feedItems.count == feedCount {
//                        self.feedCollectionView.reloadData()
//                        self.feedCollectionView.isHidden = false
//                        self.emptyView.isHidden = true
//                        self.noInternetView.isHidden = true
////                        self.hideSplashView()
//                        
//                    } else {
//                        feedCount += 1
//                    }
//                }
//                
//                if let theImage: UIImage = image {
//                    
//                    feedItem.actualStoryImage = theImage
//                    
//                    if self.feedItems.count == feedCount {
//                        self.feedCollectionView.reloadData()
//                        self.feedCollectionView.isHidden = false
//                        self.emptyView.isHidden = true
//                        self.noInternetView.isHidden = true
//                        
//                    } else {
//                        feedCount += 1
//                    }
//                }
//                
//            })
//            
//            UIImage.loadImageUsingCache(urlString: feedItem.profileImageURL, placeHolder: nil, completion: { (image: UIImage?) in
//            
//                if let thisProfileImage: UIImage = image {
//            
//                    feedItem.profileImage = thisProfileImage
//            
//                    //TESTING THIS OUT
//                    if feedItem == self.feedItems.last {
//                        self.feedCollectionView.reloadData()
//                    }
//                                
//                }
//            })
//        }
//    }
    
    func optimpizedPreLoadImages() {
        
        let firstGroup = DispatchGroup()
        
        for feedItem in self.feedItems {
            
            firstGroup.enter()
            
            UIImage.loadImageUsingCache(urlString: feedItem.storyImage, placeHolder: nil, completion: { (image: UIImage?) in
                
                if (image == nil) && (feedItem.storyImage.contains(".mp4")) {
                    
                    let videoImage = TIPAPIClient.testImageFromVideo(urlString: feedItem.storyImage, at: 0)
                    feedItem.actualStoryImage = videoImage
                
                }
                
                if let theImage: UIImage = image {
                    
                    feedItem.actualStoryImage = theImage
                
                }
                
                UIImage.loadImageUsingCache(urlString: feedItem.profileImageURL, placeHolder: #imageLiteral(resourceName: "empty_profile"), completion: { (image: UIImage?) in
                    
                    if let thisProfileImage: UIImage = image {
                        feedItem.profileImage = thisProfileImage
                        firstGroup.leave()
                    }
                })
                
            })
        
        }
        
        firstGroup.notify(queue: DispatchQueue.main) {
            self.feedCollectionView.reloadData()
            self.feedCollectionView.isHidden = false
            self.emptyView.isHidden = true
            self.noInternetView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.emptyView.isHidden = true
        
//        if self.feedItems.count == 0 {
//            self.getFeed()
//        }
        self.getFeed()
        self.configureTIPNavBar()
        
        self.addPullDownMenu()
        
        
        //self.navigationItem.title = "tipit"
        self.backgroundImageView.image = TIPLoginViewController.backgroundPicArray[TIPUser.currentUser?.backgroundPicSelection ?? 0]
        
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "grid"), style: .plain, target: self, action: #selector(self.changeLayout))
    }
        
    // MARK: - Lazy Initialization
    lazy var emptyView: TIPFeedEmptyView = {
        let view: TIPFeedEmptyView = TIPFeedEmptyView()
        view.actionButton.addTarget(self, action: #selector(tappedFollowButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    lazy var noInternetView: TIPNoInternetView = {
        let view: TIPNoInternetView = TIPNoInternetView()
        //view.actionButton.addTarget(self, action: #selector(tappedFollowButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let view: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var feedCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(TIPFeedCollectionViewCell.self, forCellWithReuseIdentifier: self.feedReuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.addSubview(self.refreshControl)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        return collectionView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let control: UIRefreshControl = UIRefreshControl()
        control.backgroundColor = .clear
        control.tintColor = .white
        control.addTarget(self, action: #selector(self.getFeed), for: .valueChanged)
        return control
    }()
    
    lazy var splashView: TIPLoadingView = {
        let view: TIPLoadingView = TIPLoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = false
        return view
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "crumpled")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.emptyView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.emptyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.emptyView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.emptyView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.backgroundImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.noInternetView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.noInternetView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.noInternetView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.noInternetView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.feedCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: navBarHeight).isActive = true
        self.feedCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.feedCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.feedCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
//        self.splashView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        self.splashView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        self.splashView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        self.splashView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
//        if let tabBarController = self.tabBarController{
//        
//        self.splashView.topAnchor.constraint(equalTo: tabBarController.view.topAnchor).isActive = true
//        self.splashView.bottomAnchor.constraint(equalTo: tabBarController.view.bottomAnchor).isActive = true
//        self.splashView.leftAnchor.constraint(equalTo: tabBarController.view.leftAnchor).isActive = true
//        self.splashView.rightAnchor.constraint(equalTo: tabBarController.view.rightAnchor).isActive = true
//        }
    }
    
    func changeLayout() {
//        if self.columns == 1 {
//            self.columns = 2
//            self.tabBarController?.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "list").withRenderingMode(.alwaysOriginal)
//        } else {
//            self.columns = 1
//            self.tabBarController?.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "grid").withRenderingMode(.alwaysOriginal)
//        }
//        self.feedCollectionView.reloadData()
        let navController: UINavigationController = AppDelegate.shared.initializeMainViewController()
        self.tabBarController?.present(navController, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    func tappedFollowButton() {
        // Go to Search
        self.tabBarController?.selectedIndex = 1
    }
    
//    func showAlert(message: String) {
//        let alert: UIAlertController = UIAlertController(
//            title: message,
//            message: nil,
//            preferredStyle: .alert
//        )
//        
//        let ok = UIAlertAction(title: "Ok", style: .cancel) { (action) in
//            //
//        }
//        
//        alert.addAction(ok)
//        self.present(alert, animated: true, completion: nil)
//    }
    
}

extension TIPFeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.feedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TIPFeedCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.feedReuseId, for: indexPath) as! TIPFeedCollectionViewCell
        cell.delegate = self
        let feedItem: TIPFeedItem = self.feedItems[indexPath.item]
        cell.configure(with: feedItem)
        return cell
    }
    
}

extension TIPFeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGFloat = collectionView.bounds.width / CGFloat(self.columns)
        return CGSize(width: size, height: size + size/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}

extension TIPFeedViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell: TIPFeedCollectionViewCell = self.feedCollectionView.cellForItem(at: indexPath) as! TIPFeedCollectionViewCell
        if let feedItem: TIPFeedItem = cell.feedItem {
            TIPAPIClient.getStory(userId: feedItem.userId, completionHandler: { (story: TIPStory?) in
                if let story: TIPStory = story {
                    let storyViewController: TIPStoryViewController = TIPStoryViewController(story: story, username: feedItem.username, profileImage: cell.profileImageView.image, userID: feedItem.userId, feedItem: feedItem)
                    
                    self.present(storyViewController, animated: true, completion: nil)
                }
            })
        }
    }
    
}

extension TIPFeedViewController: TIPFeedCollectionViewCellDelegate {
    
    func feedCellDidSelectItem(feedItem: TIPFeedItem) {
        let profileViewController: TIPProfileViewController = TIPProfileViewController(feedItem: feedItem)
        profileViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "back"), style: .plain, target: profileViewController, action: #selector(profileViewController.tappedBackButton))
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func feedCellDidTip(feedItem: TIPFeedItem, coins: Int) {
        
            guard let user: TIPUser = TIPUser.currentUser else { return }
        
            let minutesToAdd = coins / 10
            let coinsToAdd = coins
        
            let milliseconds: Int = minutesToAdd * 60 * 1000
        
        
        let alert: UIAlertController = UIAlertController(
            title: "Subscribe",
            message: "Add \(minutesToAdd) minutes for \(coinsToAdd) coins?",
            preferredStyle: .alert
        )
        let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            if user.coins > coinsToAdd {
                TIPAPIClient.tip(contentId: feedItem.storyImageId, coins: coinsToAdd, milliseconds: milliseconds) { (coins: Int?, dateString: String?, error: Error?) in
                    if
                        let coins: Int = coins,
                        let dateString: String = dateString
                    {
                        user.updateCoins(newValue: coins)
                        print("successfully tipped")
                    } else {
                        print("Error tipping")
                    }
                }
            } else {
                print("Not Enough Coins")
            }
        }
        
        let noAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func feedCellDidTapSubscribe(feedItem: TIPFeedItem, cell: TIPFeedCollectionViewCell) {
        
            var coinsToSub = 1000
            
            if feedItem.coinsToSub != nil {
                coinsToSub = feedItem.coinsToSub!
            }
            
            let alert: UIAlertController = UIAlertController(
                title: "Subscribe",
                message: "Subscribe to \(feedItem.username!) for \(coinsToSub) coins?",
                preferredStyle: .alert
            )
            let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                
                
                
                if (TIPUser.currentUser?.coins)! < coinsToSub {
                    print("not enough coins")
                    self.showAlert(title: "Oops!", message: "Not Enough Coins", completion: { 
                        //
                    })
                    return
                }
                
                TIPAPIClient.updateUserCoins(coinsToAdd: coinsToSub, userID: feedItem.userId, completionHandler: { (success: Bool) in
                    
                    if success == true {
                        
                        let parameters: [String: Any] = [
                            "coins" : ((TIPUser.currentUser?.coins)! - coinsToSub)
                        ]
                        
                        TIPAPIClient.updateUser(parameters: parameters, completionHandler: { (success: Bool) in
                            
                            if success == true {
                                
                                TIPAPIClient.userAction(action: .subscribe, userId: feedItem.userId, completionHandler: { (success: Bool) in
                                    if success == true {
                                        print("SUCCESS")
                                        
                                        TIPUser.currentUser?.subscribedTo?.append(feedItem.userId)
                                        TIPUser.currentUser?.save()
        
                                        cell.subscribeButton.isHidden = true
                                        cell.lockImageView.isHidden = true
                                        cell.blurView.isHidden = true
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
