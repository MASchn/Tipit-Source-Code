//
//  TIPViewControllerWIthPullDown.swift
//  Ironc.ly
//
//  Created by Alex Laptop on 9/4/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class TIPViewControllerWIthPullDown: UIViewController {
    
    var pullDownMenuBottom: NSLayoutConstraint?
    var navBarHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.pullDownView)
        
        navBarHeight = CGFloat(((self.navigationController?.navigationBar.frame.size.height)! * 1.2))
        
//        let navTap = UITapGestureRecognizer(target: self, action: #selector(self.pullDownPressed))
//        self.navigationController?.navigationBar.isUserInteractionEnabled = true
//        self.navigationController?.navigationBar.addGestureRecognizer(navTap)
        
        let pullUpPan = UIPanGestureRecognizer(target: self, action: #selector(self.panUpMenu))
        self.pullDownView.pullUpView.isUserInteractionEnabled = true
        self.pullDownView.pullUpView.addGestureRecognizer(pullUpPan)
        
        self.setUpMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.gestureRecognizers?.removeAll()
        
        let pullDownPan = UIPanGestureRecognizer(target: self, action: #selector(self.panDownMenu))
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.navigationController?.navigationBar.addGestureRecognizer(pullDownPan)
        
    }
    
    lazy var pullDownView: TIPPullDownMenu = {
        let menu: TIPPullDownMenu = TIPPullDownMenu()
        menu.translatesAutoresizingMaskIntoConstraints = false
        return menu
    }()
    
    func setUpMenu() {
        self.pullDownView.delegate = self
        
        self.pullDownView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6).isActive = true
        self.pullDownView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        self.pullDownView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pullDownMenuBottom = self.pullDownView.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant: navBarHeight)
        pullDownMenuBottom?.isActive = true
    }
    
    func addPullDownMenu() {
        
        self.view.bringSubview(toFront: self.pullDownView)
        
        //let pullDownMenuTap = UITapGestureRecognizer(target: self, action: #selector(self.pullDownPressed))
        //self.pullDownView.isUserInteractionEnabled = true
        //self.pullDownView.addGestureRecognizer(pullDownMenuTap)
    }
    
    func pullDownPressed() {
        
        if self.pullDownMenuBottom?.constant == navBarHeight {
            self.pullDownMenuBottom?.constant += (self.pullDownView.bounds.size.height - navBarHeight)
            
        } else {
            self.pullDownMenuBottom?.constant = navBarHeight
        }
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }) { (completed: Bool) in
            
        }
    }
    
    func panUpMenu(sender: UIPanGestureRecognizer) {
        
        if sender.state == .began || sender.state == .changed {
            let translation = sender.translation(in: self.view)
            
            if ((self.pullDownMenuBottom?.constant)! <= (self.pullDownView.bounds.size.height))
                && ((self.pullDownMenuBottom?.constant)! >= navBarHeight)  {
                
                self.pullDownMenuBottom?.constant += translation.y
            }
            
            sender.setTranslation(CGPoint.zero, in: self.view)
            
        } else if sender.state == .ended {
            
            if (self.pullDownMenuBottom?.constant)! < (self.pullDownView.bounds.size.height)/1.2 {
                
                self.pullDownMenuBottom?.constant = navBarHeight
                
                UIView.animate(withDuration: 0.5, animations: { [weak self] in
                    self?.view.layoutIfNeeded()
                })
                
            } else {
                self.pullDownMenuBottom?.constant = self.pullDownView.bounds.size.height
                
                UIView.animate(withDuration: 0.5, animations: { [weak self] in
                    self?.view.layoutIfNeeded()
                })
            }
            
        }
        
        
    }
    
    func panDownMenu(sender: UIPanGestureRecognizer) {
        
        if sender.state == .began || sender.state == .changed {
            let translation = sender.translation(in: self.view)
            
            if ((self.pullDownMenuBottom?.constant)! <= (self.pullDownView.bounds.size.height))
                && ((self.pullDownMenuBottom?.constant)! >= navBarHeight)  {
                
                self.pullDownMenuBottom?.constant += translation.y
            }
            
            sender.setTranslation(CGPoint.zero, in: self.view)
            
        } else if sender.state == .ended {
            
            if (self.pullDownMenuBottom?.constant)! < (self.pullDownView.bounds.size.height)/3 {
                
                self.pullDownMenuBottom?.constant = navBarHeight
                
                UIView.animate(withDuration: 0.5, animations: { [weak self] in
                    self?.view.layoutIfNeeded()
                })
                
            } else {
                self.pullDownMenuBottom?.constant = self.pullDownView.bounds.size.height
                
                UIView.animate(withDuration: 0.5, animations: { [weak self] in
                    self?.view.layoutIfNeeded()
                })
            }
            
        }
        
        
    }
    
    
}

extension TIPViewControllerWIthPullDown: pullDownMenuDelegate {
    
    func hideMenuBringUpNewView(view: UIViewController) {
        
        self.hidePullDownMenuFast()
        
        self.present(view, animated: true) { 
            //
        }
        
    }
    
    func hidePullDownMenuFast() {
        
        self.pullDownMenuBottom?.constant = navBarHeight
        self.view.layoutIfNeeded()
    }
    
    func animateMenu() {
        if self.pullDownMenuBottom?.constant == navBarHeight {
            self.pullDownMenuBottom?.constant += (self.pullDownView.bounds.size.height - navBarHeight)
        } else {
            self.pullDownMenuBottom?.constant = navBarHeight
        }
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }) { (completed: Bool) in
            
        }
    }
    
}
