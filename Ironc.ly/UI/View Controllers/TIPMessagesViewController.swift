//
//  TIPMessagesViewController.swift
//  Ironc.ly
//

import UIKit
import SendBirdSDK

class TIPMessagesViewController: UIViewController {
    
    var feedItems: [TIPFeedItem] = [TIPFeedItem]()
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
        self.getFeed()
    }
    
    func getFeed() {
        
        TIPAPIClient.getFeed { (feedItems: [TIPFeedItem]?) in
            
            
            if let feedItems: [TIPFeedItem] = feedItems {
                self.feedItems = feedItems
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
    
    func goToChat(feedItem: TIPFeedItem, for cell: TIPMessageListTableViewCell){
        
        guard let myUserId = TIPUser.currentUser?.userId else {
            print("NO CURRENT USER ID!!!")
            return
        }
        
        SBDGroupChannel.createChannel(withUserIds: [myUserId, feedItem.userId], isDistinct: true) { (channel, error) in
            
            if error != nil {
                print("ERROR CEATING CHANNEL: \(error)")
                return
            }
            
            let chatVC: TIPChatViewController = TIPChatViewController(feedItem: feedItem, channel: channel!)
            let chatNavController: UINavigationController = UINavigationController(rootViewController: chatVC)
            self.present(chatNavController, animated: true, completion: nil)
        }
        
    }
    
}

extension TIPMessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TIPMessageListTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.messageListReuseId, for: indexPath) as! TIPMessageListTableViewCell
        
        let feedItem: TIPFeedItem = self.feedItems[indexPath.row]
        cell.configure(with: feedItem)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell: TIPMessageListTableViewCell = self.messageListCollectionView.cellForRow(at: indexPath) as! TIPMessageListTableViewCell
        if let feedItem: TIPFeedItem = cell.feedItem {
            //SBDMain.connect(withUserId: feedItem.userId, completionHandler: { (user, error) in
                
//                if error != nil {
//                    print("ERROR CONNECTING FEED USER: \(error)")
//                    return
//                }
            
                self.goToChat(feedItem: feedItem, for: cell)
            //})
        }
    }
    
}


