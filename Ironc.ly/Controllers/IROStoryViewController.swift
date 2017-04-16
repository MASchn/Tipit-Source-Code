//
//  IROStoryViewController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 2/2/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

// This will contain multiple view controller "IRO Posts"

class IROStoryViewController: UIPageViewController {
    
    // MARK: - Properties
    let story: IROStory
    var currentIndex: Int = 0
    
    // MARK: - View Lifecycle
    init(story: IROStory) {
        self.story = story
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
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.pageControl)
        self.view.addSubview(self.tipButton)

        self.pageControl.numberOfPages = self.story.posts.count
        
        let firstPost: IROPost = self.story.posts.first!
        let postViewController: IROPostViewController = IROPostViewController(post: firstPost)
        self.setViewControllers([postViewController], direction: .forward, animated: false, completion: nil)
        
        self.setUpConstraints()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tipButton.layer.cornerRadius = self.tipButton.frame.size.height / 2.0
    }
    
    // MARK: - Lazy Initialization
    lazy var pageControl: UIPageControl = {
        let control: UIPageControl = UIPageControl()
        control.pageIndicatorTintColor = UIColor(white: 0.0, alpha: 0.3)
        control.currentPageIndicatorTintColor = IROConstants.green
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    lazy var tipButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("TIPP", for: .normal)
        button.setTitleColor(IROConstants.green, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: UIFontWeightHeavy)
        button.layer.borderColor = IROConstants.green.cgColor
        button.layer.borderWidth = 2.0
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.pageControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10.0).isActive = true
        self.pageControl.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15.0).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
        
        self.tipButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50.0).isActive = true
        self.tipButton.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.tipButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.tipButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    // MARK: - Actions
    func dismissStory() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension IROStoryViewController: UIPageViewControllerDataSource {
    
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

extension IROStoryViewController: UIPageViewControllerDelegate {
    
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
