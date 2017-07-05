//
//  ProfileHeaderView.swift
//  Makestagram
//
//  Created by Fernando on 6/30/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView {
    // MARK: - Subviews
    
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    
    // MARK: - Properties
    weak var delegate: ProfileHeaderViewDelegate?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        settingsButton.layer.cornerRadius = 6
        settingsButton.layer.borderColor = UIColor.lightGray.cgColor
        settingsButton.layer.borderWidth = 1
    }
    
    // MARK: - IBAction
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        delegate?.didTapSettingsButton(sender, on: self)
    }
}
