//
//  TIPFeedViewController.swift
//  Ironc.ly
//

import UIKit

class TIPFeedViewController: UIViewController {
    
    // MARK: - Properties
    var feedItems: [TIPFeedItem] = [TIPFeedItem]()
    var columns: Int = 1
    let feedReuseId: String = "iro.reuseId.feed"
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.iroGray
        self.view.addSubview(self.emptyView)
        self.view.addSubview(self.feedCollectionView)
        self.view.addSubview(self.loadingView)
        
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: self.tabBarController!.tabBar.frame.height, right: 0.0)
        
        self.feedCollectionView.contentInset = adjustForTabbarInsets
        self.feedCollectionView.scrollIndicatorInsets = adjustForTabbarInsets
        self.feedCollectionView.scrollIndicatorInsets.bottom -= 10
        self.feedCollectionView.contentInset.bottom -= 10
        
        
        self.setUpConstraints()
        
        
    }
    
    func getFeed() {
        self.loadingView.startAnimating()
        TIPAPIClient.getFeed { (feedItems: [TIPFeedItem]?) in
            self.loadingView.stopAnimating()
            
            if let feedItems: [TIPFeedItem] = feedItems {
                self.feedItems = feedItems
                self.feedCollectionView.reloadData()
                
                if feedItems.count > 0 {
                    self.feedCollectionView.isHidden = false
                    self.emptyView.isHidden = true
                } else {
                    self.showEmptyView()
                }
            } else {
                self.showEmptyView()
            }
            
            self.refreshControl.endRefreshing()
        }
    }
    
    func showEmptyView() {
        self.feedCollectionView.isHidden = true
        self.emptyView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.emptyView.isHidden = true
        
//        if self.feedItems.count == 0 {
//            self.getFeed()
//        }
        self.getFeed()
        self.configureTIPNavBar()
        self.navigationItem.title = "tipit"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "grid"), style: .plain, target: self, action: #selector(self.changeLayout))
    }
        
    // MARK: - Lazy Initialization
    lazy var emptyView: TIPFeedEmptyView = {
        let view: TIPFeedEmptyView = TIPFeedEmptyView()
        view.actionButton.addTarget(self, action: #selector(tappedFollowButton), for: .touchUpInside)
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
        collectionView.backgroundColor = UIColor.iroGray
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
        control.backgroundColor = .iroBlue
        control.tintColor = .white
        control.addTarget(self, action: #selector(self.getFeed), for: .valueChanged)
        return control
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.emptyView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.emptyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.emptyView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.emptyView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.feedCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.feedCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.feedCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.feedCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        
    }
    
    func changeLayout() {
        if self.columns == 1 {
            self.columns = 2
            self.tabBarController?.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "list").withRenderingMode(.alwaysOriginal)
        } else {
            self.columns = 1
            self.tabBarController?.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "grid").withRenderingMode(.alwaysOriginal)
        }
        self.feedCollectionView.reloadData()
    }
    
    // MARK: - Actions
    func tappedFollowButton() {
        // Go to Search
        self.tabBarController?.selectedIndex = 1
    }
    
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
        return CGSize(width: size, height: size)
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
                    let storyViewController: TIPStoryViewController = TIPStoryViewController(story: story, username: feedItem.username, profileImage: cell.profileImageView.image, userID: feedItem.userId)
                    
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
    
}
