//
//  PostHeaderCell.swift
//  Makestagram
//
//  Created by Fernando on 6/28/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit

class PostHeaderCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    
    static let height: CGFloat = 54
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func optionsButtonTapped(_ sender: UIButton) {
        print("options button tapped")
    }
}
