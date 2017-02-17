//
//  IROCamViewController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 2/15/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit

class IROCamViewController: SwiftyCamViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cameraDelegate = self
        self.maximumVideoDuration = 10.0
        
        self.view.addSubview(self.captureButton)
        self.view.addSubview(self.cancelButton)
        self.view.addSubview(self.switchCameraButton)
        self.view.addSubview(self.flashButton)
        
        self.setUpConstraints()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Lazy Initialization
    lazy var captureButton: SwiftyRecordButton = {
        let button: SwiftyRecordButton = SwiftyRecordButton()
        button.delegate = self
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button: UIButton = UIButton()
        let image: UIImage = #imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(self.tappedCancelButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var switchCameraButton: UIButton = {
        let button: UIButton = UIButton()
        let image: UIImage = #imageLiteral(resourceName: "switch").withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(self.tappedSwitchCameraButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var flashButton: UIButton = {
        let button: UIButton = UIButton()
        let image: UIImage = #imageLiteral(resourceName: "flash").withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(self.tappedFlashButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        self.captureButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60.0).isActive = true
        self.captureButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.captureButton.heightAnchor.constraint(equalToConstant: 55.0).isActive = true
        self.captureButton.widthAnchor.constraint(equalToConstant: 55.0).isActive = true
        
        self.cancelButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30.0).isActive = true
        self.cancelButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10.0).isActive = true
        self.cancelButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        self.cancelButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true

        self.switchCameraButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30.0).isActive = true
        self.switchCameraButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        self.switchCameraButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        self.switchCameraButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.flashButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30.0).isActive = true
        self.flashButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10.0).isActive = true
        self.flashButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        self.flashButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
    }
    
    // MARK: - Actions
    @objc private func tappedSwitchCameraButton() {
        self.switchCamera()
    }
    
    func tappedCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tappedFlashButton() {
        self.flashEnabled = !self.flashEnabled
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
            self.switchCameraButton.alpha = 0.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did finish Recording")
        captureButton.shrinkButton()
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 1.0
            self.switchCameraButton.alpha = 1.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        let newVC = VideoViewController(videoURL: url)
        self.present(newVC, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {}
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {}
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {}
    
}
