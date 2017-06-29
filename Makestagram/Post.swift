//
//  Post.swift
//  Makestagram
//
//  Created by Fernando on 6/27/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit
import FirebaseDatabase.FIRDataSnapshot

class Post {
    
    //MARK: - properties
    var key: String?
    let imageUrl: String?
    let imageHeight: CGFloat
    let creationDate: Date
    
    var likeCount: Int
    let poster: User
    var isLiked: Bool
    
    //MARK: - computed properties
    var dictValue: [String: Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        let userDict: [String: Any] = [
            Constants.UserDefaults.uid : poster.uid,
            Constants.UserDefaults.username : poster.username,
            Constants.Post.isLiked : isLiked
        ]
        return [
            Constants.Post.imageUrl : imageUrl!,
            Constants.Post.imageHeight : imageHeight,
            Constants.Post.createdAt : createdAgo,
            Constants.Post.likeCount : likeCount,
            Constants.Post.poster : userDict
        ]
    }
    
    //MARK: - initializers
    init(imageUrl: String, imageHeight: CGFloat){
        self.imageUrl = imageUrl
        self.imageHeight = imageHeight
        self.creationDate = Date()
        self.likeCount = 0
        self.poster = User.current
        self.isLiked = false
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any],
            let snapshotImageURL = dict[Constants.Post.imageUrl] as? String,
            let imageHeight = dict[Constants.Post.imageHeight] as? CGFloat,
            let createdAgos = dict[Constants.Post.createdAt] as? TimeInterval,
            let likeCount = dict[Constants.Post.likeCount] as? Int,
            let userDict = dict[Constants.Post.poster] as? [String : Any],
            let uid = userDict[Constants.UserDefaults.uid] as? String,
            let username = userDict[Constants.UserDefaults.username] as? String,
            let isLiked = userDict[Constants.Post.isLiked] as? Bool
            else {return nil}
        
        self.key = snapshot.key
        self.imageUrl = snapshotImageURL
        self.imageHeight = imageHeight
        self.creationDate = Date(timeIntervalSince1970: createdAgos)
        self.likeCount = likeCount
        self.poster = User(uid: uid, username: username)
        self.isLiked = isLiked
        
    }
}
