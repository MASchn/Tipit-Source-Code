//
//  TIPMessagesViewController.swift
//  Ironc.ly
//

import UIKit
import SendBirdSDK

class TIPMessagesViewController: UIViewController {
    
    var subbedToUsers: [TIPSearchUser] = [TIPSearchUser]()
    let messageListReuseId: String = "iro.reuseId.messageList"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .iroGray
        self.view.addSubview(messageListCollectionView)
        
        self.setUpConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationController?.isNavigationBarHidden = true
        self.getSubs()
    }
    
    func getFeed() {
        
        TIPAPIClient.getFeed { (feedItems: [TIPFeedItem]?) in
            
            
            if let feedItems: [TIPFeedItem] = feedItems {
                //self.feedItems = feedItems
                self.messageListCollectionView.reloadData()
                
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
            
            self.messageListCollectionView.reloadData()
        }
        
    }

    // MARK: - Lazy Initialization
    lazy var messageListCollectionView: UITableView = {
        //let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let tableView: UITableView = UITableView(frame: self.view.frame)
        tableView.backgroundColor = UIColor.iroGray
        tableView.register(TIPMessageListTableViewCell.self, forCellReuseIdentifier: self.messageListReuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = true
        //collectionView.addSubview(self.refreshControl)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //collectionView.isHidden = true
        return tableView
    }()
    
    func setUpConstraints() {
        self.messageListCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.messageListCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.messageListCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.messageListCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
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

extension TIPMessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subbedToUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TIPMessageListTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.messageListReuseId, for: indexPath) as! TIPMessageListTableViewCell
        
        let user: TIPSearchUser = self.subbedToUsers[indexPath.row]
        cell.configure(with: user)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell: TIPMessageListTableViewCell = self.messageListCollectionView.cellForRow(at: indexPath) as! TIPMessageListTableViewCell
        if let feedItem: TIPSearchUser = cell.feedItem {
            //SBDMain.connect(withUserId: feedItem.userId, completionHandler: { (user, error) in
                
//                if error != nil {
//                    print("ERROR CONNECTING FEED USER: \(error)")
//                    return
//                }
            
                self.goToChat(user: feedItem, for: cell)
            //})
        }
    }
    
}


