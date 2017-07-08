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
    var expiration: Date
    
    init(contentId: String, username: String?, contentURL: String?, contentImage: UIImage?, index: Int?, isPrivate: Bool) {
        
        self.contentId = contentId
        self.username = username
        self.contentURL = contentURL
        self.contentImage = contentImage
        self.index = index
        self.isPrivate = isPrivate
        let now: Date = Date()
        let tomorrow: Date = Calendar.current.date(byAdding: .hour, value: 10, to: now)!
        self.expiration = tomorrow
    }
    
    func timeRemaining() -> DateComponents {
        let now: Date = Date()
        return Calendar.current.dateComponents([.day, .hour], from: now, to: self.expiration)
    }
    
    func formattedTimeRemaining() -> String {
        let timeRemaining: DateComponents = self.timeRemaining()
        if timeRemaining.day! > 0 {
            return "\(timeRemaining.day!)d left"
        } else {
            return "\(timeRemaining.hour!)h left"
        }
    }
    
}
