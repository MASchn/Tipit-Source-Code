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

class TIPAPIClient: NSObject {
    
    class func getStory(userId: String, completionHandler: @escaping (TIPStory?) -> Void) {
        guard let user: TIPUser = TIPUser.currentUser else { return }
        let headers: HTTPHeaders = [
            "x-auth" : user.token,
            "Content-Type" : "application/json"
        ]
        Alamofire.request(baseURL + "/story?id=\(userId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            self.parseStoryResponse(response: response, completionHandler: { (story: TIPStory?) in
                completionHandler(story)
            })
        }
    }
    
    
    class func getPersonalStory(completionHandler: @escaping (TIPStory?) -> Void) {
        guard let user: TIPUser = TIPUser.currentUser else { return }
        let headers: HTTPHeaders = [
            "x-auth" : user.token,
            "Content-Type" : "application/json"
        ]
        Alamofire.request(baseURL + "/users/me/media_items", headers: headers).responseJSON { (response) in
            self.parseStoryResponse(response: response, completionHandler: { (story: TIPStory?) in
                completionHandler(story)
            })
        }
    }
    
    // Helper method
    private class func parseStoryResponse(response: DataResponse<Any>, completionHandler: @escaping (TIPStory?) -> Void) {
        guard let user: TIPUser = TIPUser.currentUser else { return }
        
        switch response.result {
        case .success(let JSONDictionary):
            if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                var mediaItems: [TIPMediaItem] = []
                if let mediaItemsJSON: [[String : Any]] = JSON["mediaItems"] as? [[String : Any]] {
                    for mediaItemJSON: [String : Any] in mediaItemsJSON {
                        if let mediaItem: TIPMediaItem = TIPMediaItem(JSON: mediaItemJSON) {
                            mediaItems.append(mediaItem)
                        }
                    }
                    TIPStory.story(with: user, mediaItems: mediaItems, completion: { (story: TIPStory?) in
                        completionHandler(story)
                    })
                }
            }
        case .failure(let error):
            print(error)
            completionHandler(nil)
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
            method: .post, parameters:
            parameters,
            encoding: JSONEncoding.default,
            headers: headers).responseJSON { (response) in
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
        ).responseJSON { (response) in
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
        guard let user: TIPUser = TIPUser.currentUser else { return }
        
        let headers: HTTPHeaders = [
            "x-auth" : user.token,
            "Content-Type" : "application/json"
        ]
        Alamofire.request(baseURL + "/users", method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
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
    
    class func postContent(user: TIPUser, content: Data, type: TIPContentType, private: Bool, completionHandler: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [
            "x-auth" : user.token
        ]
        Alamofire.upload(content, to: baseURL + "/media_items?file_type=\(type.rawValue)", method: .post, headers: headers).responseJSON { (response) in
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
            switch response.result {
            case .success(let JSONDictionary):
                completionHandler(true)
            case .failure(let error):
                completionHandler(false)
            }
        }
    }
    
    class func searchUsers(query: String, completionHandler: @escaping ([TIPSearchUser]?) -> Void) {
        let headers: HTTPHeaders = self.headers()
        Alamofire.request(
            baseURL + "/search?search=\(query)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseJSON { (response) in
            let searchUsers: [TIPSearchUser]? = TIPParser.parse(response: response)
            completionHandler(searchUsers)
        }
    }
    
    class func headers() -> HTTPHeaders {
        guard let user: TIPUser = TIPUser.currentUser else { return HTTPHeaders() }
        
        return [
            "x-auth" : user.token,
            "Content-Type" : "application/json"
        ]
    }
    
    enum TIPUserAction: String {
        case follow = "/follow"
        case unfollow = "/unfollow"
        case subscribe = "/subscribe"
        case unsubscribe = "/unsubscribe"
    }
    
    class func userAction(action: TIPUserAction, userId: String, completionHandler: @escaping (Bool) -> Void) {
        guard let user: TIPUser = TIPUser.currentUser else { return }

        let headers: HTTPHeaders = [
            "x-auth" : user.token,
            "Content-Type" : "application/json"
        ]
        let parameters: Parameters = [
            "_id" : userId
        ]
        Alamofire.request(
            baseURL + action.rawValue,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
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
            ).responseJSON { (response) in
                switch response.result {
                case .success(let JSONDictionary):
                    if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                        if let feedItemsJSON: [[String : Any]] = JSON["feed_items"] as? [[String : Any]] {
                            var feedItems: [TIPFeedItem] = [TIPFeedItem]()
                            for feedItemJSON in feedItemsJSON {
                                if let feedItem: TIPFeedItem = TIPFeedItem(JSON: feedItemJSON) {
                                    feedItems.append(feedItem)
                                }
                            }
                            completionHandler(feedItems)
                        }
                    }
                case .failure(let error):
                    completionHandler(nil)
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
