//
//  CreateUsernameViewController.swift
//  Makestagram
//
//  Created by Fernando on 6/26/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateUsernameViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nextButton: MakestagramButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
        When a user taps the next button we want the following to happen:
         1: Get a reference to the current user that's logged into Firebase. We'll need the user uid to create the relative path to write to.
         2: Check that the user has entered a username in the username text field.
         3: Create a reference to the location we want to store the data
         4: Create a dictionary of the data we want to store in our database
         5: Write the dictionary at the specified location
         6: Handle the success or failure of writing to the database
    */
    @IBAction func nextButtonTapped(_ sender: MakestagramButton) {
        // 1: First we guard to check that a FIRUser is logged in and that the user has provided a username in the text field.
        guard let firUser = Auth.auth().currentUser,
            let username = usernameTextField.text,
            !username.isEmpty else {return}
        
        
        UserService.create(firUser, username: username) { (user) in
            guard let user = user else { return }
            
            User.setCurrent(user, writeToUserDefaults: true)
            
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
           
            if let initialViewController = storyboard.instantiateInitialViewController() {
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}
