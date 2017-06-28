//
//  TIPSearchViewController.swift
//  Ironc.ly
//

import UIKit

class TIPSearchViewController: UIViewController {
    
    let searchReuseId: String = "iro.reuseId.search"
    var searchUsers: [TIPSearchUser] = [TIPSearchUser]()
    var emptyStateColors: [UIColor] = [.sampleColor1, .sampleColor2, .sampleColor3, .sampleColor4]

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .iroGray
        
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.searchCollectionView)
        
        self.setUpConstraints()
        
        // Searching with black query requests all users
        self.search(query: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = "Search"
        self.configureTIPNavBar()
    }
    
    // MARK: - Networking
    func search(query: String) {
        TIPAPIClient.searchUsers(query: query) { (users: [TIPSearchUser]?) in
            if let users: [TIPSearchUser] = users {
                self.searchUsers = users
                self.searchCollectionView.reloadData()
            }
        }
    }

    // MARK: - Lazy Initialization
    lazy var searchBar: UISearchBar = {
        let searchBar: UISearchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.tintColor = .black
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    lazy var searchCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .iroGray
        collectionView.register(TIPSearchCollectionViewCell.self, forCellWithReuseIdentifier: self.searchReuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
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

extension TIPSearchViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TIPSearchCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.searchReuseId, for: indexPath) as! TIPSearchCollectionViewCell
        
        let colorIndex: Int = indexPath.item % 4
        let color: UIColor = self.emptyStateColors[colorIndex]
        cell.postImageView.backgroundColor = color
        
        let searchUser: TIPSearchUser = self.searchUsers[indexPath.item]
        cell.configure(with: searchUser)
        cell.delegate = self
        return cell
    }
    
}

extension TIPSearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell: TIPSearchCollectionViewCell = self.searchCollectionView.cellForItem(at: indexPath) as! TIPSearchCollectionViewCell
        if let userId: String = cell.userId {
            TIPAPIClient.getStory(userId: userId, completionHandler: { (story: TIPStory?) in
                if let story: TIPStory = story, story.posts.count > 0 {
                    let storyViewController: TIPStoryViewController = TIPStoryViewController(story: story, isProfile: false)
                    self.present(storyViewController, animated: true, completion: nil)
                }
            })
        }
    }
    
}

extension TIPSearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGFloat = collectionView.bounds.width / 2.0
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}

extension TIPSearchViewController: TIPSearchCollectionViewCellDelegate {
    
    func searchCellDidSelectUser(with userId: String) {
        let profileViewController: TIPProfileViewController = TIPProfileViewController(userId: userId)
        profileViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "back"), style: .plain, target: profileViewController, action: #selector(profileViewController.tappedBackButton))
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
}

extension TIPSearchViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let query: String = searchBar.text?.lowercased() {
            self.search(query: query)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let query: String = searchBar.text?.lowercased() {
            self.search(query: query)
        }
    }
    
}
