//
//  PostActionCell.swift
//  Makestagram
//
//  Created by Fernando on 6/28/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit

class PostActionCell: UITableViewCell {

    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    static let height: CGFloat = 46
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButtonTapped(_ sender: UIButton) {
        
    }
}
