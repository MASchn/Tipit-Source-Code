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
    var searchUsers: [IROSearchUser] = [IROSearchUser]()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .iroGray
        
        self.navigationController?.navigationItem.hidesBackButton = true
        
        self.view.addSubview(self.searchTextField)
        self.view.addSubview(self.cancelSearchButton)
        self.view.addSubview(self.searchCollectionView)
        
        self.setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Private"
        self.navigationController?.navigationBar.titleTextAttributes = IROStyle.navBarTitleAttributes
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.barTintColor = .white
        
        self.searchCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: self.bottomLayoutGuide.length, right: 0.0)
        
        IROAPIClient.getAllUsers { (searchUsers: [IROSearchUser]?) in
            if let searchUsers: [IROSearchUser] = searchUsers {
                self.searchUsers = searchUsers
                self.searchCollectionView.reloadData()
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    // MARK: - Lazy Initialization
    lazy var searchTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.backgroundColor = .white
        textField.leftViewMode = .always
        let button: UIButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 54.0, height: 45.0))
        button.setImage(#imageLiteral(resourceName: "search_bar"), for: .normal)
        textField.leftView = button
        textField.placeholder = "Search"
        textField.returnKeyType = .search
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var cancelSearchButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: UIFontWeightMedium)
        button.addTarget(self, action: #selector(self.tappedCancelSearchButton(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var searchCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .iroGray
        collectionView.register(IROSearchCollectionViewCell.self, forCellWithReuseIdentifier: self.searchReuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.searchTextField.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.searchTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.searchTextField.rightAnchor.constraint(equalTo: self.cancelSearchButton.leftAnchor).isActive = true
        self.searchTextField.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        
        self.cancelSearchButton.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.cancelSearchButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.cancelSearchButton.bottomAnchor.constraint(equalTo: self.searchTextField.bottomAnchor).isActive = true
        self.cancelSearchButton.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        self.searchCollectionView.topAnchor.constraint(equalTo: self.searchTextField.bottomAnchor).isActive = true
        self.searchCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.searchCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.searchCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
    
    // MARK: - Actions
    func tappedCancelSearchButton(sender: UIButton) {
        self.searchTextField.text = ""
        self.searchTextField.resignFirstResponder()
    }

}

extension IROSearchViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: IROSearchCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.searchReuseId, for: indexPath) as! IROSearchCollectionViewCell
        let searchUser: IROSearchUser = self.searchUsers[indexPath.item]
        let section: IROSearchSection = IROSearchSection(rawValue: indexPath.section)!
        cell.configure(with: searchUser, section: section)
        cell.delegate = self
        return cell
    }
    
}

extension IROSearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 4 * 15.0) / 2.0
        return CGSize(width: width, height: 180.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.0, left: 15.0, bottom: 0.0, right: 15.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30.0
    }
    
}

extension IROSearchViewController: IROSearchCollectionViewCellDelegate {
    
    func tappedFollowButton(with userId: String) {
        IROAPIClient.userAction(action: .follow, userId: userId) { (success: Bool) in
            //
        }
    }
    
    func tappedSubscribeButton(with userId: String) {
        IROAPIClient.userAction(action: .subscribe, userId: userId) { (success: Bool) in
            //
        }
    }
    
}
