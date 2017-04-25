//
//  IROAPIClient.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 4/6/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import Foundation
import Alamofire

class IROAPIClient: NSObject {
    
    static let baseURL: String = "https://powerful-reef-30384.herokuapp.com"
    
    class func getPersonalStory(completionHandler: @escaping ([IROMediaItem]?) -> Void) {
//        print("Requesting story")
        guard let user: IROUser = IROUser.currentUser else {
            print("No current user")
            return
        }
        
        let headers: HTTPHeaders = [
            "x-auth" : user.token,
            "Content-Type" : "application/json"
        ]
        Alamofire.request(self.baseURL + "/users/me/media_items", headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let JSONDictionary):
                if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                    var mediaItems: [IROMediaItem] = []
                    if let mediaItemsJSON: [[String : Any]] = JSON["mediaItems"] as? [[String : Any]] {
//                        print("Story with \(mediaItemsJSON.count) posts successfully requested")
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
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        Alamofire.request(
            self.baseURL + "/users",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: header
            ).responseJSON { (response) in
                switch response.result {
                case .success(let JSONDictionary):
                    if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                        self.parseUserJSON(JSON: JSON, completionHandler: completionHandler)
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
            self.baseURL + "/users/login",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseJSON { (response) in
            switch response.result {
            case .success(let JSONDictionary):
                if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                    self.parseUserJSON(JSON: JSON, completionHandler: completionHandler)
                }
            case .failure(let error):
                print("Log in request failed with error \(error)")
                completionHandler(false)
            }
        }
    }
    
    class func updateUser(username: String?, fullname: String?, website: String?, bio: String?, completionHandler: @escaping (Bool) -> Void) {
        
        let parameters: Parameters = [
            "username" : username ?? "",
            "first_name" : fullname ?? "",
            "website" : website ?? "",
            "bio" : bio ?? ""
        ]
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        Alamofire.request(self.baseURL + "/users", method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let JSONDictionary):
                if let JSON: [String : Any] = JSONDictionary as? [String : Any] {
                    self.parseUserJSON(JSON: JSON, completionHandler: { (success: Bool) in
                        completionHandler(success)
                    })
                }
            case .failure(let error):
                completionHandler(false)
                print("Update user request failed with error \(error)")
            }
        }
    }
    
    class func updateProfileImage(data: Data, completionHandler: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type" : "image"
        ]
        Alamofire.upload(data, to: self.baseURL + "users?image_type=profile_image", method: .patch, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let JSONDictionary):
                print(JSONDictionary)
            case .failure(let error):
                completionHandler(false)
                print("Update user request failed with error \(error)")
            }
        }
    }
    
    // Helper method
    class func parseUserJSON(JSON: [String : Any], completionHandler: (Bool) -> Void) {
        let username: String? = JSON["username"] as? String // Username will exist for sign up but not log in
        let fullName: String? = JSON["first_name"] as? String
        let website: String? = JSON["website"] as? String
        let bio: String? = JSON["bio"] as? String
        
        if let _: IROUser = IROUser.currentUser {
            IROUser.currentUser?.username = username
            IROUser.currentUser?.fullName = fullName
            IROUser.currentUser?.website = website
            IROUser.currentUser?.bio = bio
            IROUser.currentUser?.save()
            completionHandler(true)
        }
        else if
            let email: String = JSON["email"] as? String,
            let token: String = JSON["token"] as? String
        {
            let user: IROUser = IROUser(
                username: username,
                email: email,
                token: token,
                fullName: fullName,
                profileImage: nil,
                backgroundImage: nil,
                website: website,
                bio: bio
            )
            user.save()
            IROUser.currentUser = user
            completionHandler(true)
        }
        else
        {
            print("Error parsing user response")
            completionHandler(false)
        }
    }
    
    enum IROContentType: String {
        case image = "image"
        case video = "video"
    }
    
    class func post(user: IROUser, content: Data, type: IROContentType, private: Bool, completionHandler: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [
            "x-auth" : user.token
        ]
        Alamofire.upload(content, to: self.baseURL + "/media_items?file_type=\(type.rawValue)", method: .post, headers: headers).responseJSON { (response) in
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
            self.baseURL + "/forgot_password",
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
