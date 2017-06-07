//
//  IROAnimationViewController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 6/6/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit
import Lottie

class IROAnimationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let animationView: LOTAnimationView = LOTAnimationView(name: "smile")
        animationView.contentMode = .scaleAspectFit
        self.view.addSubview(animationView)
        animationView.frame = self.view.bounds
        
        sleep(2)
        animationView.play(completion: { finished in
            //
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
