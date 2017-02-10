//
//  IROPreviewView.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 2/10/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import AVFoundation
import Photos

// Apple Sample Code: https://developer.apple.com/library/content/samplecode/AVCam/Introduction/Intro.html

class IROPreviewView: UIView {
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.videoPreviewLayer.frame = self.bounds
    }
    
    // MARK: UIView
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
