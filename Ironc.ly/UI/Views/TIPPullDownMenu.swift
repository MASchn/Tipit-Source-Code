//
//  TIPPullDownMenu.swift
//  Ironc.ly
//
//  Created by Alex Laptop on 9/4/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

protocol pullDownMenuDelegate: class {
    func hideMenuBringUpNewView(view: UIViewController)
    func hidePullDownMenuFast()
    func animateMenu()
    func dismissView()
}

class TIPPullDownMenu: UIView {
    
    weak var delegate: pullDownMenuDelegate?
    
    var iconImageArray = [#imageLiteral(resourceName: "miniDrawIcon"), #imageLiteral(resourceName: "miniTypeIcon"), #imageLiteral(resourceName: "miniVideoIcon"), #imageLiteral(resourceName: "miniCameraIcon"), #imageLiteral(resourceName: "miniMessagingIcon"), #imageLiteral(resourceName: "miniFeedIcon"), #imageLiteral(resourceName: "miniProfileIcon"), #imageLiteral(resourceName: "miniSettingsIcon")]
    let pullDownReuseId = "iro.pullDown"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //self.backgroundColor = .groupTableViewBackground
        //self.backgroundColor = .red
        
        self.addSubview(self.backgroundImageView)
        self.addSubview(self.menuCollectionView)
        self.addSubview(self.pullUpView)
        
//        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipedMenu))
//        swipe.direction = .up
//        self.pullUpView.isUserInteractionEnabled = true
//        self.pullUpView.addGestureRecognizer(swipe)
        
        self.setUpConstraints()
        
        self.layoutIfNeeded()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    lazy var backgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        //imageView.contentMode = .scaleAspectFill
        //imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "origPullDownMenuEdited")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var menuCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(TIPPullDownCollectionViewCell.self, forCellWithReuseIdentifier: self.pullDownReuseId)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var pullUpView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        //imageView.contentMode = .scaleAspectFill
        //imageView.clipsToBounds = true
        imageView.image = UIImage()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func setUpConstraints() {
        
        self.backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.backgroundImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.backgroundImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.menuCollectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.menuCollectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.menuCollectionView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4).isActive = true
        self.menuCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        
        self.pullUpView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.pullUpView.topAnchor.constraint(equalTo: self.menuCollectionView.bottomAnchor, constant: 5).isActive = true
        self.pullUpView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3).isActive = true
        self.pullUpView.widthAnchor.constraint(equalTo: self.pullUpView.heightAnchor, multiplier: 2.5).isActive = true
        
    }
    
    func swipedMenu() {
        self.delegate?.animateMenu()
    }
    
}

extension TIPPullDownMenu: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.iconImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TIPPullDownCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.pullDownReuseId, for: indexPath) as! TIPPullDownCollectionViewCell
        cell.iconImage.image = self.iconImageArray[indexPath.item]
        cell.tag = indexPath.item
        return cell
    }
    
}

extension TIPPullDownMenu: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/2, height: collectionView.bounds.height/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}

extension TIPPullDownMenu: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TIPPullDownCollectionViewCell
    
//        var iconImageArray = [#imageLiteral(resourceName: "miniDrawIcon"), #imageLiteral(resourceName: "miniTypeIcon"), #imageLiteral(resourceName: "miniVideoIcon"), #imageLiteral(resourceName: "miniCameraIcon"), #imageLiteral(resourceName: "miniMessagingIcon"), #imageLiteral(resourceName: "miniFeedIcon"), #imageLiteral(resourceName: "miniProfileIcon"), #imageLiteral(resourceName: "miniSettingsIcon")]
        
        self.delegate?.dismissView()
        
        switch cell.tag {
        case 3:
            let cameraViewController: TIPCamViewController = TIPCamViewController()
            let cameraNavVC = UINavigationController(rootViewController: cameraViewController)
            self.delegate?.hideMenuBringUpNewView(view: cameraNavVC)
        case 4:
            //self.delegate?.hidePullDownMenuFast()
            AppDelegate.shared.tabBarController?.selectedIndex = 3
        case 5:
            //self.delegate?.hidePullDownMenuFast()
            AppDelegate.shared.tabBarController?.selectedIndex = 0
            AppDelegate.shared.tabBarController?.navigationController?.dismiss(animated: false, completion: {
                //
            })
        case 6:
            //self.delegate?.hidePullDownMenuFast()
            AppDelegate.shared.tabBarController?.selectedIndex = 4
        case 7:
            let settingsViewController: TIPSettingsViewController = TIPSettingsViewController()
            let settingsNavController: UINavigationController = UINavigationController(rootViewController: settingsViewController)
            self.delegate?.hideMenuBringUpNewView(view: settingsNavController)
        default:
            break
        }
        
//        if cell.iconImage.image == #imageLiteral(resourceName: "miniFeedIcon") {
//            
//            self.delegate?.hidePullDownMenuFast()
//            AppDelegate.shared.tabBarController?.selectedIndex = 0
//            
////        } else if cell.iconImage.image == {
////            
////            AppDelegate.shared.tabBarController?.selectedIndex = 1
//            
//            
//        } else if cell.iconImage.image == #imageLiteral(resourceName: "miniCameraIcon"){
//            
//            let cameraViewController: TIPCamViewController = TIPCamViewController()
//            
//            //print("SUPERVIEW", self.superview)
//            self.delegate?.hideMenuBringUpNewView(view: cameraViewController)
//            
//            
//        } else if cell.iconImage.image == #imageLiteral(resourceName: "miniMessagingIcon") {
//            
//            self.delegate?.hidePullDownMenuFast()
//            AppDelegate.shared.tabBarController?.selectedIndex = 3
//            
//            
//        } else if cell.iconImage.image == #imageLiteral(resourceName: "miniProfileIcon") {
//            
//            self.delegate?.hidePullDownMenuFast()
//            AppDelegate.shared.tabBarController?.selectedIndex = 4
//            
//            
//        } else if cell.iconImage.image == #imageLiteral(resourceName: "miniSettingsIcon") {
//            
//            let settingsViewController: TIPSettingsViewController = TIPSettingsViewController()
//            let settingsNavController: UINavigationController = UINavigationController(rootViewController: settingsViewController)
//            //self.present(settingsNavController, animated: true, completion: nil)
//            self.delegate?.hideMenuBringUpNewView(view: settingsNavController)
//            
//        }
        
    }
    
}


