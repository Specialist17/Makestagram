//
//  DatabaseReference+Location.swift
//  Makestagram
//
//  Created by Fernando on 6/29/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import Foundation
import FirebaseDatabase


extension DatabaseReference {
    enum MGLocation {
        case root
        case posts(uid: String)
        case showPost(posterUID: String, postKey: String)
        case showFollowers(userUID: String)
        case timeline(userUID: String)
        
        func asDatabaseReference() -> DatabaseReference {
            let root = Database.database().reference()
            
            switch self {
            case .root:
                return root
                
            case .posts(let uid):
                return root.child("posts").child(uid)
                
            case let .showPost (posterUID, postKey):
                return root.child("posts").child(posterUID).child(postKey)
                
            case let .showFollowers(userUID):
                return root.child("followers").child(userUID)

            case let .timeline(userUID):
                return root.child("timeline").child(userUID)
                
            }
        }

    }
    
    static func toLocation(_ location: MGLocation) -> DatabaseReference {
            return location.asDatabaseReference()
        }
    
}
