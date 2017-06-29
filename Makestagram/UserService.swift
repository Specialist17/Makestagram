//
//  UserService.swift
//  Makestagram
//
//  Created by Fernando on 6/26/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    
    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": username]
        
        let ref = Database.database().reference().child(Constants.DatabaseRef.users).child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let err = error {
                assertionFailure(err.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child(Constants.DatabaseRef.users).child(uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(user)
        })
    }
    
    static func posts(for user: User, completion: @escaping ([Post]) -> Void) {
        let ref = Database.database().reference().child(Constants.Post.posts).child(user.uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let dispatchGroup = DispatchGroup()
            
            let posts: [Post] = snapshot.reversed().flatMap{
                guard let post = Post(snapshot: $0)
                    else {return nil}
                
                dispatchGroup.enter()
                
                LikeService.isPostLiked(post, byCurrentUserWithCompletion: { (isLiked) in
                    post.isLiked = isLiked
                    
                    dispatchGroup.leave()
                })
                
                return post
            }
            dispatchGroup.notify(queue: .main, execute: {
                completion(posts)
            })
        })
    }
    
    static func usersExcludingCurrentUSer(completion: @escaping ([User]) -> Void) {
        let currentUser = User.current
        
        // 1: Create a DatabaseReference to read all users from the database.
        let ref = Database.database().reference().child(Constants.DatabaseRef.users)
        
        // 2: Read the users node from the database.
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else{return completion ([])}
            
            // 3: Take the snapshot and perform a few transformations. First, we convert all of the child DataSnapshot into User using our failable initializer. Next we filter out the current user object from the User array.
            let users = snapshot
                .flatMap(User.init)
                .filter{$0.uid != currentUser.uid}
            
            // 4: Create a new DispatchGroup so that we can be notified when all asynchronous tasks are finished executing. We'll use the notify(queue:) method on DispatchGroup as a completion handler for when all follow data has been read.
            let dispatchGroup = DispatchGroup()
            
            users.forEach({ (user) in
                dispatchGroup.enter()
                
                // 5: Make a request for each individual user to determine if the user is being followed by the current user.
                FollowService.isBeingFollowed(user, byCurrentUserWithCompletion: { (isFollowed) in
                    user.isFollowed = isFollowed
                    dispatchGroup.leave()
                })
            })
            
            // 6: Run the completion block after all follow relationship data has returned.
            dispatchGroup.notify(queue: .main, execute: {
                completion(users)
            })
        })
    }
    
    static func followers(for user: User, completion: @escaping ([String]) -> Void) {
        let followersRef = Constants.databaseReference.child("followers").child(user.uid)
        
        followersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let followersDict = snapshot.value as? [String: Bool] else {
                return completion([])
            }
            
            let followersKeys = Array(followersDict.keys)
            completion(followersKeys)
        })
    }
    
    static func timeline(completion: @escaping ([Post]) -> Void) {
        let currentUser = User.current
        
        let timelineRef = Database.database().reference().child("timeline").child(currentUser.uid)
        timelineRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }
            
            let dispatchGroup = DispatchGroup()
            
            var posts = [Post]()
            
            for postSnap in snapshot {
                guard let postDict = postSnap.value as? [String : Any],
                    let posterUID = postDict["poster_uid"] as? String
                    else { continue }
                
                dispatchGroup.enter()
                
                PostService.show(forKey: postSnap.key, posterUID: posterUID) { (post) in
                    if let post = post {
                        posts.append(post)
                    }
                    
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(posts.reversed())
            })
        })
    }
    
}
