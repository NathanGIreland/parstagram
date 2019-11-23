//
//  PostTableViewCell.swift
//  parstagram
//
//  Created by Nathan Ireland on 11/10/19.
//  Copyright © 2019 Nathan Ireland. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

  
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var commentField: UILabel!
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var locationNames: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
