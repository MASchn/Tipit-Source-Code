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
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.feedCollectionView)
        
        // Fake data
        let user1: IROUser = IROUser(profileImage: UIImage(named: "user1"), name: "Hanna Julie Marie")
        let user2: IROUser = IROUser(profileImage: UIImage(named: "user2"), name: "Silvia Marie Ann")
        let post1: IROPost = IROPost(user: user1, contentImage: UIImage(named: "feed_image_1")!, index: 0)
        let post2: IROPost = IROPost(user: user2, contentImage: UIImage(named: "feed_image_2")!, index: 1)
        let post3: IROPost = IROPost(user: user1, contentImage: UIImage(named: "feed_image_1")!, index: 2)
        let post4: IROPost = IROPost(user: user2, contentImage: UIImage(named: "feed_image_2")!, index: 3)
        let post5: IROPost = IROPost(user: user1, contentImage: UIImage(named: "feed_image_1")!, index: 4)
        let post6: IROPost = IROPost(user: user2, contentImage: UIImage(named: "feed_image_2")!, index: 5)
        let post7: IROPost = IROPost(user: user1, contentImage: UIImage(named: "feed_image_1")!, index: 6)
        let post8: IROPost = IROPost(user: user2, contentImage: UIImage(named: "feed_image_2")!, index: 7)
        self.posts = [post1, post2, post3, post4, post5, post6, post7, post8]
        
        self.tabBarController!.navigationItem.leftBarButtonItem = UIBarButtonItem(image: self.notificationImage, style: .plain, target: self, action: nil)
        self.tabBarController!.navigationItem.rightBarButtonItem = UIBarButtonItem(image: self.gridImage, style: .plain, target: self, action: #selector(self.changeLayout))
        
        self.setUpConstraints()
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
        let story: IROStory = IROStory(posts: self.posts)
        
        // Page view controller
        let storyViewController: IROStoryViewController = IROStoryViewController(story: story)
        storyViewController.dataSource = self
        storyViewController.delegate = self
        
        self.present(storyViewController, animated: true, completion: nil)
    }
    
}

extension IROFeedViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let postViewController: IROPostViewController = viewController as! IROPostViewController
        let storyViewController: IROStoryViewController = pageViewController as! IROStoryViewController
        let index: Int = postViewController.post.index!
        
        if index == 0 {
            return nil // This is the first post in the story
        } else {
            let beforeIndex: Int = index - 1
            let beforePost: IROPost = storyViewController.story.posts[beforeIndex]
            let beforePostViewController: IROPostViewController = IROPostViewController(post: beforePost)
            return beforePostViewController
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let postViewController: IROPostViewController = viewController as! IROPostViewController
        let storyViewController: IROStoryViewController = pageViewController as! IROStoryViewController
        let index: Int = postViewController.post.index!

        if index == storyViewController.story.posts.count - 1 {
            return nil // This is the last post in the story
        } else {
            let afterIndex: Int = index + 1
            let afterPost: IROPost = storyViewController.story.posts[afterIndex]
            let afterPostViewController: IROPostViewController = IROPostViewController(post: afterPost)
            return afterPostViewController
        }
        
    }
    
}

extension IROFeedViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let firstPendingViewController: IROPostViewController = pendingViewControllers.first! as! IROPostViewController
        let storyViewController: IROStoryViewController = pageViewController as! IROStoryViewController
        storyViewController.currentIndex = firstPendingViewController.post.index!
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let storyViewController: IROStoryViewController = pageViewController as! IROStoryViewController
        storyViewController.pageControl.currentPage = storyViewController.currentIndex
    }
    
}
