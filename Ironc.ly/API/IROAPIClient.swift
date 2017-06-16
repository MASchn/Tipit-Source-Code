//
//  IROAPIClient.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 4/6/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import Foundation
import Alamofire

let baseURL: String = "https://powerful-reef-30384.herokuapp.com"

enum IROUserImageType: String  {
    case profile = "profile_image"
    case background = "background_image"
}

class IROAPIClient: NSObject {
    
    class func getStory(userId: String, completionHandler: @escaping (IROStory?) -> Void) {
        guard let user: IROUser = IROUser.currentUser else { return }
        let headers: HTTPHeaders = [
            "x-auth" : user.token,
            "Content-Type" : "application/json"
        ]
        Alamofire.request(baseURL + "/story?id=\(userId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            self.parseStoryResponse(response: response, completionHandler: { (story: IROStory?) in
                completionHandler(story)
            })
        }
    }
    
    
    class func getPersonalStory(completionHandler: @escaping (IROStory?) -> Void) {
        guard let user: IROUser = IROUser.currentUser else { return }
        let headers: HTTPHeaders = [
            "x-auth" : user.token,
            "Content-Type" : "application/json"
        ]
        Alamofire.request(baseURL + "/users/me/media_items", headers: headers).responseJSON { (response) in
            self.parseStoryResponse(response: response, completionHandler: { (story: IROStory?) in
                completionHandler(story)
            })
        }
    }
    
    // Helper method
    private class func parseStoryResponse(response: DataResponse<Any>, completionHandler: @escaping (IROStory?) -> Void) {
        switch response.result {
        case .success(let JSONDictionary):
            if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                var mediaItems: [IROMediaItem] = []
                if let mediaItemsJSON: [[String : Any]] = JSON["mediaItems"] as? [[String : Any]] {
                    for mediaItemJSON: [String : Any] in mediaItemsJSON {
                        if let mediaItem: IROMediaItem = IROMediaItem(JSON: mediaItemJSON) {
                            mediaItems.append(mediaItem)
                        }
                    }
                    IROStory.story(with: IROUser.currentUser!, mediaItems: mediaItems, completion: { (story: IROStory?) in
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
                        IROUser.parseUserJSON(JSON: JSON, completionHandler: completionHandler)
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
                    IROUser.parseUserJSON(JSON: JSON, completionHandler: completionHandler)
                }
            case .failure(let error):
                print("Log in request failed with error \(error)")
                completionHandler(false)
            }
        }
    }
    
    class func updateUser(parameters: Parameters, completionHandler: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [
            "x-auth" : IROUser.currentUser!.token,
            "Content-Type" : "application/json"
        ]
        Alamofire.request(baseURL + "/users", method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let JSONDictionary):
                if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                    IROUser.parseUserJSON(JSON: JSON, completionHandler: { (success: Bool) in
                        completionHandler(success)
                    })
                }
            case .failure(let error):
                completionHandler(false)
                print("Update user request failed with error \(error)")
            }
        }
    }
    
    class func updateUserImage(data: Data, type: IROUserImageType, completionHandler: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [
            "x-auth" : IROUser.currentUser!.token,
            "content" : "image"
        ]
        
        Alamofire.upload(data, to: baseURL + "/users?image_type=" + type.rawValue, method: .patch, headers: headers).responseJSON { (response) in
            print(response)
            switch response.result {
            case .success(let JSONDictionary):
                if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                    IROUser.parseUserJSON(JSON: JSON, completionHandler: { (success: Bool) in
                        completionHandler(success)
                    })
                }
            case .failure(let error):
                completionHandler(false)
                print("Update user request failed with error \(error)")
            }
        }
    }
    
    enum IROContentType: String {
        case image = "image"
        case video = "video"
    }
    
    class func postContent(user: IROUser, content: Data, type: IROContentType, private: Bool, completionHandler: @escaping (Bool) -> Void) {
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
    
    class func getAllUsers(completionHandler: @escaping ([IROSearchUser]?) -> Void) {
        let headers: HTTPHeaders = [
            "x-auth" : IROUser.currentUser!.token,
            "Content-Type" : "application/json"
        ]
        Alamofire.request(baseURL + "/users", headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let JSONDictionary):
                if let JSONArray: [[String : Any]] = JSONDictionary as? [[String : Any]] {
                    var searchItems: [IROSearchUser] = [IROSearchUser]()
                    for JSON: [String : Any] in JSONArray {
                        if let searchItem: IROSearchUser = IROSearchUser(JSON: JSON) {
                            searchItems.append(searchItem)
                        }
                    }
                    completionHandler(searchItems)
                } else {
                    completionHandler(nil)
                }
            case .failure(let error):
                print(error)
                completionHandler(nil)
            }
        }
    }
    
    enum IROUserAction: String {
        case follow = "/follow"
        case unfollow = "/unfollow"
        case subscribe = "/subscribe"
        case unsubscribe = "/unsubscribe"
    }
    
    class func userAction(action: IROUserAction, userId: String, completionHandler: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [
            "x-auth" : IROUser.currentUser!.token,
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
    
    class func getFeed(completionHandler: @escaping ([IROFeedItem]?) -> Void) {
        let headers: HTTPHeaders = [
            "x-auth" : IROUser.currentUser!.token,
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
                            var feedItems: [IROFeedItem] = [IROFeedItem]()
                            for feedItemJSON in feedItemsJSON {
                                if let feedItem: IROFeedItem = IROFeedItem(JSON: feedItemJSON) {
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
    
    class func get<T>(endpoint: String, authentication: Bool = false, contentType: String = "application/json", completionHandler: ([T]?) -> Void) {
        
        var headers: HTTPHeaders = [
            "Content-Type" : contentType
        ]
        
        if authentication == true {
            headers["x-auth"] = IROUser.currentUser!.token
        }
        
//        Alamofire.request(
//            baseURL + endpoint,
//            method: .get,
//            parameters: nil,
//            encoding: JSONEncoding.default,
//            headers: headers
//            ).responseJSON { (response) in
//                //
//        }
        
    }
    
}
