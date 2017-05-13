//
//  IROFeedViewController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 1/23/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROFeedViewController: UIViewController {
    
    // MARK: - Properties
    var feedItems: [IROFeedItem] = [IROFeedItem]()
    var columns: Int = 1
    
    let notificationImage: UIImage = UIImage(cgImage: UIImage(named: "notification")!.cgImage!, scale: 3.0, orientation: .up).withRenderingMode(.alwaysOriginal)
    let gridImage = UIImage(cgImage: UIImage(named: "grid")!.cgImage!, scale: 3.0, orientation: .up).withRenderingMode(.alwaysOriginal)
    let listImage = UIImage(cgImage: UIImage(named: "list")!.cgImage!, scale: 3.0, orientation: .up).withRenderingMode(.alwaysOriginal)

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.emptyView)
        self.view.addSubview(self.feedCollectionView)
                
        self.feedCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: self.bottomLayoutGuide.length, right: 0.0)
        
        self.setUpConstraints()
        
        self.getFeed()
    }
    
    func getFeed() {
        IROAPIClient.getFeed { (feedItems: [IROFeedItem]?) in
            if let feedItems: [IROFeedItem] = feedItems, feedItems.count > 0 {
                self.feedItems = feedItems
                self.feedCollectionView.reloadData()
                self.feedCollectionView.isHidden = false
                self.emptyView.isHidden = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.feedItems.count == 0 {
            self.getFeed()
        }
        
        self.navigationItem.title = IROUser.currentUser?.fullName
        self.navigationController?.navigationBar.titleTextAttributes = IROStyle.navBarTitleAttributes
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.barTintColor = .white
        
        self.navigationController?.visibleViewController?.navigationItem.setHidesBackButton(true, animated: false)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: self.notificationImage, style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: self.gridImage, style: .plain, target: self, action: #selector(self.changeLayout))
    }
    
    // MARK: - Status Bar
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Lazy Initialization
    lazy var emptyView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .groupTableViewBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var feedCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(IROFeedCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        return collectionView
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
            self.tabBarController!.navigationItem.rightBarButtonItem?.image = self.listImage
        } else {
            self.columns = 1
            self.tabBarController!.navigationItem.rightBarButtonItem?.image = self.gridImage
        }
        self.feedCollectionView.reloadData()
    }
    
}

extension IROFeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.feedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: IROFeedCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! IROFeedCollectionViewCell
        let feedItem: IROFeedItem = self.feedItems[indexPath.item]
        cell.configure(with: feedItem)
        return cell
    }
    
}

extension IROFeedViewController: UICollectionViewDelegateFlowLayout {
    
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

extension IROFeedViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell: IROFeedCollectionViewCell = self.feedCollectionView.cellForItem(at: indexPath) as! IROFeedCollectionViewCell
        if let userId: String = cell.userId {
            IROAPIClient.getStory(userId: userId, completionHandler: { (story: IROStory?) in
                if let story: IROStory = story {
                    let storyViewController: IROStoryViewController = IROStoryViewController(story: story, isProfile: false)
                    self.present(storyViewController, animated: true, completion: nil)
                }
            })
        }
        
    }
    
}
