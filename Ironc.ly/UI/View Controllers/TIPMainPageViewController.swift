//
//  TIPMainPageViewController.swift
//  Ironc.ly
//
//  Created by Alex Laptop on 9/1/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class TIPMainPageViewController: UIViewController {
    
    let iconImageArray = [#imageLiteral(resourceName: "feed_icon"), #imageLiteral(resourceName: "search_icon"), #imageLiteral(resourceName: "camera_icon"), #imageLiteral(resourceName: "messaging_icon"), #imageLiteral(resourceName: "profile_icon")]
    var iconSelection = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.cutOutImageView)
        self.cutOutImageView.addSubview(self.iconImageView)
        self.view.addSubview(self.switchImageView)
        self.view.addSubview(self.swipeImageView)
        
        self.cutOutImageView.isUserInteractionEnabled = true
        let tapIcon = UITapGestureRecognizer(target: self, action: #selector(self.tappedIcon))
        self.cutOutImageView.addGestureRecognizer(tapIcon)
        
        self.switchImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.switchTapped))
        self.switchImageView.addGestureRecognizer(tap)
        
        self.swipeImageView.isUserInteractionEnabled = true
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedLeft))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedRight))
        swipeRight.direction = .right
        self.swipeImageView.addGestureRecognizer(swipeLeft)
        self.swipeImageView.addGestureRecognizer(swipeRight)
        
        self.setUpConstraints()
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
    
    func setUpConstraints() {
        
        self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.backgroundImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.cutOutImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.cutOutImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -self.view.frame.size.height/4).isActive = true
        self.cutOutImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.35).isActive = true
        self.cutOutImageView.widthAnchor.constraint(equalTo: self.cutOutImageView.heightAnchor).isActive = true
        
        self.iconImageView.centerXAnchor.constraint(equalTo: self.cutOutImageView.centerXAnchor).isActive = true
        self.iconImageView.centerYAnchor.constraint(equalTo: self.cutOutImageView.centerYAnchor).isActive = true
        self.iconImageView.heightAnchor.constraint(equalTo: self.cutOutImageView.heightAnchor, multiplier: 0.4).isActive = true
        self.iconImageView.widthAnchor.constraint(equalTo: self.iconImageView.heightAnchor).isActive = true
        
        self.switchImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 4).isActive = true
        self.switchImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.size.height/12).isActive = true
        self.switchImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4).isActive = true
        self.switchImageView.widthAnchor.constraint(equalTo: self.switchImageView.heightAnchor, multiplier: 1).isActive = true
        
        self.swipeImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.swipeImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.swipeImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.swipeImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25).isActive = true
    }
    
    func tappedIcon(sender: UITapGestureRecognizer) {
        AppDelegate.shared.tabBarController?.selectedIndex = self.iconSelection
        
        self.navigationController?.dismiss(animated: true, completion: { 
            //
        })
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
        
        self.iconImageView.image = self.iconImageArray[self.iconSelection]
        
    }
    
    func swipedRight(sender: UISwipeGestureRecognizer) {
        
        if self.iconSelection == 0 {
            self.iconSelection = 4
        } else {
            self.iconSelection -= 1
        }
        
        self.iconImageView.image = self.iconImageArray[self.iconSelection]
        
    }
    
}
