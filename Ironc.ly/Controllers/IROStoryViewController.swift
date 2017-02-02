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
    
    let story: IROStory
    
    init(story: IROStory) {
        self.story = story
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var viewControllers: [IROPostViewController] = []
        for post: IROPost in self.story.posts {
            // Create a post view controller for each post in the story
            let postViewController: IROPostViewController = IROPostViewController(post: post)
            viewControllers.append(postViewController)
        }
        
        self.setViewControllers([viewControllers.first!], direction: .forward, animated: false, completion: nil)
    }
    
}
