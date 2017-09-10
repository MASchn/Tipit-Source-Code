//
//  TIPMessagesViewController.swift
//  Ironc.ly
//

import UIKit
import SendBirdSDK

class TIPMessagesViewController: TIPViewControllerWIthPullDown {
    let yourSubsReuse = "yourSubsNShit"
    let subscribersReuse = "SubsNShit"
    
    var subbedToUsers: [TIPSearchUser] = [TIPSearchUser]()
    let messageListReuseId: String = "iro.reuseId.messageList"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.view.backgroundColor = .iroGray
        self.view.addSubview(self.backgroundImageView)
//        self.view.addSubview(messageListCollectionView)
        self.view.addSubview(yourSubsCollectionView)
        yourSubsCollectionView.register(TIPYourSubsCollectionViewCell.self, forCellWithReuseIdentifier: yourSubsReuse)
        self.view.addSubview(upperWhiteSpace)
        self.view.addSubview(subscribersCollectionView)
        subscribersCollectionView.register(TIPSubscribersCollectionViewCell.self, forCellWithReuseIdentifier: subscribersReuse)
        self.view.addSubview(lowerWhiteSpace)

        self.setUpConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.configureTIPNavBar()
        self.addPullDownMenu()
        
        //self.tabBarController?.navigationController?.isNavigationBarHidden = true
        self.getSubs()
    }
    
    func getFeed() {
        
        TIPAPIClient.getFeed { (feedItems: [TIPFeedItem]?) in
            
            
            if let feedItems: [TIPFeedItem] = feedItems {
                //self.feedItems = feedItems
//                self.messageListCollectionView.reloadData()
                
                if feedItems.count > 0 {
                    //self.feedCollectionView.isHidden = false
                    //self.emptyView.isHidden = true
                } else {
                    //self.showEmptyView()
                }
            } else {
                //self.showEmptyView()
            }
            
            //self.refreshControl.endRefreshing()
        }
    }
    
    func getSubs() {
        
        self.subbedToUsers.removeAll()
        
        guard let subbedTo = TIPUser.currentUser?.subscribedTo else {
            return
        }
        
        guard let subbing = TIPUser.currentUser?.subscribers else {
            return
        }
        
        TIPAPIClient.searchUsers(query: "") { (SearchUsers: [TIPSearchUser]?, error: Error?) in
            
            if let users: [TIPSearchUser] = SearchUsers {
                for user: TIPSearchUser in users {
                    
                    if subbedTo.contains(user.userId) || subbing.contains(user.userId) {
                        self.subbedToUsers.append(user)
                    }
                }
            }
            
//            self.messageListCollectionView.reloadData()
        }
        
    }

    // MARK: - Lazy Initialization
    
    lazy var backgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "crumpled")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    lazy var yourSubsCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                layout.scrollDirection = .horizontal
        
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        return collectionView
    }()
    
    lazy var upperWhiteSpace: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var subscribersCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        return collectionView
    }()

    lazy var lowerWhiteSpace: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
//    lazy var messageListCollectionView: UITableView = {
//        //let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        let tableView: UITableView = UITableView(frame: self.view.frame)
//        tableView.backgroundColor = UIColor.clear
//        tableView.register(TIPMessageListTableViewCell.self, forCellReuseIdentifier: self.messageListReuseId)
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.alwaysBounceVertical = true
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        //collectionView.isHidden = true
//        return tableView
//    }()
    
    func setUpConstraints() {
        
        self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.backgroundImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.yourSubsCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: navBarHeight + 15).isActive = true
        self.yourSubsCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.yourSubsCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.yourSubsCollectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25).isActive = true
        
        self.upperWhiteSpace.topAnchor.constraint(equalTo: yourSubsCollectionView.bottomAnchor, constant: 15).isActive = true
        self.upperWhiteSpace.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.upperWhiteSpace.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.upperWhiteSpace.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.12).isActive = true
        
        self.subscribersCollectionView.topAnchor.constraint(equalTo: self.upperWhiteSpace.bottomAnchor, constant: 30).isActive = true
        self.subscribersCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.subscribersCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.subscribersCollectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25).isActive = true

        self.lowerWhiteSpace.topAnchor.constraint(equalTo: subscribersCollectionView.bottomAnchor, constant: 15).isActive = true
        self.lowerWhiteSpace.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.lowerWhiteSpace.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.lowerWhiteSpace.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.12).isActive = true
        
        
        
        
        
//        self.messageListCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: navBarHeight).isActive = true
//        self.messageListCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        self.messageListCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        self.messageListCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
    
    func goToChat(user: TIPSearchUser, for cell: TIPMessageListTableViewCell){
        
        guard let myUserId = TIPUser.currentUser?.userId else {
            print("NO CURRENT USER ID!!!")
            return
        }
        
        SBDGroupChannel.createChannel(withUserIds: [myUserId, user.userId], isDistinct: true) { (channel, error) in
            
            if error != nil {
                print("ERROR CEATING CHANNEL: \(error)")
                return
            }
            
            let chatVC: TIPChatViewController = TIPChatViewController(feedItem: user, channel: channel!)
            let chatNavController: UINavigationController = UINavigationController(rootViewController: chatVC)
            self.present(chatNavController, animated: true, completion: nil)
        }
        
    }
    
}






extension TIPMessagesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == yourSubsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.yourSubsReuse, for: indexPath)
            return cell

        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.subscribersReuse, for: indexPath)
            return cell
        }
        
    }
}





extension TIPMessagesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == yourSubsCollectionView{
        let size = CGSize(width: (collectionView.bounds.width) / 2, height: collectionView.bounds.height)
        return size
        }else{
            let size = CGSize(width: (collectionView.bounds.width) / 3.3, height: collectionView.bounds.height)
            return size
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == yourSubsCollectionView{
        return 25
        }else{
        return 50
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == yourSubsCollectionView{
            return 25
        }else{
            return 60
        }
    }
    
    
    func scrollToNearestVisibleCollectionViewCellTop() {
        
        
        let visibleCenterPositionOfScrollView = Float(yourSubsCollectionView.contentOffset.x + (self.yourSubsCollectionView.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<yourSubsCollectionView.visibleCells.count {
            let cell = yourSubsCollectionView.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
            
            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = yourSubsCollectionView.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.yourSubsCollectionView.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    func scrollToNearestVisibleCollectionViewCellBottom() {
        
        
        let visibleCenterPositionOfScrollView = Float(subscribersCollectionView.contentOffset.x + (self.subscribersCollectionView.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<subscribersCollectionView.visibleCells.count {
            let cell = subscribersCollectionView.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
            
            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = subscribersCollectionView.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.subscribersCollectionView.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }

    
    
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == yourSubsCollectionView {
        scrollToNearestVisibleCollectionViewCellTop()
        }else{
            scrollToNearestVisibleCollectionViewCellBottom()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == yourSubsCollectionView {
            scrollToNearestVisibleCollectionViewCellTop()
        }else{
            scrollToNearestVisibleCollectionViewCellBottom()
        }
    }

    
    
}



