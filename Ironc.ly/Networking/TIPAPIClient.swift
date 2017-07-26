//
//  TIPAPIClient.swift
//  Ironc.ly
//

import Foundation
import Alamofire

let baseURL: String = "https://powerful-reef-30384.herokuapp.com"

enum TIPUserImageType: String  {
    case profile = "profile_image"
    case background = "background_image"
}

enum TIPUserAction: String {
    case follow = "/follow"
    case unfollow = "/unfollow"
    case subscribe = "/subscribe"
    case unsubscribe = "/unsubscribe"
}

class TIPAPIClient: NSObject {
    
    class var authHeaders: HTTPHeaders {
        guard let user: TIPUser = TIPUser.currentUser else { return HTTPHeaders() }
        return [
            "x-auth" : user.token,
            "Content-Type" : "application/json"
        ]
    }
    
    class func getStory(userId: String, completionHandler: @escaping (TIPStory?) -> Void) {
        Alamofire.request(
            baseURL + "/story?id=\(userId)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: self.authHeaders
        )
            .debugLog()
            .responseJSON
        { (response) in
            TIPParser.parseMediaItems(response: response, completionHandler: { (mediaItems: [TIPMediaItem]?, error: Error?) in
                if let mediaItems: [TIPMediaItem] = mediaItems {
                    TIPStory.story(mediaItems: mediaItems, isSubcribed: false, completion: { (story: TIPStory?) in
                        completionHandler(story)
                    })
                }
            })
        }
    }
    
    class func getPersonalStory(completionHandler: @escaping (TIPStory?) -> Void) {
        Alamofire.request(baseURL + "/users/me/media_items", headers: self.authHeaders)
            .debugLog()
            .responseJSON
        { (response) in
            TIPParser.parseMediaItems(response: response, completionHandler: { (mediaItems: [TIPMediaItem]?, error: Error?) in
                if let mediaItems: [TIPMediaItem] = mediaItems {
                    TIPStory.story(mediaItems: mediaItems, isSubcribed: false, completion: { (story: TIPStory?) in
                        completionHandler(story)
                    })
                }
            })
        }
    }
    
    class func registerNewUser(username: String, email: String, password: String, completionHandler: @escaping (Bool) -> Void) {
        let parameters: Parameters = [
            "username" : username,
            "email" : email,
            "password" : password
        ]
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        Alamofire.request(
            baseURL + "/users",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseJSON
            { (response) in
                switch response.result {
                case .success(let JSONDictionary):
                    if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                        TIPUser.parseUserJSON(JSON: JSON, completionHandler: completionHandler)
                    }
                case .failure(let error):
                    print("Sign up request failed with error \(error)")
                    completionHandler(false)
                }
        }
    }
    
    class func logInUser(email: String, password: String, completionHandler: @escaping (Bool) -> Void) {
        let parameters: Parameters = [
            "email" : email,
            "password" : password
        ]
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        Alamofire.request(
            baseURL + "/users/login",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
            .debugLog()
            .responseJSON { (response) in
            switch response.result {
            case .success(let JSONDictionary):
                if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                    TIPUser.parseUserJSON(JSON: JSON, completionHandler: completionHandler)
                }
            case .failure(let error):
                print("Log in request failed with error \(error)")
                completionHandler(false)
            }
        }
    }
    
    class func updateUser(parameters: Parameters, completionHandler: @escaping (Bool) -> Void) {
        Alamofire.request(
            baseURL + "/users",
            method: .patch,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: self.authHeaders
        ).responseJSON { (response) in
            switch response.result {
            case .success(let JSONDictionary):
                if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                    TIPUser.parseUserJSON(JSON: JSON, completionHandler: { (success: Bool) in
                        completionHandler(success)
                    })
                }
            case .failure(let error):
                completionHandler(false)
                print("Update user request failed with error \(error)")
            }
        }
    }
    
    class func updateUserImage(data: Data, type: TIPUserImageType, completionHandler: @escaping (Bool) -> Void) {
        guard let user: TIPUser = TIPUser.currentUser else { return }
        
        let headers: HTTPHeaders = [
            "x-auth" : user.token,
            "content" : "image"
        ]
        
        Alamofire.upload(data, to: baseURL + "/users?image_type=" + type.rawValue, method: .patch, headers: headers).responseJSON { (response) in
            print(response)
            switch response.result {
            case .success(let JSONDictionary):
                if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                    TIPUser.parseUserJSON(JSON: JSON, completionHandler: { (success: Bool) in
                        completionHandler(success)
                    })
                }
            case .failure(let error):
                completionHandler(false)
                print("Update user request failed with error \(error)")
            }
        }
    }
    
    enum TIPContentType: String {
        case image = "image"
        case video = "video"
    }
    
    class func postContent(user: TIPUser, content: Data, type: TIPContentType, isPrivate: Bool, completionHandler: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [
            "x-auth" : user.token
        ]
        Alamofire.upload(content, to: baseURL + "/media_items?file_type=\(type.rawValue)&private=\(isPrivate)", method: .post, headers: headers).responseJSON { (response) in
            completionHandler(true)
        }
    }
    
    class func forgotPassword(email: String, completionHandler: @escaping (Bool) -> Void) {
        let parameters: Parameters = [
            "email" : email,
        ]
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        Alamofire.request(
            baseURL + "/forgot_password",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseJSON { (response) in
            print("RESPONSE: \(response.response?.statusCode)")
            switch response.result {
            case .success( _):
                completionHandler(true)
            case .failure( _):
                completionHandler(false)
            }
        }
    }
    
    class func searchUsers(query: String, completionHandler: @escaping ([TIPSearchUser]?, Error?) -> Void) {
        Alamofire.request(
            baseURL + "/search?search=\(query)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: self.authHeaders
        )
            .debugLog()
            .responseJSON 
        { (response) in
            TIPParser.parseSearchUsers(response: response, completionHandler: { (searchUsers: [TIPSearchUser]?, error: Error?) in
                completionHandler(searchUsers, error)
            })
        }
    }
    
    class func userAction(action: TIPUserAction, userId: String, completionHandler: @escaping (Bool) -> Void) {
        let parameters: Parameters = [
            "_id" : userId
        ]
        Alamofire.request(
            baseURL + action.rawValue,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: self.authHeaders
            ).responseString { (response) in
                //
        }
    }
    
    class func getFeed(completionHandler: @escaping ([TIPFeedItem]?) -> Void) {
        guard let user: TIPUser = TIPUser.currentUser else { return }

        let headers: HTTPHeaders = [
            "x-auth" : user.token,
            "Content-Type" : "application/json"
        ]
        Alamofire.request(
            baseURL + "/feed",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers
            )
            .debugLog()
            .responseJSON
        { (response) in
                switch response.result {
                case .success(let JSONDictionary):
                    if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                        if let feedItemsJSON: [[String : Any]] = JSON["feed_items"] as? [[String : Any]] {
                            print("JSON: \(feedItemsJSON)")
                            var feedItems: [TIPFeedItem] = [TIPFeedItem]()
                            for feedItemJSON in feedItemsJSON {
                                if let feedItem: TIPFeedItem = TIPFeedItem(JSON: feedItemJSON) {
                                    feedItems.append(feedItem)
                                }
                            }
                            completionHandler(feedItems)
                        }
                    }
                case .failure( _):
                    completionHandler(nil)
                }
        }
    }
    
    class func postAllAccess(allAccess: Bool, completionHandler: @escaping (Bool) -> Void) {
        let parameters: Parameters = [
            "all_access" : allAccess
        ]
        
        Alamofire.request(
            baseURL + "/all_access",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: self.authHeaders
        )
            .debugLog()
            .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    completionHandler(true)
                case .failure(_):
                    completionHandler(false)
                }
        }
    }
    
    class func tip(contentId: String, coins: Int, milliseconds: Int, completionHandler: @escaping (Int?, String?, Error?) -> Void) {
        let parameters: Parameters = [
            "coins" : coins,
            "milliseconds" : milliseconds
        ]
        Alamofire.request(
            baseURL + "/justthetip/\(contentId)",
            method: .patch,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: self.authHeaders
            )
            .debugLog()
            .responseJSON { (response) in
                switch response.result {
                case .success(let JSONDictionary):
                    if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                        if
                            let coins: Int = (JSON["myuser"] as? [String: Any])?["coins"] as? Int,
                            let dateString: String = JSON["updated_media_time"] as? String
                        {
                            completionHandler(coins, dateString, nil)
                        }
                    }
                    completionHandler(nil, nil, nil)
                case .failure(let error):
                    completionHandler(nil, nil, error)
            }
        }
        
    }
    
}

// Debugging
extension Request {
    public func debugLog() -> Self {
        #if DEBUG
            debugPrint("=======================================")
            debugPrint(self)
            debugPrint("=======================================")
        #endif
        return self
    }
}
