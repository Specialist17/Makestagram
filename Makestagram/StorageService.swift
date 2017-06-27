//
//  StorageService.swift
//  Makestagram
//
//  Created by Fernando on 6/27/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit
import FirebaseStorage

struct StorageService {
    
    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        guard let imageData = UIImageJPEGRepresentation(image, 0.1) else {
            return completion(nil)
        }
        
        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
            
            if let err = error {
                assertionFailure(err.localizedDescription)
                return completion(nil)
            }
            
            completion(metadata?.downloadURL())
        })
    }
    
}
