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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.pageControl)
        self.pageControl.numberOfPages = self.story.posts.count
        
        let firstPost: IROPost = self.story.posts.first!
        let postViewController: IROPostViewController = IROPostViewController(post: firstPost)
        self.setViewControllers([postViewController], direction: .forward, animated: false, completion: nil)
        
        self.setUpConstraints()
    }
    
    // MARK: - Lazy Initialization
    lazy var pageControl: UIPageControl = {
        let control: UIPageControl = UIPageControl()
        control.pageIndicatorTintColor = UIColor.blue
        control.currentPageIndicatorTintColor = UIColor.red
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.pageControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0).isActive = true
        self.pageControl.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.pageControl.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
    }
    
}
