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
            "image_url" : imageUrl,
            "image_heigh" : imageHeight,
            "created_at" : createdAgo
        ]
    }
    
    //MARK: - initializers
    init(imageUrl: String, imageHeight: CGFloat){
        self.imageUrl = imageUrl
        self.imageHeight = imageHeight
        self.creationDate = Date()
    }
}
