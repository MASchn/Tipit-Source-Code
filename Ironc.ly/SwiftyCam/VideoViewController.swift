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
import AVFoundation
import AVKit

class VideoViewController: TIPPreviewViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var videoURL: URL
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentType = .video
        
        self.view.backgroundColor = UIColor.gray
        player = AVPlayer(url: videoURL)
        playerController = AVPlayerViewController()
        
        guard player != nil && playerController != nil else {
            return
        }
        playerController!.showsPlaybackControls = false
        
        playerController!.player = player!
        self.addChildViewController(playerController!)
        self.view.addSubview(playerController!.view)
        playerController!.view.frame = view.frame
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
        
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 44.0, height: 44.0))
        let image: UIImage = #imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysTemplate)
        cancelButton.setImage(image, for: UIControlState())
        cancelButton.tintColor = UIColor.white
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        self.view.bringSubview(toFront: self.publicButton)
        self.view.bringSubview(toFront: self.privateButton)
        self.view.bringSubview(toFront: self.sendToFriendButton)
        
        self.sendToFriendButton.addTarget(self, action: #selector(self.share), for: .touchUpInside)
        
        self.publicButton.addTarget(self, action: #selector(self.tappedPublicButton), for: .touchUpInside)
        self.privateButton.addTarget(self, action: #selector(self.tappedPrivateButton), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: kCMTimeZero)
            self.player!.play()
        }
    }
    
    func share() {
        let shareText: String = "Sent with PremiumSnap"
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [self.videoURL, shareText], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    func tappedPublicButton(sender: UIButton) {
        self.postContent(isPrivate: false)
        self.player?.pause()
    }
    
    func tappedPrivateButton(sender: UIButton) {        
        self.postContent(isPrivate: true)
        self.player?.pause()
    }
    
    func compressVideo(inputURL: URL, outputURL: URL,  handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileTypeMPEG4 //AVFileTypeQuickTimeMovie (m4v)
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
    
    func postContent(isPrivate: Bool) {
        guard let user: TIPUser = TIPUser.currentUser else { return }
        
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".mp4")
        
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
            
            self.compressVideo(inputURL: self.videoURL, outputURL: compressedURL, handler:  { (_ exportSession: AVAssetExportSession?) -> Void in
                
                if exportSession!.status == .completed {
                    
                    do {
                        let data: Data = try Data(contentsOf: exportSession!.outputURL!)
                        TIPAPIClient.postContent(
                            user: user,
                            content: data,
                            type: .video,
                            isPrivate: isPrivate,
                            completionHandler: {
                                (success: Bool) in
                                
                                //                                DispatchQueue.main.async {
                                //                                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
                                //                                        //
                                //                                    })
                                //                                }
                        })
                    } catch let error {
                        print(error)
                    }
                    
                }
                
            })
            
        })
        
    }
}


