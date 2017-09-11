//
//  TIPCamViewController.swift
//  Ironc.ly
//

import UIKit
import AVFoundation

class TIPCamViewController: SwiftyCamViewController {
    
    //var captureButton: SwiftyRecordButton!
    var videoTimer: Timer?
    var videoTimerSeconds: Int = 0
    //var navBarHeight: CGFloat = 0
    var pullDownMenuBottom: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cameraDelegate = self
        self.maximumVideoDuration = 11.0
        self.videoQuality = .resolution1280x720
        //self.videoQuality = .resolution352x288
        
        //self.captureButton = SwiftyRecordButton(frame: CGRect(x: view.frame.midX - 30.0, y: view.frame.height - 100.0, width: 60.0, height: 60.0))
        //self.captureButton.delegate = self
        //self.view.addSubview(self.backgroundImageView)
        //self.view.bringSubview(toFront: self.prev)
        self.view.addSubview(self.bottomImageView)
        self.view.addSubview(self.captureButton)
        //self.view.addSubview(self.cancelButton)
        self.view.addSubview(self.switchCameraButton)
        self.view.addSubview(self.flashButton)
        self.view.addSubview(self.timerLabel)
        self.view.addSubview(self.photoLibraryButton)
        self.view.bringSubview(toFront: self.cancelButton)
        self.view.addSubview(self.pullDownView)
        
        //navBarHeight = CGFloat(((self.navigationController?.navigationBar.frame.size.height)! * 1.2))
        
        //        let navTap = UITapGestureRecognizer(target: self, action: #selector(self.pullDownPressed))
        //        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        //        self.navigationController?.navigationBar.addGestureRecognizer(navTap)
        
        self.view.addSubview(self.pullDownView)
        let pullUpPan = UIPanGestureRecognizer(target: self, action: #selector(self.panUpMenu))
        self.pullDownView.pullUpView.isUserInteractionEnabled = true
        self.pullDownView.pullUpView.addGestureRecognizer(pullUpPan)
        
        

        //self.setUpCameraConstraints()
        self.setUpConstraints()
        self.configureTIPNavBar()
        self.setUpMenu()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "rsz_backtomenuedited"), style: .plain, target: self, action: #selector(self.dismissCamera))
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "rsz_backtomenuedited"), style: .plain, target: self, action: #selector(self.backButtonPressed))
        
        self.backgroundImageView.image = TIPLoginViewController.backgroundPicArray[TIPUser.currentUser?.backgroundPicSelection ?? 0]
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.bringSubview(toFront: self.pullDownView)
        
        self.navigationController?.navigationBar.gestureRecognizers?.removeAll()
        
        let pullDownPan = UIPanGestureRecognizer(target: self, action: #selector(self.panDownMenu))
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.navigationController?.navigationBar.addGestureRecognizer(pullDownPan)
        
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "transparentNavBar").resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch), for: .default)
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    // MARK: - Lazy Initialization
    
    lazy var pullDownView: TIPPullDownMenu = {
        let menu: TIPPullDownMenu = TIPPullDownMenu()
        menu.isHidden = true
        menu.translatesAutoresizingMaskIntoConstraints = false
        return menu
    }()
    
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
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(self.tappedCancelButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var switchCameraButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(#imageLiteral(resourceName: "newSwitchCamera"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "newSwitchCameraPressed"), for: .highlighted)
        //button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(self.tappedSwitchCameraButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var flashButton: UIButton = {
        let button: UIButton = UIButton()
        
        button.setImage(#imageLiteral(resourceName: "newFlashButton"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "newFlashButtonPressed"), for: .highlighted)
        //button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(self.tappedFlashButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var photoLibraryButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(#imageLiteral(resourceName: "photoLibraryButton"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "photoLibraryPressed"), for: .highlighted)
        //button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(self.tappedLibraryButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var captureButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(#imageLiteral(resourceName: "arcadeButton"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "arcadeButtonPressed"), for: .highlighted)
        //button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(self.takePicturePressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var bottomImageView: UIImageView = {
        let view: UIImageView = UIImageView()
        view.image = UIImage()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Autolayout
    func setUpConstraints() {
        let buttonSize: CGFloat = 44.0
        
//        self.cancelButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40).isActive = true
//        self.cancelButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive = true
//        self.cancelButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
//        self.cancelButton.heightAnchor.constraint(equalTo: self.cancelButton.widthAnchor).isActive = true

        self.bottomImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.bottomImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.bottomImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.bottomImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3).isActive = true
        
        self.switchCameraButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.switchCameraButton.topAnchor.constraint(equalTo: self.bottomImageView.topAnchor, constant: 20).isActive = true
        self.switchCameraButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.08).isActive = true
        self.switchCameraButton.widthAnchor.constraint(equalTo: self.switchCameraButton.heightAnchor, multiplier: 1.4).isActive = true
        
        self.flashButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.flashButton.topAnchor.constraint(equalTo: self.bottomImageView.topAnchor, constant: 10).isActive = true
        self.flashButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        self.flashButton.heightAnchor.constraint(equalTo: self.flashButton.widthAnchor, multiplier: 1.3).isActive = true
        
        self.timerLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30.0).isActive = true
        self.timerLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.timerLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.timerLabel.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        self.photoLibraryButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        self.photoLibraryButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20.0).isActive = true
        self.photoLibraryButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        self.photoLibraryButton.widthAnchor.constraint(equalTo: self.photoLibraryButton.heightAnchor, multiplier: 1.4).isActive = true
        
        self.captureButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.view.frame.size.height/2.7).isActive = true
        self.captureButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.captureButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3).isActive = true
        self.captureButton.heightAnchor.constraint(equalTo: self.captureButton.widthAnchor, multiplier: 1).isActive = true
    }
    
    override func setUpCameraConstraints() {
        
        self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.backgroundImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
//        self.cameraSessionView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        self.cameraSessionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        //self.cameraSessionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -30).isActive = true
//        self.cameraSessionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
//        self.cameraSessionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.75).isActive = true
        
        self.view.layoutIfNeeded()
    }
    
    func dismissCamera() {
        self.navigationController?.dismiss(animated: false, completion: {
            //
        })
    }
    
    func setUpMenu() {
        self.pullDownView.delegate = self
        
        self.pullDownView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6).isActive = true
        self.pullDownView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        self.pullDownView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pullDownMenuBottom = self.pullDownView.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant: navBarHeight)
        pullDownMenuBottom?.isActive = true
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
    
    // MARK: - Actions
    
    func backButtonPressed() {
        self.navigationController?.dismiss(animated: true, completion: { 
            //
        })
    }
    
    func takePicturePressed() {
        self.takePhoto()
    }
    
    @objc private func tappedSwitchCameraButton() {
        self.switchCamera()
    }
    
    func tappedCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tappedFlashButton() {
        self.flashEnabled = !self.flashEnabled
        
        if flashEnabled == true {
            self.flashButton.setImage(#imageLiteral(resourceName: "newFlashButtonPressed"), for: .normal)
            self.flashButton.setImage(#imageLiteral(resourceName: "newFlashButton"), for: .highlighted)
        } else {
            self.flashButton.setImage(#imageLiteral(resourceName: "newFlashButton"), for: .normal)
            self.flashButton.setImage(#imageLiteral(resourceName: "newFlashButtonPressed"), for: .highlighted)
        }
    }
    
    func incrementVideoTimerSeconds() {
        self.videoTimerSeconds += 1
        self.timerLabel.text = String(format: "00:%02d", self.videoTimerSeconds)
    }
    
    func tappedLibraryButton() {
        let imagePicker: UIImagePickerController = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    override func imagePickerSelectedImage(image: UIImage) {
        let currentVC = self.presentedViewController
        let newVC = PhotoViewController(image: image)
        self.navigationController?.pushViewController(newVC, animated: false)
    }

}

extension TIPCamViewController: SwiftyCamViewControllerDelegate {
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        let newVC = PhotoViewController(image: photo)
        //let navController = UINavigationController(rootViewController: newVC)
        //self.present(navController, animated: true, completion: nil)
        self.navigationController?.pushViewController(newVC, animated: false)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did Begin Recording")
        //captureButton.growButton()
        
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
        //captureButton.shrinkButton()
        
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

extension TIPCamViewController: pullDownMenuDelegate {
    
    func dismissView() {
        
        let mainVC = self.presentingViewController
        
        self.navigationController?.dismiss(animated: false, completion: {
            mainVC?.dismiss(animated: false, completion: {
                //
            })
        })
    }
    
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
