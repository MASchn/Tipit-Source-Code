//
//  TIPMediaItem.swift
//  Ironc.ly
//

import Foundation

struct TIPMediaItem {
    enum TIPMediaItemType {
        case photo
        case video
    }
    
    let contentId: String
    let url: String
    let type: TIPMediaItemType
    let isPrivate: Bool
    let username: String
    let timeRemaining: String
    
    init?(JSON: [String : Any]) {
        guard let url: String = JSON["url"] as? String else { return nil }
        guard let contentId: String = JSON["_id"] as? String else { return nil }
        guard let dateString: String = JSON["created_at"] as? String else { return nil }
        
        self.timeRemaining = Date.fromString(dateString: dateString).formattedTimeRemaining()
        
        self.url = url
        self.contentId = contentId
        self.username = ""
        
        if let isPrivate: Bool = JSON["private"] as? Bool {
            self.isPrivate = isPrivate
        } else {
            self.isPrivate = false
        }
        
        // Hacky way of doing this for now
        if String(url.characters.suffix(3)) == "mp4" {
            self.type = .video
        } else {
            self.type = .photo
        }
        
    }
    
}
