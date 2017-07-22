//
//  TIPParser.swift
//  Ironc.ly
//

import UIKit
import Alamofire

class TIPParser: NSObject {
    
    class func parseSearchUsers(response: DataResponse<Any>, completionHandler: ([TIPSearchUser]?, Error?) -> Void) {
        switch response.result {
        case.success(let JSONDictionary):
            if let JSONArray: [[String : Any]] = JSONDictionary as? [[String : Any]] {
                var searchUsers: [TIPSearchUser] = [TIPSearchUser]()
                for JSON: [String : Any] in JSONArray {
                    if let searchItem: TIPSearchUser = TIPSearchUser(JSON: JSON) {
                        searchUsers.append(searchItem)
                    }
                }
                completionHandler(searchUsers, nil)
            }
            completionHandler(nil, nil)
        case .failure(let error):
            completionHandler(nil, error)
        }
    }
    
    class func parseMediaItems(response: DataResponse<Any>, completionHandler: ([TIPMediaItem]?, Error?) -> Void) {
        switch response.result {
        case.success(let JSONDictionary):
            if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                var mediaItems: [TIPMediaItem] = []
                if let mediaItemsJSON: [[String : Any]] = JSON["mediaItems"] as? [[String : Any]] {
                    for mediaItemJSON: [String : Any] in mediaItemsJSON {
                        if let mediaItem: TIPMediaItem = TIPMediaItem(JSON: mediaItemJSON) {
                            mediaItems.append(mediaItem)
                        }
                    }
                    completionHandler(mediaItems, nil)
                }
            }
            completionHandler(nil, nil)
        case.failure(let error):
            completionHandler(nil, error)
        }
    }
    

}
