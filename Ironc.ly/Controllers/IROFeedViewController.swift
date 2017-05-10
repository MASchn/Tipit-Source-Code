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
    var columns: Int = 1
    
    // TODO: The data source should be "stories" not "posts"
    var posts: [IROPost] = []
    
    let notificationImage: UIImage = UIImage(cgImage: UIImage(named: "notification")!.cgImage!, scale: 3.0, orientation: .up).withRenderingMode(.alwaysOriginal)
    let gridImage = UIImage(cgImage: UIImage(named: "grid")!.cgImage!, scale: 3.0, orientation: .up).withRenderingMode(.alwaysOriginal)
    let listImage = UIImage(cgImage: UIImage(named: "list")!.cgImage!, scale: 3.0, orientation: .up).withRenderingMode(.alwaysOriginal)

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.posts = IROStory.mockStory().posts
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.feedCollectionView)
        
        self.setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = "Name"
        self.tabBarController?.navigationController?.navigationBar.titleTextAttributes = IROStyle.navBarTitleAttributes
        self.tabBarController?.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: self.notificationImage, style: .plain, target: self, action: nil)
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: self.gridImage, style: .plain, target: self, action: #selector(self.changeLayout))
        self.tabBarController?.navigationItem.title = nil
        
        self.feedCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: self.bottomLayoutGuide.length, right: 0.0)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    // MARK: - Lazy Initialization
    lazy var feedCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(IROFeedCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
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
        return self.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: IROFeedCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! IROFeedCollectionViewCell
        let post: IROPost = self.posts[indexPath.item]
        cell.configure(with: post)
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
        let story = IROStory.mockStory()
        let storyViewController: IROStoryViewController = IROStoryViewController(story: story, isProfile: false)
        self.present(storyViewController, animated: true, completion: nil)
    }
    
}
