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
let amazons3: String = "https://s3-us-west-2.amazonaws.com/moneyshot-cosmo"

enum IROUserImageType: String  {
    case profile = "profile_image"
    case background = "background_image"
}

class IROAPIClient: NSObject {
    
    
    class func getPersonalStory(completionHandler: @escaping ([IROMediaItem]?) -> Void) {
        guard let user: IROUser = IROUser.currentUser else { return }
        
        let headers: HTTPHeaders = [
            "x-auth" : user.token,
            "Content-Type" : "application/json"
        ]
        
        Alamofire.request(baseURL + "/users/me/media_items", headers: headers).responseJSON { (response) in
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
                        completionHandler(mediaItems)
                    }
                }
            case .failure(let error):
                print(error)
                completionHandler(nil)
            }
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
    
    class func updateUser(username: String?, fullname: String?, website: String?, bio: String?, completionHandler: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [
            "x-auth" : IROUser.currentUser!.token,
            "Content-Type" : "application/json"
        ]
        let parameters: Parameters = [
            "username" : username ?? "",
            "first_name" : fullname ?? "",
            "website" : website ?? "",
            "bio" : bio ?? ""
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
            print(response)
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
    
}
