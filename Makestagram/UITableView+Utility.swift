//
//  UITableView+Utility.swift
//  Makestagram
//
//  Created by Fernando on 6/29/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit

protocol CellIdentifiable {
    static var cellIdentifier: String { get }
}


/**
 1: We create an extension on our protocol CellIdentifiable. In our extension, we can define default values for our protocol properties and functions.
 2: We define a default value for cellIdentifier. We return the name of the custom UITableViewCell class as a string using String(describing:). This prevents us from making typos when typing out the cell identifier as a String.
 3: We make sure that UITableViewCell implements the CellIdentifiable protocol. This will allow us to define constraints on our generic that we'll learn about next.
 */


// 1
extension CellIdentifiable where Self: UITableViewCell {
    
    // 2
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

// 3
extension UITableViewCell: CellIdentifiable { }





//  1: We define a generic function that extensions UITableView. Notice that we can add constraints to our generic type. In our function declaration we specific that T must be of type UITableViewCell and conform to CellIdentifiable. This allows us to guarentee that we can access the cellIdentifier that we added with our CellIdentifiable protocol.
//  2: We unwrap the custom UITableViewCell based on it's cellIdentifier and make sure the type conforms to T. In this line, we remove the need to type out the cell identifier as a String and force casting the type explicitly.
//  3: If the identifier or casting fails, we crash the app but print a nice error message so we'll know which cell caused the issue.
extension UITableView{
    
    //1
    func dequeueReusableCell<T : UITableViewCell>() -> T where T: CellIdentifiable {
        
        //2
        guard let cell = dequeueReusableCell(withIdentifier: T.cellIdentifier) as? T else {
            //3
            fatalError("Error dequeuing cell for identifier \(T.cellIdentifier)")
        }
        
        return cell
        
    }
}
