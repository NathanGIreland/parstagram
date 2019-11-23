//
//  SearchLocationsTableViewCell.swift
//  parstagram
//
//  Created by Nathan Ireland on 11/21/19.
//  Copyright © 2019 Nathan Ireland. All rights reserved.
//

import UIKit
import AFNetworking

class SearchLocationsTableViewCell: UITableViewCell {
    @IBOutlet weak var localtionLbl: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var addressLbl: UILabel!
    
    
    
    var location: NSDictionary! {
        didSet {
            localtionLbl.text = location["name"] as? String
            addressLbl.text = location.value(forKeyPath: "location.address") as? String
            
            let categories = location["categories"] as? NSArray
            if (categories != nil && categories!.count > 0) {
                let category = categories![0] as! NSDictionary
                let urlPrefix = category.value(forKeyPath: "icon.prefix") as! String
                let urlSuffix = category.value(forKeyPath: "icon.suffix") as! String
                
                let url = "\(urlPrefix)bg_32\(urlSuffix)"
                locationImageView.setImageWith(URL(string: url)!)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
