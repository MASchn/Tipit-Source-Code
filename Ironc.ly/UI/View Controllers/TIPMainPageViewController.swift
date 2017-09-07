//
//  TIPMainPageViewController.swift
//  Ironc.ly
//
//  Created by Alex Laptop on 9/1/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class TIPMainPageViewController: UIViewController {
    
    var iconTop: NSLayoutConstraint?
    
    var iconImageArray = [UIImage(), #imageLiteral(resourceName: "draw_icon"), #imageLiteral(resourceName: "type_icon"), #imageLiteral(resourceName: "video_icon"), #imageLiteral(resourceName: "camera_icon"), #imageLiteral(resourceName: "messaging_icon"), #imageLiteral(resourceName: "feed_icon"), #imageLiteral(resourceName: "profile_icon"), #imageLiteral(resourceName: "settings_icon"), UIImage()]
    var iconSelection = 0
    
    let iconReuseId = "iro.reuseId.main"
    
    var onceOnly = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = self.iconCollectionView;
        scrollView.delegate = self;
        
        self.view.addSubview(self.backgroundImageView)
        //self.view.addSubview(self.iconImageView)
        self.view.addSubview(self.searchIconImageView)
        self.view.addSubview(self.searchTextField)
        self.view.addSubview(self.iconCollectionView)
        //self.view.addSubview(self.cutOutImageView)
        self.view.addSubview(self.switchImageView)
        //self.view.addSubview(self.swipeImageView)
        
        self.cutOutImageView.isUserInteractionEnabled = true
        let tapIcon = UITapGestureRecognizer(target: self, action: #selector(self.tappedIcon))
        //self.cutOutImageView.addGestureRecognizer(tapIcon)
        
        self.switchImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.switchTapped))
        self.switchImageView.addGestureRecognizer(tap)
        
        self.swipeImageView.isUserInteractionEnabled = true
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedLeft))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedRight))
        swipeRight.direction = .right
        //self.swipeImageView.addGestureRecognizer(swipeLeft)
        //self.swipeImageView.addGestureRecognizer(swipeRight)
        
        self.setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.backgroundImageView.image = TIPLoginViewController.backgroundPicArray[TIPUser.currentUser?.backgroundPicSelection ?? 0]
        //self.iconCollectionView.scrollToItem(at: IndexPath(item: 2, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    lazy var backgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "crumpled")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var cutOutImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "cut_out")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "feed_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var switchImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "public_switch_on")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var swipeImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "SwipeHereEdited")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var iconCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(TIPProfileStoryCollectionViewCell.self, forCellWithReuseIdentifier: self.iconReuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var searchTextField: TIPTextField = {
        let textField: TIPTextField = TIPTextField(placeholder: "SEARCH", fontSize: AppDelegate.shared.fontSize)
        textField.autocapitalizationType = .none
        textField.keyboardType = .default
        textField.returnKeyType = .search
        textField.autocorrectionType = .no
        textField.borderStyle = .none
        textField.background = #imageLiteral(resourceName: "Text Field")
        textField.delegate = self
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var searchIconImageView: UIButton = {
        let button: UIButton = UIButton()
        button.addTarget(self, action: #selector(self.searchPressed), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "searchIcon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setUpConstraints() {
        
        self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.backgroundImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
//        self.cutOutImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        self.cutOutImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -self.view.frame.size.height/4).isActive = true
//        self.cutOutImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.35).isActive = true
//        self.cutOutImageView.widthAnchor.constraint(equalTo: self.cutOutImageView.heightAnchor).isActive = true
        
//        iconTop = self.iconImageView.centerXAnchor.constraint(equalTo: self.cutOutImageView.centerXAnchor)
//        iconTop?.isActive = true
//        self.iconImageView.centerYAnchor.constraint(equalTo: self.cutOutImageView.centerYAnchor).isActive = true
//        self.iconImageView.heightAnchor.constraint(equalTo: self.cutOutImageView.heightAnchor, multiplier: 0.4).isActive = true
//        self.iconImageView.widthAnchor.constraint(equalTo: self.iconImageView.heightAnchor).isActive = true
        
        self.iconCollectionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -self.view.frame.size.height/6).isActive = true
        self.iconCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.iconCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.iconCollectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25).isActive = true
        
        self.searchIconImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -self.view.frame.size.width/4).isActive = true
        self.searchIconImageView.bottomAnchor.constraint(equalTo: self.iconCollectionView.topAnchor, constant: -20).isActive = true
        self.searchIconImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.12).isActive = true
        self.searchIconImageView.heightAnchor.constraint(equalTo: self.searchIconImageView.widthAnchor).isActive = true
        
        //self.searchIconImageView.layoutIfNeeded()
        
        self.searchTextField.leftAnchor.constraint(equalTo: self.searchIconImageView.rightAnchor, constant: 10).isActive = true
        self.searchTextField.centerYAnchor.constraint(equalTo: self.searchIconImageView.centerYAnchor).isActive = true
        self.searchTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -self.view.frame.size.width/2).isActive = true
        self.searchTextField.heightAnchor.constraint(equalTo: self.searchIconImageView.heightAnchor, multiplier: 1).isActive = true
        
        self.switchImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 4).isActive = true
        self.switchImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.size.height/4.5).isActive = true
        self.switchImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
        self.switchImageView.widthAnchor.constraint(equalTo: self.switchImageView.heightAnchor, multiplier: 1).isActive = true
        
//        self.swipeImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        self.swipeImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        self.swipeImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//        self.swipeImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25).isActive = true
    }
    
    func searchPressed() {
        
        self.searchTextField.resignFirstResponder()
        
        let nav = AppDelegate.shared.tabBarController?.viewControllers?[1] as? UINavigationController
        
        let searchVC = nav?.viewControllers[0] as? TIPSearchViewController
        
        if let text = self.searchTextField.text {
            searchVC?.searchText = text
        } else {
            searchVC?.searchText = ""
        }
        
        AppDelegate.shared.tabBarController?.selectedIndex = 1
        
        self.navigationController?.dismiss(animated: true, completion: { 
            //
        })
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    func tappedIcon(sender: UITapGestureRecognizer) {
        
        if self.iconSelection != 2 {
            AppDelegate.shared.tabBarController?.selectedIndex = self.iconSelection
        }
        
        if self.iconSelection == 2 {
            let cameraViewController: TIPCamViewController = TIPCamViewController()
            self.present(cameraViewController, animated: true, completion: nil)
            //AppDelegate.shared.pullUpCamera()
        } else {
            self.navigationController?.dismiss(animated: true, completion: {
                
                
            })
        }
        
        
        
//        if AppDelegate.shared.tabBarController?.selectedIndex == 2 {
//            let cameraViewController: TIPCamViewController = TIPCamViewController()
//            self.tabBarController?.present(cameraViewController, animated: true, completion: nil)
//        }
    }
    
    func switchTapped(sender: UITapGestureRecognizer) {
        
        let tapLocation = sender.location(in: self.switchImageView)
        
        if tapLocation.y > self.switchImageView.bounds.height/2 {
            if self.switchImageView.image == #imageLiteral(resourceName: "public_switch_on") {
                self.switchImageView.image = #imageLiteral(resourceName: "private_switch_on")
            }
        } else {
            if self.switchImageView.image == #imageLiteral(resourceName: "private_switch_on") {
                self.switchImageView.image = #imageLiteral(resourceName: "public_switch_on")
            }
        }
        
    }
    
    func swipedLeft(sender: UISwipeGestureRecognizer) {
        
        if self.iconSelection == 4 {
            self.iconSelection = 0
        } else {
            self.iconSelection += 1
        }
        
        self.iconTop?.constant += 55
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }) { (completed: Bool) in
            self.iconImageView.image = self.iconImageArray[self.iconSelection]
            self.iconTop?.constant -= 110
            self.view.layoutIfNeeded()
            self.iconTop?.constant += 55
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            }) { (completed: Bool) in
                //
            }
        }
        
    }
    
    func swipedRight(sender: UISwipeGestureRecognizer) {
        
        if self.iconSelection == 0 {
            self.iconSelection = 4
        } else {
            self.iconSelection -= 1
        }
        
        self.iconTop?.constant -= 55
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }) { (completed: Bool) in
            self.iconImageView.image = self.iconImageArray[self.iconSelection]
            self.iconTop?.constant += 110
            self.view.layoutIfNeeded()
            self.iconTop?.constant -= 55
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            }) { (completed: Bool) in
                //
            }
        }
        
    }
    
}

extension TIPMainPageViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchPressed()
        return false
    }
}

extension TIPMainPageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.iconImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TIPProfileStoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.iconReuseId, for: indexPath) as! TIPProfileStoryCollectionViewCell
        //cell.delegate = self
        cell.storyImage.image = self.iconImageArray[indexPath.item]
        cell.tag = indexPath.item
        return cell
    }
}

extension TIPMainPageViewController: UICollectionViewDelegate {
    
    
    
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !onceOnly {
            let indexToScrollTo = IndexPath(item: 4, section: 0)
            self.iconCollectionView.scrollToItem(at: indexToScrollTo, at: .centeredHorizontally, animated: false)
            onceOnly = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! TIPProfileStoryCollectionViewCell

        
        if cell.storyImage.image == #imageLiteral(resourceName: "feed_icon") {
            AppDelegate.shared.tabBarController?.selectedIndex = 0
            self.navigationController?.dismiss(animated: true, completion: {})
        } else if cell.storyImage.image == #imageLiteral(resourceName: "search_icon"){
            AppDelegate.shared.tabBarController?.selectedIndex = 1
            self.navigationController?.dismiss(animated: true, completion: {})
        } else if cell.storyImage.image == #imageLiteral(resourceName: "camera_icon"){
            let cameraViewController: TIPCamViewController = TIPCamViewController()
            self.present(cameraViewController, animated: true, completion: nil)
        } else if cell.storyImage.image == #imageLiteral(resourceName: "messaging_icon") {
            AppDelegate.shared.tabBarController?.selectedIndex = 3
            self.navigationController?.dismiss(animated: true, completion: {})
        } else if cell.storyImage.image == #imageLiteral(resourceName: "profile_icon") {
            AppDelegate.shared.tabBarController?.selectedIndex = 4
            self.navigationController?.dismiss(animated: true, completion: {})
        } else if cell.storyImage.image == #imageLiteral(resourceName: "settings_icon") {
            let settingsViewController: TIPSettingsViewController = TIPSettingsViewController()
            let settingsNavController: UINavigationController = UINavigationController(rootViewController: settingsViewController)
            self.present(settingsNavController, animated: true, completion: nil)
        }
    
    }
}

extension TIPMainPageViewController: UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func scrollToNearestVisibleCollectionViewCell() {
        let visibleCenterPositionOfScrollView = Float(iconCollectionView.contentOffset.x + (self.iconCollectionView.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<iconCollectionView.visibleCells.count {
            let cell = iconCollectionView.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
            
            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = iconCollectionView.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.iconCollectionView.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollToNearestVisibleCollectionViewCell()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollToNearestVisibleCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.height - 10, height: collectionView.bounds.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
