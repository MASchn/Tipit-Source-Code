//
//  IROEditProfileViewController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 4/17/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROEditProfileViewController: UITableViewController {
    
    // MARK: - View Lifecycle
    override init(style: UITableViewStyle) {
        super.init(style: style)
        
        self.view.backgroundColor = .white
        
        self.tableView.rowHeight = 70.0
        self.tableView.backgroundColor = .groupTableViewBackground
        
        self.title = "Edit Profile"
        
        self.tableView.tableHeaderView = self.editProfileHeaderView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.nameCell.textField.text = IROUser.currentUser?.fullName
        self.usernameCell.textField.text = IROUser.currentUser?.username
        self.websiteCell.textField.text = IROUser.currentUser?.website
        self.bioCell.textField.text = IROUser.currentUser?.bio
        self.editProfileHeaderView.profileImageView.image = IROUser.currentUser?.profileImage
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.tappedDismissButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.tappedDoneButton))
    }
    
    // MARK: - Lazy Initialization
    lazy var editProfileHeaderView: IROEditProfileHeaderView = {
        let editProfileFrame: CGRect = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: 120.0)
        let headerView: IROEditProfileHeaderView = IROEditProfileHeaderView(frame: editProfileFrame)
        return headerView
    }()
    
    lazy var nameCell: IROEditProfileTableViewCell = {
        let cell: IROEditProfileTableViewCell = IROEditProfileTableViewCell()
        cell.titleLabel.text = "Name"
        cell.delegate = self
        return cell
    }()
    
    lazy var usernameCell: IROEditProfileTableViewCell = {
        let cell: IROEditProfileTableViewCell = IROEditProfileTableViewCell()
        cell.titleLabel.text = "Username"
        cell.textField.autocapitalizationType = .none
        cell.textField.autocorrectionType = .no
        cell.textField.returnKeyType = .next
        cell.delegate = self
        return cell
    }()
    
    lazy var websiteCell: IROEditProfileTableViewCell = {
        let cell: IROEditProfileTableViewCell = IROEditProfileTableViewCell()
        cell.titleLabel.text = "Website"
        cell.textField.keyboardType = .URL
        cell.textField.autocapitalizationType = .none
        cell.textField.autocorrectionType = .no
        cell.textField.returnKeyType = .next
        cell.delegate = self
        return cell
    }()
    
    lazy var bioCell: IROEditProfileTableViewCell = {
        let cell: IROEditProfileTableViewCell = IROEditProfileTableViewCell()
        cell.titleLabel.text = "Information"
        cell.textField.returnKeyType = .done
        cell.delegate = self
        return cell
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    func tappedDismissButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tappedDoneButton() {
        IROAPIClient.updateUser(
            username: self.usernameCell.textField.text,
            fullname: self.nameCell.textField.text,
            website: self.websiteCell.textField.text,
            bio: self.bioCell.textField.text)
        { (success: Bool) in
            if success == true {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showAlert(title: "Could not save", message: "An error occurred", completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return self.nameCell
        case 1:
            return self.usernameCell
        case 2:
            return self.websiteCell
        case 3:
            return self.bioCell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: IROEditProfileTableViewCell = tableView.cellForRow(at: indexPath) as! IROEditProfileTableViewCell
        cell.textField.becomeFirstResponder()
    }

}

extension IROEditProfileViewController: IROEditProfileHeaderViewDelegate {
    
    func tappedChangeProfileButton() {
        self.view.endEditing(true)
        self.showPhotoActionSheet()
    }
    
    func tappedChangeBackgroundButton() {
        self.view.endEditing(true)
        self.showPhotoActionSheet()
    }
    
}

extension IROEditProfileViewController: IROEditProfileCellDelegate {
    
    func finishedTyping(cell: IROEditProfileTableViewCell) {
        switch cell {
        case self.nameCell:
            self.usernameCell.textField.becomeFirstResponder()
        case self.usernameCell:
            self.websiteCell.textField.becomeFirstResponder()
        case self.websiteCell:
            self.bioCell.textField.becomeFirstResponder()
        case self.bioCell:
            self.bioCell.textField.resignFirstResponder()
        default:
            break
        }
    }
    
}
