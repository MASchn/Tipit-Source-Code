//
//  UIViewController+Alert.swift
//  Ironc.ly
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
            let imagePicker: UIImagePickerController = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        let photoRollAction: UIAlertAction = UIAlertAction(title: "Choose from mobile", style: .default) { (action) in
            let imagePicker: UIImagePickerController = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //
        }
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoRollAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // Needs override
    func imagePickerSelectedImage(image: UIImage) {}
    
}

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerSelectedImage(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
