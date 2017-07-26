//
//  TIPMessagesViewController.swift
//  Ironc.ly
//

import UIKit

class TIPMessagesViewController: UIViewController {

    let messageListReuseId: String = "iro.reuseId.messageList"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .iroGray
        self.view.addSubview(messageListCollectionView)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationController?.isNavigationBarHidden = true
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
    
}

extension TIPMessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TIPMessageListTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.messageListReuseId, for: indexPath) as! TIPMessageListTableViewCell
        
        cell.profileImageView.image = #imageLiteral(resourceName: "user1")
        cell.usernameLabel.text = "chick"
        
        return cell
    }
}


