//
//  IROEditProfileViewController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 4/17/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROEditProfileViewController: UIViewController {
    
    let editReuseId: String = "iro.reuseId.edit"
    let titles: [String] = ["Name", "Username", "Website", "Information"]

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.settingsTableView)
        
        self.setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Edit Profile"
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.tappedDismissButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.tappedDoneButton))
    }
    
    // MARK: - Lazy Initialization
    lazy var settingsTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = 64.0
        tableView.backgroundColor = .white
        tableView.register(IROEditProfileTableViewCell.self, forCellReuseIdentifier: self.editReuseId)
//        tableView.register(UIView.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.settingsTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.settingsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.settingsTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.settingsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
    
    // MARK: - Actions
    func tappedDismissButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tappedDoneButton() {
        // TODO: Save
        self.dismiss(animated: true, completion: nil)
    }

}

extension IROEditProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: IROEditProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.editReuseId) as! IROEditProfileTableViewCell
        cell.titleLabel.text = self.titles[indexPath.row]
        return cell
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view: UIView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")!
//        view.frame = CGRect(x: 0.0, y: 0.0, width: 375.0, height: 120.0)
//        view.backgroundColor = .lightGray
//        return view
//    }
    
}

extension IROEditProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: IROEditProfileTableViewCell = tableView.cellForRow(at: indexPath) as! IROEditProfileTableViewCell
        cell.textView.becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120.0
    }
    
}
