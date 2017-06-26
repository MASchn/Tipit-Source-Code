//
//  IROStory.swift
//  Ironc.ly
//
//  Created by Richard McAteer on 2/2/17.
//  Copyright © 2017 Richard McAteer. All rights reserved.
//

import Foundation
import UIKit

struct IROStory {
    let posts: [IROPost]
    
    static func mockStory() -> IROStory {
        let user1: IROUser = IROUser(username: "Hanna Julie Marie", email: "user1@gmail.com", token: "token", profileImage: #imageLiteral(resourceName: "user1"))
        let user2: IROUser = IROUser(username: "Silvia Marie Ann", email: "user2@gmail.com", token: "token", profileImage: #imageLiteral(resourceName: "user2"))
        
        let post1: IROPost = IROPost(user: user1, contentURL: nil, contentImage: UIImage(named: "feed_image_1")!, index: 0, isPrivate: true)
        let post2: IROPost = IROPost(user: user2, contentURL: nil, contentImage: UIImage(named: "feed_image_2")!, index: 1, isPrivate: false)
        let post3: IROPost = IROPost(user: user1, contentURL: nil, contentImage: UIImage(named: "feed_image_1")!, index: 2, isPrivate: true)
        let post4: IROPost = IROPost(user: user2, contentURL: nil, contentImage: UIImage(named: "feed_image_2")!, index: 3, isPrivate: false)
        let post5: IROPost = IROPost(user: user1, contentURL: nil, contentImage: UIImage(named: "feed_image_1")!, index: 4, isPrivate: true)
        let post6: IROPost = IROPost(user: user2, contentURL: nil, contentImage: UIImage(named: "feed_image_2")!, index: 5, isPrivate: false)
        let post7: IROPost = IROPost(user: user1, contentURL: nil, contentImage: UIImage(named: "feed_image_1")!, index: 6, isPrivate: true)
        let post8: IROPost = IROPost(user: user2, contentURL: nil, contentImage: UIImage(named: "feed_image_2")!, index: 7, isPrivate: false)
        return IROStory(posts: [post1, post2, post3, post4, post5, post6, post7, post8])
    }
    
    static func story(with user: IROUser, mediaItems: [IROMediaItem], completion: @escaping (IROStory?) -> Void) {
        var posts: [IROPost] = []
        let firstGroup = DispatchGroup()
        for index: Int in 0..<mediaItems.count {
            let item: IROMediaItem = mediaItems[index]
            firstGroup.enter()
            if item.type == .photo {
                UIImage.download(urlString: item.url, completion: { (image) in
                    if let image: UIImage = image {
                        let post: IROPost = IROPost(
                            user: user,
                            contentURL: item.url,
                            contentImage: image,
                            index: index,
                            isPrivate: false
                        )
                        posts.append(post)
                    }
                    firstGroup.leave()
                })
            } else {
                var post: IROPost = IROPost(
                    user: user,
                    contentURL: item.url,
                    contentImage: nil,
                    index: index,
                    isPrivate: false
                )
                post.type = .video
                posts.append(post)
                firstGroup.leave()
            }
        }
        // Called when all posts have finished loading
        firstGroup.notify(queue: DispatchQueue.main) {
            posts.sort(by: {$0.index! < $1.index!})
//            print("Posts: \(posts)")
            let story: IROStory = IROStory(posts: posts)
            completion(story)
        }
    }
    
}
