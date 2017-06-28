//
//  TIPSettingsViewController.swift
//  Ironc.ly
//

import UIKit

class TIPSettingsViewController: UITableViewController {

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Settings"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel"), style: .plain, target: self, action: #selector(self.tappedDismissButton))
        self.navigationController?.navigationBar.titleTextAttributes = TIPStyle.navBarTitleAttributes
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if indexPath.row == 0 {
            cell.textLabel?.text = "Log Out"
            cell.textLabel?.textColor = .red
        }
        return cell
    }
        
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        if cell.textLabel?.text == "Log Out" {
            self.logOut()
        }
    }
    
    // MARK: - Actions
    func tappedDismissButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func logOut() {
        let alert: UIAlertController = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        let yesAction: UIAlertAction = UIAlertAction(title: "Log Out", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: { 
                TIPUser.currentUser?.logOut()
//                AppDelegate.shared.navigationController?.configureForSignIn()
//                AppDelegate.shared.navigationController?.popToRootViewController(animated: true)
            })
        }
        let noAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            //
        })
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }

}
