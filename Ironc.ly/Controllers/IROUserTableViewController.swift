//
//  IROUserTableViewController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 6/20/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROUserTableViewController: UITableViewController {
    
    var userIds: [String] = ["A", "B", "C"]
    let userReuseId: String = "iro.reuseId.user"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.userReuseId)
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
