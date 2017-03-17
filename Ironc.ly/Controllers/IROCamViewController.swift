//
//  IROCamViewController.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 2/15/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import UIKit
import AVFoundation

class IROCamViewController: SwiftyCamViewController {
    
    var captureButton: SwiftyRecordButton!
    var videoTimer: Timer?
    var videoTimerSeconds: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cameraDelegate = self
        self.maximumVideoDuration = 11.0
        
        self.captureButton = SwiftyRecordButton(frame: CGRect(x: view.frame.midX - 30.0, y: view.frame.height - 100.0, width: 60.0, height: 60.0))
        self.captureButton.delegate = self
        
        self.view.addSubview(self.captureButton)
        self.view.addSubview(self.cancelButton)
        self.view.addSubview(self.switchCameraButton)
        self.view.addSubview(self.flashButton)
        self.view.addSubview(self.timerLabel)
        
        self.setUpConstraints()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Lazy Initialization
    lazy var timerLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 22.0)
        label.textAlignment = .center
        label.text = "00:00"
        label.alpha = 0.0 // Unhide when video starts recording
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        let buttonSize: CGFloat = 44.0
        
        self.cancelButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30.0).isActive = true
        self.cancelButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10.0).isActive = true
        self.cancelButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        self.cancelButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true

        self.switchCameraButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30.0).isActive = true
        self.switchCameraButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        self.switchCameraButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        self.switchCameraButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.flashButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30.0).isActive = true
        self.flashButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10.0).isActive = true
        self.flashButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        self.flashButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        
        self.timerLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30.0).isActive = true
        self.timerLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.timerLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.timerLabel.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
    // MARK: - Actions
    @objc private func tappedSwitchCameraButton() {
        self.switchCamera()
    }
    
    func tappedCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tappedFlashButton() {
        if let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo), device.hasTorch {
            do {
                try device.lockForConfiguration()
                let torchOn = !device.isTorchActive
                try device.setTorchModeOnWithLevel(1.0)
                device.torchMode = torchOn ? .on : .off
                device.unlockForConfiguration()
            } catch {
                print("Error occured while toggling flash")
            }
        }
    }
    
    func incrementVideoTimerSeconds() {
        self.videoTimerSeconds += 1
        self.timerLabel.text = String(format: "00:%02d", self.videoTimerSeconds)
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
        
        // Start incrementing video timer
        self.videoTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.incrementVideoTimerSeconds), userInfo: nil, repeats: true)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.cancelButton.alpha = 0.0
            self.flashButton.alpha = 0.0
            self.switchCameraButton.alpha = 0.0
            self.timerLabel.alpha = 1.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did finish Recording")
        captureButton.shrinkButton()
        
        self.videoTimer?.invalidate()
        self.videoTimer = nil
        self.videoTimerSeconds = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.cancelButton.alpha = 1.0
            self.flashButton.alpha = 1.0
            self.switchCameraButton.alpha = 1.0
            self.timerLabel.alpha = 0.0
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
