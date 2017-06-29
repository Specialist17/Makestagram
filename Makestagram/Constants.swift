//
//  Constants.swift
//  Makestagram
//
//  Created by Fernando on 6/26/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Constants {
    
    struct Segue {
        static let toCreateUsername = "toCreateUsername"
    }
    
    struct UserDefaults {
        static let currentUser = "currentUser"
        static let uid = "uid"
        static let username = "username"
        static let timeline = "timeline"
    }
    
    struct Post {
        static let posts = "posts"
        static let imageUrl = "image_url"
        static let imageHeight = "image_height"
        static let createdAt = "created_at"
        static let likeCount = "like_count"
        static let poster = "poster"
        static let postLikes = "postLikes"
        static let isLiked = "isLiked"
    }
    
    struct DatabaseRef {
        static let users = "users"
        static let followers = "followers"
    }
    
    static let databaseReference = Database.database().reference()
}
