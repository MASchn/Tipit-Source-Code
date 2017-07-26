//
//  TIPSettingsViewController.swift
//  Ironc.ly
//

import UIKit
import MessageUI
import FBSDKLoginKit

class TIPSettingsViewController: UITableViewController {
    
    enum TIPSetting: Int {
        case ContactSupport
        case LogOut
        
        func title() -> String {
            switch self {
            case .ContactSupport:
                return "Contact Support"
            case .LogOut:
                return "Log Out"
            }
        }
        
        func titleColor() -> UIColor {
            switch self {
            case .LogOut:
                return .red
            default:
                return .black
            }
        }
    }

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
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let setting: TIPSetting = TIPSetting(rawValue: indexPath.row)!
        
        cell.textLabel?.text = setting.title()
        cell.textLabel?.textColor = setting.titleColor()
        
        return cell
    }
        
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let setting: TIPSetting = TIPSetting(rawValue: indexPath.row)!
        
        switch setting {
        case .ContactSupport:
            self.contactSupport()
        case .LogOut:
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
            TIPUser.currentUser?.logOut()
            let signInNavController: UINavigationController = AppDelegate.shared.initializeSignInController()
            self.present(signInNavController, animated: true, completion: nil)
        }
        let noAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            //
        })
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func contactSupport() {
        let mailComposeVC = self.mailComposeViewController()
        self.present(mailComposeVC, animated: true, completion: nil)
    }
    
    func mailComposeViewController() -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["support@tipapp.io"])
        return mailComposeVC
    }

}

extension TIPSettingsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
