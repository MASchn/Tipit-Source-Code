//
//  TIPStory.swift
//  Ironc.ly
//

import Foundation
import UIKit

struct TIPStory {
    let posts: [TIPPost]
    let isSubscribed: Bool
    
//    static func mockStory() -> TIPStory {
//        let user1: TIPUser = TIPUser(username: "Hanna Julie Marie", email: "user1@gmail.com", token: "token", profileImage: #imageLiteral(resourceName: "user1"))
//        let user2: TIPUser = TIPUser(username: "Silvia Marie Ann", email: "user2@gmail.com", token: "token", profileImage: #imageLiteral(resourceName: "user2"))
//        
//        let post1: TIPPost = TIPPost(username: user1.username, contentURL: nil, contentImage: UIImage(named: "feed_image_1")!, index: 0, isPrivate: true)
//        let post2: TIPPost = TIPPost(username: user2.username, contentURL: nil, contentImage: UIImage(named: "feed_image_2")!, index: 1, isPrivate: false)
//        let post3: TIPPost = TIPPost(username: user1.username, contentURL: nil, contentImage: UIImage(named: "feed_image_1")!, index: 2, isPrivate: true)
//        let post4: TIPPost = TIPPost(username: user2.username, contentURL: nil, contentImage: UIImage(named: "feed_image_2")!, index: 3, isPrivate: false)
//        let post5: TIPPost = TIPPost(username: user1.username, contentURL: nil, contentImage: UIImage(named: "feed_image_1")!, index: 4, isPrivate: true)
//        let post6: TIPPost = TIPPost(username: user2.username, contentURL: nil, contentImage: UIImage(named: "feed_image_2")!, index: 5, isPrivate: false)
//        let post7: TIPPost = TIPPost(username: user1.username, contentURL: nil, contentImage: UIImage(named: "feed_image_1")!, index: 6, isPrivate: true)
//        let post8: TIPPost = TIPPost(username: user2.username, contentURL: nil, contentImage: UIImage(named: "feed_image_2")!, index: 7, isPrivate: false)
//        return TIPStory(posts: [post1, post2, post3, post4, post5, post6, post7, post8])
//    }
    
    // TODO: Refactor
    static func story(mediaItems: [TIPMediaItem], isSubcribed: Bool, completion: @escaping (TIPStory?) -> Void) {
        var posts: [TIPPost] = []
        let firstGroup = DispatchGroup()
        for index: Int in 0..<mediaItems.count {
            let item: TIPMediaItem = mediaItems[index]
            firstGroup.enter()
            if item.type == .photo {
                UIImage.download(urlString: item.url, completion: { (image) in
                    if let image: UIImage = image {
                        let post: TIPPost = TIPPost(
                            contentId: item.contentId,
                            username: item.username,
                            contentURL: item.url,
                            contentImage: image,
                            index: index,
                            isPrivate: item.isPrivate
                        )
                        posts.append(post)
                    }
                    firstGroup.leave()
                })
            } else {
                var post: TIPPost = TIPPost(
                    contentId: item.contentId,
                    username: item.username,
                    contentURL: item.url,
                    contentImage: nil,
                    index: index,
                    isPrivate: item.isPrivate
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
            let story: TIPStory = TIPStory(posts: posts, isSubscribed: isSubcribed)
            completion(story)
        }
    }
    
}
