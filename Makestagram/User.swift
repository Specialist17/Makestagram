//
//  User.swift
//  Makestagram
//
//  Created by Fernando on 6/26/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User: NSObject {
    
    // MARK: - Singleton
    
    private static var _current: User?
    
    static var current: User {
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        return currentUser
    }
    
    
    // MARK: - Properties
    
    let uid: String
    let username: String
    
    // MARK: - Init
    
    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
        
        super.init()
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any],
            let username = dict["username"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        self.username = username
        
        super.init()
            
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String,
            let username = aDecoder.decodeObject(forKey: Constants.UserDefaults.username) as? String
            else{return nil}
        
        self.uid = uid
        self.username = username
        
        super.init()
    }
    
    // MARK: - Class Methods
    
    /**
        1: We add another parameter that takes a bool on whether the user should be written to UserDefaults. We give this value a default value of false.
    */
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        
        // 2: We check if the boolean value for writeToUserDefaults is true. If so, we write the user object to UserDefaults.
        if writeToUserDefaults {
            
            // 3: We use NSKeyedArchiver to turn our user object into Data. We needed to implement the NSCoding protocol and inherit from NSObject to use NSKeyedArchiver.
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            
            // 4: We store the data for our current user with the correct key in UserDefaults.
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
        
        _current = user
    }
    
    
    
    // MARK: - User Defaults
    
    func encoding(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
        aCoder.encode(username, forKey: Constants.UserDefaults.username)
    }
}


extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
        aCoder.encode(username, forKey: Constants.UserDefaults.username)
    }
}
