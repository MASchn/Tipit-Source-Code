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
    var searchItems: [IROSearchItem] = [IROSearchItem]()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .iroGray
        
        self.navigationController?.navigationItem.hidesBackButton = true
        
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.searchCollectionView)
        
        IROSearch.getAllUsers { (searchItems: [IROSearchItem]?) in
            if let searchItems: [IROSearchItem] = searchItems {
                self.searchItems = searchItems
                self.searchCollectionView.reloadData()
            }
        }
        
        self.setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = "Private"
        self.tabBarController?.navigationController?.navigationBar.titleTextAttributes = IROStyle.navBarTitleAttributes
        self.tabBarController?.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        
        self.searchCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: self.bottomLayoutGuide.length, right: 0.0)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    // MARK: - Lazy Initialization
    lazy var searchBar: UISearchBar = {
        let searchBar: UISearchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .white
        searchBar.backgroundImage = UIImage()
        searchBar.isTranslucent = false
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    lazy var searchCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .iroGray
        collectionView.register(IROSearchCollectionViewCell.self, forCellWithReuseIdentifier: self.searchReuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.searchBar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.searchBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.searchBar.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.searchBar.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        
        self.searchCollectionView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor).isActive = true
        self.searchCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.searchCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.searchCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }

}

extension IROSearchViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: IROSearchCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.searchReuseId, for: indexPath) as! IROSearchCollectionViewCell
        let searchItem: IROSearchItem = self.searchItems[indexPath.item]
        cell.configure(with: searchItem)
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
