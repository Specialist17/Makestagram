//
//  PostService.swift
//  Makestagram
//
//  Created by Fernando on 6/27/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

struct PostService {
    
    static func create(for image: UIImage) {
        let imageRef = StorageReference.newPostImageReference()
        StorageService.uploadImage(image, at: imageRef) { (downloadUrl) in
            guard let downloadUrl = downloadUrl else {
                return
            }
            
            let urlString = downloadUrl.absoluteString
            let aspectHeight = image.aspectHeight
            create(forUrlString: urlString, aspectHeight: aspectHeight)
        }
    }
    
    private static func create(forUrlString urlString: String, aspectHeight: CGFloat){
        let currentUser = User.current
        
        let post = Post(imageUrl: urlString, imageHeight: aspectHeight)
        
        let dict = post.dictValue
        
        let postRef = Database.database().reference().child("posts").child(currentUser.uid).childByAutoId()
        
        postRef.updateChildValues(dict)
    }
    
}
