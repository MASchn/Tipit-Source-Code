//
//  IROPostViewController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 2/2/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROPostViewController: UIViewController {
    
    let post: IROPost
    
    // MARK: - View Lifecycle
    init(post: IROPost) {
        self.post = post
    
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.postImageView)
        self.setUpConstraints()

        self.postImageView.image = self.post.contentImage
    }
    
    // MARK: - Lazy Initialization
    lazy var postImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Autolayout
    func setUpConstraints() {
        self.postImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.postImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.postImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.postImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }

}
