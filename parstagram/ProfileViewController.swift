//
//  ProfileViewController.swift
//  parstagram
//
//  Created by Nathan Ireland on 11/14/19.
//  Copyright © 2019 Nathan Ireland. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import Alamofire

class ProfileViewController: UIViewController {
    
     let currentUser = PFUser.current()
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var profile = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        DataRequest.addAcceptableImageContentTypes(["application/octet-stream"])
        
        
        

        // Do any additional setup after loading the view.
    }

      override func viewDidAppear(_ animated: Bool) {
             super.viewDidAppear(animated)
        
        
        if currentUser!["profilePicture"] != nil{
            let imagefile = currentUser!["profilePicture"] as! PFFileObject
            let urlString = imagefile.url!
            let url = URL(string: urlString)!
            profileImageView.af_setImage(withURL: url)
        }
        
        
        
        
        }
         


        

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
