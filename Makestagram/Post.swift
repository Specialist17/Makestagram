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
    
    //MARK: - computed properties
    var dictValue: [String: Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        
        return [
            Constants.Post.imageUrl : imageUrl,
            Constants.Post.imageHeight : imageHeight,
            Constants.Post.createdAt : createdAgo
        ]
    }
    
    //MARK: - initializers
    init(imageUrl: String, imageHeight: CGFloat){
        self.imageUrl = imageUrl
        self.imageHeight = imageHeight
        self.creationDate = Date()
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any],
            let snapshotImageURL = dict[Constants.Post.imageUrl] as? String,
            let imageHeight = dict[Constants.Post.imageHeight] as? CGFloat,
            let createdAgos = dict[Constants.Post.createdAt] as? TimeInterval
            else {return nil}
        
        self.key = snapshot.key
        self.imageUrl = snapshotImageURL
        self.imageHeight = imageHeight
        self.creationDate = Date(timeIntervalSince1970: createdAgos)
    }
}
