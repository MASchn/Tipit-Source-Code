//
//  UIViewController+Alert.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 4/11/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String?, message: String?, completion: (() -> Void)?) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completion?()
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showPhotoActionSheet() {
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction: UIAlertAction = UIAlertAction(title: "Take picture", style: .default) { (action) in
            //
        }
        let photoRollAction: UIAlertAction = UIAlertAction(title: "Choose from mobile", style: .default) { (action) in
            //
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //
        }
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoRollAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}
