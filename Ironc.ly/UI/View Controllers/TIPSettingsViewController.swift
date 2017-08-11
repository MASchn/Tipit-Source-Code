//
//  TIPSettingsViewController.swift
//  Ironc.ly
//

import UIKit
import MessageUI
import FBSDKLoginKit

class TIPSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let coinsToSubValues = ["1000", "2000", "3000"]
    
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
        self.view.backgroundColor = UIColor.iroGray
        self.view.addSubview(self.settingsTableView)
        self.view.addSubview(self.coinsSegmentedControl)
        
        if let coinsToSub = TIPUser.currentUser?.coinsToSubscribe {
            if coinsToSub == 2000 {
                self.coinsSegmentedControl.selectedSegmentIndex = 1
            }
            else if coinsToSub == 3000 {
                self.coinsSegmentedControl.selectedSegmentIndex = 2
            }
        }
        
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Settings"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel"), style: .plain, target: self, action: #selector(self.tappedDismissButton))
        self.navigationController?.navigationBar.titleTextAttributes = TIPStyle.navBarTitleAttributes
    }
    
    // MARK: - Lazy Initialization
    lazy var settingsTableView: UITableView = {
        //let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let tableView: UITableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.backgroundColor = UIColor.iroGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = true
        tableView.isScrollEnabled = false
        //collectionView.addSubview(self.refreshControl)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //collectionView.isHidden = true
        return tableView
    }()
    
    lazy var coinsSegmentedControl: UISegmentedControl = {
       
        let segmentedControl: UISegmentedControl = UISegmentedControl(items: self.coinsToSubValues)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        //segmentedControl.addTarget(self, action: #selector(changeCoinsToSub), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    func setUpConstraints() {
        self.settingsTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.settingsTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.settingsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.settingsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
        
        self.coinsSegmentedControl.topAnchor.constraint(equalTo: self.settingsTableView.bottomAnchor, constant: 20).isActive = true
        self.coinsSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //self.coinsSegmentedControl.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        //self.coinsSegmentedControl.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        //self.coinsSegmentedControl.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 20).isActive = true
        //self.coinsSegmentedControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 30).isActive = true
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let setting: TIPSetting = TIPSetting(rawValue: indexPath.row)!
        
        cell.textLabel?.text = setting.title()
        cell.textLabel?.textColor = setting.titleColor()
        
        return cell
    }
        
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let setting: TIPSetting = TIPSetting(rawValue: indexPath.row)!
        
        switch setting {
        case .ContactSupport:
            self.contactSupport()
        case .LogOut:
            self.logOut()
        }
        
    }
    
//    let parameters: [String: Any] = [
//        "username" : self.usernameCell.textField.text ?? "",
//        "first_name" : self.nameCell.textField.text ?? "",
//        "website" : self.websiteCell.textField.text ?? "",
//        "bio" : self.bioCell.textField.text ?? ""
//    ]
//    TIPAPIClient.updateUser(parameters: parameters, completionHandler: { (success: Bool) in
//    if success == true {
//    self.dismiss(animated: true, completion: nil)
//    } else {
//    self.showAlert(title: "Could not save", message: "An error occurred", completion: nil)
//    }
//    })
    
    func changeCoinsToSub(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("1000")
            
            let parameters: [String: Any] = [
                "coinsToSubscribe" : "1000"
            ]
            
            TIPAPIClient.updateUser(parameters: parameters, completionHandler: { (success: Bool) in
                if success == true {
                    print("successfully updated coins to sub")
                } else {
                    print("failed updating coins")
                }
            })
            
        case 1:
            print("2000")
            
            let parameters: [String: Any] = [
                "coinsToSubscribe" : "2000"
            ]
            
            TIPAPIClient.updateUser(parameters: parameters, completionHandler: { (success: Bool) in
                if success == true {
                    print("successfully updated coins to sub")
                } else {
                    print("failed updating coins")
                }
            })
            
        case 2:
            print("3000")
            
            let parameters: [String: Any] = [
                "coinsToSubscribe" : "3000"
            ]
            
            TIPAPIClient.updateUser(parameters: parameters, completionHandler: { (success: Bool) in
                if success == true {
                    print("successfully updated coins to sub")
                } else {
                    print("failed updating coins")
                }
            })
            
        default:
            break
        }
    }
    
    // MARK: - Actions
    func tappedDismissButton() {
        self.dismiss(animated: true, completion: nil)
        
        switch self.coinsSegmentedControl.selectedSegmentIndex {
        case 0:
        print("1000")
        
        let parameters: [String: Any] = [
            "coinsToSubscribe" : "1000"
        ]
        
        TIPAPIClient.updateUser(parameters: parameters, completionHandler: { (success: Bool) in
            if success == true {
                print("successfully updated coins to sub")
            } else {
                print("failed updating coins")
            }
        })
        
        case 1:
        print("2000")
        
        let parameters: [String: Any] = [
            "coinsToSubscribe" : "2000"
        ]
        
        TIPAPIClient.updateUser(parameters: parameters, completionHandler: { (success: Bool) in
            if success == true {
                print("successfully updated coins to sub")
            } else {
                print("failed updating coins")
            }
        })
        
        case 2:
        print("3000")
        
        let parameters: [String: Any] = [
            "coinsToSubscribe" : "3000"
        ]
        
        TIPAPIClient.updateUser(parameters: parameters, completionHandler: { (success: Bool) in
            if success == true {
                print("successfully updated coins to sub")
            } else {
                print("failed updating coins")
            }
        })
        
        default:
        break
    }
    
    }

    func logOut() {
        let alert: UIAlertController = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        let yesAction: UIAlertAction = UIAlertAction(title: "Log Out", style: .destructive) { (action) in
            TIPUser.currentUser?.logOut()
            let signInNavController: UINavigationController = AppDelegate.shared.initializeSignInController()
            
            let presentingVC = self.presentingViewController
            self.dismiss(animated: true, completion: { 
                presentingVC?.present(signInNavController, animated: true, completion: nil)
            })
            //self.present(signInNavController, animated: true, completion: nil)
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
