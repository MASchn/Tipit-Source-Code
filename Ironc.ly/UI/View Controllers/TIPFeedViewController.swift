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
                
        self.feedCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: self.bottomLayoutGuide.length, right: 0.0)
        
        self.setUpConstraints()
        
        self.getFeed()
    }
    
    func getFeed() {
        TIPAPIClient.getFeed { (feedItems: [TIPFeedItem]?) in
            if let feedItems: [TIPFeedItem] = feedItems, feedItems.count > 0 {
                self.feedItems = feedItems
                self.feedCollectionView.reloadData()
                self.feedCollectionView.isHidden = false
                self.emptyView.isHidden = true
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.feedItems.count == 0 {
            self.getFeed()
        }
        
        self.configureTIPNavBar()
        self.navigationItem.title = "Tipit"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "grid"), style: .plain, target: self, action: #selector(self.changeLayout))
    }
        
    // MARK: - Lazy Initialization
    lazy var emptyView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .iroGray
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
        control.backgroundColor = .iroGreen
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
    }
    
    func changeLayout() {
        if self.columns == 1 {
            self.columns = 2
            self.tabBarController!.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "list").withRenderingMode(.alwaysOriginal)
        } else {
            self.columns = 1
            self.tabBarController!.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "grid").withRenderingMode(.alwaysOriginal)
        }
        self.feedCollectionView.reloadData()
    }
    
}

extension TIPFeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.feedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TIPFeedCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.feedReuseId, for: indexPath) as! TIPFeedCollectionViewCell
        let feedItem: TIPFeedItem = self.feedItems[indexPath.item]
        cell.configure(with: feedItem)
        
        // Mock
        cell.postImageView.image = #imageLiteral(resourceName: "demo")
        
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
        if let userId: String = cell.userId {
            TIPAPIClient.getStory(userId: userId, completionHandler: { (story: TIPStory?) in
                if let story: TIPStory = story {
                    let storyViewController: TIPStoryViewController = TIPStoryViewController(story: story, isProfile: false)
                    self.present(storyViewController, animated: true, completion: nil)
                }
            })
        }
    }
    
}
