//
//  TIPParser.swift
//  Ironc.ly
//

import UIKit
import Alamofire

class TIPParser: NSObject {
    
    class func handleResponse<T>(response: DataResponse<Any>) -> (T?, Error?) {
        switch response.result {
        case.success(let JSONDictionary):

            // Parsing waterfall
            if T.self == [TIPSearchUser].self {
                let value: T? = self.parseSearchUsers(result: JSONDictionary) as? T
                return (value, nil)
            } else if T.self == [TIPMediaItem].self {
                let value: T? = self.parseMediaItems(result: JSONDictionary) as? T
                return (value, nil)
            } else {
                return (nil, nil)
            }
        case .failure(let error):
            return (nil, error)
        }
    }

    class func parseSearchUsers(result: Any) -> [TIPSearchUser]? {
        if let JSONArray: [[String : Any]] = result as? [[String : Any]] {
            var searchUsers: [TIPSearchUser] = [TIPSearchUser]()
            for JSON: [String : Any] in JSONArray {
                if let searchItem: TIPSearchUser = TIPSearchUser(JSON: JSON) {
                    searchUsers.append(searchItem)
                }
            }
            return searchUsers
        }
        return nil
    }
    
    class func parseMediaItems(result: Any) -> [TIPMediaItem]? {
        if let JSON: [String : Any] = result as? [String : Any] {
            var mediaItems: [TIPMediaItem] = []
            if let mediaItemsJSON: [[String : Any]] = JSON["mediaItems"] as? [[String : Any]] {
                for mediaItemJSON: [String : Any] in mediaItemsJSON {
                    if let mediaItem: TIPMediaItem = TIPMediaItem(JSON: mediaItemJSON) {
                        mediaItems.append(mediaItem)
                    }
                }
                return mediaItems
            }
        }
        return nil
    }
    

}
