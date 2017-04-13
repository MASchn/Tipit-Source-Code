/*Copyright (c) 2016, Andrew Walz.
 
 Redistribution and use in source and binary forms, with or without modification,are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
 BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */

import UIKit
import Alamofire

class PhotoViewController: IROPreviewViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var backgroundImage: UIImage
    
    init(image: UIImage) {
        self.backgroundImage = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // let headers: HTTPHeaders = [
        //    "x-auth" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1OGNiNGEzMmFjZjA5MTAwMTFiYTUyYzciLCJhY2Nlc3MiOiJhdXRoIiwiaWF0IjoxNDg5NzE3ODEwfQ.ITrZ3K26S6fRiSWw82lIp67uM8BoIC_DGzHnzUDhGz8",
        //    "content-type" : "application/json"
        // ]
        // Alamofire.request("https://powerful-reef-30384.herokuapp.com/users/me/media_items", headers: headers).responseJSON { (response) in
        //    if let json = response.result.value {
        //        print(json)
        //    }
        // }
        
        self.view.backgroundColor = UIColor.gray
        let backgroundImageView = UIImageView(frame: view.frame)
        backgroundImageView.image = backgroundImage
        view.addSubview(backgroundImageView)
        
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 44.0, height: 44.0))
        let image: UIImage = #imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysTemplate)
        cancelButton.setImage(image, for: UIControlState())
        cancelButton.tintColor = UIColor.white
        cancelButton.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        self.view.bringSubview(toFront: self.publicButton)
        self.view.bringSubview(toFront: self.privateButton)
        self.view.bringSubview(toFront: self.sendToFriendButton)
        
        self.sendToFriendButton.addTarget(self, action: #selector(self.share), for: .touchUpInside)
        
        self.publicButton.addTarget(self, action: #selector(self.tappedPublicButton), for: .touchUpInside)
        self.privateButton.addTarget(self, action: #selector(self.tappedPrivateButton), for: .touchUpInside)
    }
    
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func share() {
        let shareText: String = "Sent with PremiumSnap"
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [self.backgroundImage, shareText], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    func tappedPublicButton(sender: UIButton) {
        if let user: IROUser = IROUser.currentUser {
            if let data: Data = UIImageJPEGRepresentation(self.backgroundImage, 0.5) {
                IROAPIClient.post(
                    user: user,
                    content: data,
                    type: .image,
                    private: false,
                    completionHandler: {
                        (success: Bool) in
                        if success == true {
                            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                        }
                })
            }
        }
    }
    
    func tappedPrivateButton(sender: UIButton) {
        self.tappedPublicButton(sender: sender)
    }
}
