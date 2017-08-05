//
//  TIPParser.swift
//  Ironc.ly
//

import UIKit
import Alamofire

class TIPParser: NSObject {
    
    class func parseAllUsers(response: DataResponse<Any>, completionHandler: ([[String: String]]?, Error?) -> Void) {
        switch response.result {
        case.success(let JSONDictionary):
            if let JSONArray: [[String : Any]] = JSONDictionary as? [[String : Any]] {
                //print("ALL USERS: \(JSONArray)")
                var allUsers: [[String: String]] = [[String: String]]()
                
                for JSON: [String : Any] in JSONArray {
                    print("SINGLE USER: \(JSON)")
                    
                    
                    
                    
                    
//                    print("ID: \(id)")
//                    print("USERNAME: \(userName)")
//                    print("profileURL: \(profileURL)")
                    
                    var singleUser: [String: String] = [String: String]()
                    
                    if let id = JSON["id"] as? String {
                        singleUser.updateValue(id, forKey: "id")
                    }
                    if let userName = JSON["username"] as? String {
                        singleUser.updateValue(userName, forKey: "username")
                    }
                    if let profileURL = JSON["profile_image"] as? String {
                        singleUser.updateValue(profileURL, forKey: "profile_image")
                    }
                    
                
                    allUsers.append(singleUser)
                }
                completionHandler(allUsers, nil)
            }
            completionHandler(nil, nil)
        case .failure(let error):
            completionHandler(nil, error)
        }
    }
    
    class func parseSearchUsers(response: DataResponse<Any>, completionHandler: ([TIPSearchUser]?, Error?) -> Void) {
        switch response.result {
        case.success(let JSONDictionary):
            if let JSONArray: [[String : Any]] = JSONDictionary as? [[String : Any]] {
                var searchUsers: [TIPSearchUser] = [TIPSearchUser]()
                for JSON: [String : Any] in JSONArray {
                    print("PLEASEEEEEEEEE GODDDDDDDDDDDD: \(JSON)")
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
                print("MEDIAAAAAAAAA ITEMMMMMMMMMMM: \(JSON)")
                
                var mediaItems: [TIPMediaItem] = []
                if let mediaItemsJSON: [[String : Any]] = JSON["mediaItems"] as? [[String : Any]] {
                    for mediaItemJSON: [String : Any] in mediaItemsJSON {
                        print("MEDIA ITEM JSON: \(mediaItemJSON)")
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
