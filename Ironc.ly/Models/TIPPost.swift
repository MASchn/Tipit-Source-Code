//
//  TIPPost.swift
//  Ironc.ly
//

import Foundation
import UIKit

struct TIPPost {
    
    var contentId: String
    var username: String?
    var contentURL: String?
    var contentImage: UIImage?
    var index: Int? // The index of a post in a story
    var type: TIPContentType = .photo
    var isPrivate: Bool
    var timeRemaining: String
    
    init(contentId: String, username: String?, contentURL: String?, contentImage: UIImage?, index: Int?, isPrivate: Bool, timeRemaining: String) {
        
        self.contentId = contentId
        self.username = username
        self.contentURL = contentURL
        self.contentImage = contentImage
        self.index = index
        self.isPrivate = isPrivate
        self.timeRemaining = timeRemaining
    }
    
}
