//
//  TIPStoryViewController.swift
//  Ironc.ly
//

import UIKit

class TIPStoryViewController: UIPageViewController {
    
    // MARK: - Properties
    let story: TIPStory
    let username: String?
    let profileImage: UIImage?
    let userID: String
    let feedItem: TIPFeedItem?
    let searchUser: TIPSearchUser?
    var coinsToSub: Int
    
    var currentIndex: Int
    var isProfile: Bool = false
    var currentViewController: TIPPostViewController?
        
    // MARK: - View Lifecycle
    init(story: TIPStory, username: String?, profileImage: UIImage?, userID: String, postIndex: Int) {
        self.story = story
        self.username = username
        self.profileImage = profileImage
        self.userID = userID
        self.feedItem = nil
        self.searchUser = nil
        self.coinsToSub = 0
        self.currentIndex = postIndex
        
        
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        
        self.dataSource = self
        self.delegate = self
        

        
        
    }
    
    init(story: TIPStory, username: String?, profileImage: UIImage?, userID: String, feedItem: TIPFeedItem) {
        self.story = story
        self.username = username
        self.profileImage = profileImage
        self.userID = userID
        self.feedItem = feedItem
        self.searchUser = nil
        self.currentIndex = story.posts.count - 1
        
        if let coins = feedItem.coinsToSub {
            self.coinsToSub = coins
        } else {
            self.coinsToSub = 1000
        }
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        
        self.dataSource = self
        self.delegate = self
    }
    
    init(story: TIPStory, username: String?, profileImage: UIImage?, userID: String, searchUser: TIPSearchUser) {
        self.story = story
        self.username = username
        self.profileImage = profileImage
        self.userID = userID
        self.feedItem = nil
        self.searchUser = searchUser
        self.currentIndex = story.posts.count - 1
        
        if let coins = searchUser.coinsToSub {
            self.coinsToSub = coins
        } else {
            self.coinsToSub = 1000
        }
        
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissStory))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        self.view.backgroundColor = UIColor.iroGray
        
        self.view.addSubview(self.pageControl)

        self.pageControl.numberOfPages = self.story.posts.count
        self.pageControl.updateCurrentPageDisplay()
        
        let postToView: TIPPost = self.story.posts[self.currentIndex]
        self.pageControl.currentPage = self.currentIndex
        let postViewController: TIPPostViewController = TIPPostViewController(post: postToView, username: self.username, profileImage: self.profileImage, userID: self.userID, coinsToSub: self.coinsToSub)
        postViewController.delegate = self
        

        self.setViewControllers([postViewController], direction: .forward, animated: false, completion: nil)
        self.currentViewController = postViewController
        
        self.setUpConstraints()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Lazy Initialization
    lazy var pageControl: UIPageControl = {
        let control: UIPageControl = UIPageControl()
        control.pageIndicatorTintColor = UIColor(white: 0.0, alpha: 0.3)
        control.currentPageIndicatorTintColor = .iroBlue
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
        
    // MARK: - Autolayout
    func setUpConstraints() {
        self.pageControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10.0).isActive = true
        self.pageControl.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15.0).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
    }
    
    // MARK: - Actions
    func dismissStory() {
        let postVCs = self.viewControllers as! [TIPPostViewController]
        
        for postVC in postVCs {
            postVC.player?.pause()
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func tappedTipButton(sender: UIButton) {
        self.currentViewController?.showTipView()
    }
    
}

extension TIPStoryViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let postViewController: TIPPostViewController = viewController as! TIPPostViewController
        postViewController.delegate = self
        let storyViewController: TIPStoryViewController = pageViewController as! TIPStoryViewController
        let index: Int = postViewController.post.index!
        
        if index == 0 {
            return nil // This is the first post in the story
        } else {
            let beforeIndex: Int = index - 1
            let beforePost: TIPPost = storyViewController.story.posts[beforeIndex]
            let beforePostViewController: TIPPostViewController = TIPPostViewController(post: beforePost, username: self.username, profileImage: self.profileImage, userID: self.userID, coinsToSub: self.coinsToSub)

            return beforePostViewController
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let postViewController: TIPPostViewController = viewController as! TIPPostViewController
        postViewController.delegate = self
        let storyViewController: TIPStoryViewController = pageViewController as! TIPStoryViewController
        let index: Int = postViewController.post.index!
        
        if index == storyViewController.story.posts.count - 1 {
            return nil // This is the last post in the story
        } else {
            let afterIndex: Int = index + 1
            let afterPost: TIPPost = storyViewController.story.posts[afterIndex]
            let afterPostViewController: TIPPostViewController = TIPPostViewController(post: afterPost, username: self.username, profileImage: self.profileImage, userID: self.userID, coinsToSub: self.coinsToSub)
            
            return afterPostViewController
        }
        
    }
    
}

extension TIPStoryViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let firstPendingViewController: TIPPostViewController = pendingViewControllers.first! as! TIPPostViewController
        let storyViewController: TIPStoryViewController = pageViewController as! TIPStoryViewController
        storyViewController.currentIndex = firstPendingViewController.post.index!
        self.currentViewController = firstPendingViewController
        
        let postVCs = storyViewController.viewControllers as! [TIPPostViewController]
        
        for postVC in postVCs {
            postVC.player?.pause()
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let storyViewController: TIPStoryViewController = pageViewController as! TIPStoryViewController
        storyViewController.pageControl.currentPage = storyViewController.currentIndex
    }
    
}

extension TIPStoryViewController: TIPPostViewControllerDelegate {
    
    func postViewController(viewController: TIPPostViewController, isShowingTipScreen: Bool) {
        // Disable paging when a post view controller is showing the tip screen
        if isShowingTipScreen == true {
            self.dataSource = nil
        } else {
            self.dataSource = self
        }
    }
    
}
