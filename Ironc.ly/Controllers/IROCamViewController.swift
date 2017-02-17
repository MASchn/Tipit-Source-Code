//
//  IROCamViewController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 2/15/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROCamViewController: SwiftyCamViewController {

    var flipCameraButton: UIButton!
    var flashButton: UIButton!
    var captureButton: SwiftyRecordButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraDelegate = self
        maximumVideoDuration = 10.0
        addButtons()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func addButtons() {
        captureButton = SwiftyRecordButton(frame: CGRect(x: view.frame.midX - 37.5, y: view.frame.height - 100.0, width: 75.0, height: 75.0))
        self.view.addSubview(captureButton)
        captureButton.delegate = self
        
        flipCameraButton = UIButton(frame: CGRect(x: (((view.frame.width / 2 - 37.5) / 2) - 15.0), y: view.frame.height - 74.0, width: 30.0, height: 23.0))
        flipCameraButton.setImage(#imageLiteral(resourceName: "switch"), for: UIControlState())
        flipCameraButton.addTarget(self, action: #selector(cameraSwitchAction(_:)), for: .touchUpInside)
        self.view.addSubview(flipCameraButton)
        
        let test = CGFloat((view.frame.width - (view.frame.width / 2 + 37.5)) + ((view.frame.width / 2) - 37.5) - 9.0)
        
        flashButton = UIButton(frame: CGRect(x: test, y: view.frame.height - 77.5, width: 18.0, height: 30.0))
        flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControlState())
        flashButton.addTarget(self, action: #selector(toggleFlashAction(_:)), for: .touchUpInside)
        self.view.addSubview(flashButton)
    }
    
    @objc private func cameraSwitchAction(_ sender: Any) {
        switchCamera()
    }
    
    @objc private func toggleFlashAction(_ sender: Any) {
        flashEnabled = !flashEnabled
        
        if flashEnabled == true {
            flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControlState())
        } else {
            flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControlState())
        }
    }
    
    // MARK: - Autolayout
    func setUpConstraints() {
//        self.photoButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60.0).isActive = true
//        self.photoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        self.photoButton.heightAnchor.constraint(equalToConstant: 55.0).isActive = true
//        self.photoButton.widthAnchor.constraint(equalToConstant: 55.0).isActive = true
//        
//        self.cancelButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30.0).isActive = true
//        self.cancelButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10.0).isActive = true
//        self.cancelButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
//        self.cancelButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
//        
//        self.switchButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30.0).isActive = true
//        self.switchButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
//        self.switchButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
//        self.switchButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.flashButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30.0).isActive = true
        self.flashButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10.0).isActive = true
        self.flashButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        self.flashButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
    }

}

extension IROCamViewController: SwiftyCamViewControllerDelegate {
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        let newVC = PhotoViewController(image: photo)
        self.present(newVC, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did Begin Recording")
        captureButton.growButton()
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 0.0
            self.flipCameraButton.alpha = 0.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did finish Recording")
        captureButton.shrinkButton()
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 1.0
            self.flipCameraButton.alpha = 1.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        let newVC = VideoViewController(videoURL: url)
        self.present(newVC, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }, completion: { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }, completion: { (success) in
                focusView.removeFromSuperview()
            })
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        print(zoom)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        print(camera)
    }
    
}
