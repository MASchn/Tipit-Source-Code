//
//  IROTestViewController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 5/27/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

        self.view.addSubview(self.tipView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tipView.frame = self.view.bounds
    }
    
    lazy var tipView: IROTipView = IROTipView()
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
