//
//  TIPSearchViewController.swift
//  Ironc.ly
//

import UIKit

class TIPSearchViewController: UIViewController {
    
    let searchReuseId: String = "iro.reuseId.search"
    var searchUsers: [TIPSearchUser] = [TIPSearchUser]()
    var emptyStateImages: [UIImage] = [#imageLiteral(resourceName: "tipitbackground5_7"), #imageLiteral(resourceName: "tipitbackground4_7"),#imageLiteral(resourceName: "tipitbackground3_7"), #imageLiteral(resourceName: "tipitbackground1_7"), #imageLiteral(resourceName: "tipitbackground2_7")]
//    var emptyStateImages: [UIImage] = [#imageLiteral(resourceName: "forgot_password_background"), #imageLiteral(resourceName: "register_background"), #imageLiteral(resourceName: "login_background"), #imageLiteral(resourceName: "feed_image_1"), #imageLiteral(resourceName: "feed_image_2")]

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .iroGray
        
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.searchCollectionView)
        
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: self.tabBarController!.tabBar.frame.height, right: 0.0)
        
        self.searchCollectionView.contentInset = adjustForTabbarInsets
        self.searchCollectionView.scrollIndicatorInsets = adjustForTabbarInsets
        self.searchCollectionView.scrollIndicatorInsets.bottom -= 10
        self.searchCollectionView.contentInset.bottom -= 10
        
        self.setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = "Search"
        self.configureTIPNavBar()
        
        // Searching with black query requests all users
        self.search()
    }
    
    // MARK: - Networking
    func search() {
        if let query: String = self.searchBar.text?.lowercased() {
            TIPAPIClient.searchUsers(query: query) { (users: [TIPSearchUser]?, error: Error?) in
                if let users: [TIPSearchUser] = users {
                    self.searchUsers = users
                    self.searchCollectionView.reloadData()
                }
                self.refreshControl.endRefreshing()
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
        collectionView.addSubview(self.refreshControl)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var noResultsView: UIView = {
        let view: UIView = UIView()
        return view
    }()
    
    lazy var noInternetView: TIPEmptyStateView = {
        let view: TIPEmptyStateView = TIPEmptyStateView()
        return view
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let control: UIRefreshControl = UIRefreshControl()
        control.backgroundColor = .iroBlue
        control.tintColor = .white
        control.addTarget(self, action: #selector(self.search), for: .valueChanged)
        return control
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
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
        
        let imageIndex: Int = indexPath.item % 5
        let placeholderImage: UIImage = self.emptyStateImages[imageIndex]
        
        let searchUser: TIPSearchUser = self.searchUsers[indexPath.item]
        cell.configure(with: searchUser)
        
        if cell.postImageView.image == nil {
            cell.postImageView.image = placeholderImage
            cell.usernameLabel.textColor = .black
        }
    
        
        cell.delegate = self
        return cell
    }
    
}

extension TIPSearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell: TIPSearchCollectionViewCell = self.searchCollectionView.cellForItem(at: indexPath) as! TIPSearchCollectionViewCell
        if let user: TIPSearchUser = cell.user {
            TIPAPIClient.getStory(userId: user.userId, completionHandler: { (story: TIPStory?) in
                if let story: TIPStory = story, story.posts.count > 0 {
                    let storyViewController: TIPStoryViewController = TIPStoryViewController(story: story, username: user.username, profileImage: cell.profileImageView.image, userID: user.userId, searchUser: user)
                    
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
    
    func searchCellDidSelectUser(user: TIPSearchUser) {
        let profileViewController: TIPProfileViewController = TIPProfileViewController(searchUser: user)
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
        self.search()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.search()
    }
    
}
