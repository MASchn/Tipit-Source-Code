//
//  IROUserTableViewController.swift
//  Ironc.ly
//

import UIKit

class IROUserTableViewController: UITableViewController {
    
    var userIds: [String] = ["A", "B", "C"]
    let userReuseId: String = "iro.reuseId.user"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.userReuseId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = IROStyle.navBarTitleAttributes
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(self.tappedBackButton))
    }
    
    func tappedBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userIds.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.userReuseId, for: indexPath)
        let userId: String = self.userIds[indexPath.row]
        cell.textLabel?.text = userId
        return cell
    }

}
