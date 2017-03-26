//
//  IROSearchViewController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 1/25/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROSearchViewController: UIViewController {
    
    let searchReuseId: String = "iro.reuseId.search"

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationItem.hidesBackButton = true
        
        self.view.addSubview(self.searchCollectionView)
        
        self.setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.navigationItem.title = "Private"
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.searchCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: self.bottomLayoutGuide.length, right: 0.0)
    }

    // MARK: - Lazy Initialization
    lazy var searchCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(IROSearchCollectionViewCell.self, forCellWithReuseIdentifier: self.searchReuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.searchCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.searchCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.searchCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.searchCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }

}

extension IROSearchViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: IROSearchCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.searchReuseId, for: indexPath) as! IROSearchCollectionViewCell
        return cell
    }
    
}

extension IROSearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 4 * 15.0) / 2.0
        return CGSize(width: width, height: 180.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30.0
    }
    
}
