//
//  FeedViewController.swift
//  parstagram
//
//  Created by Nathan Ireland on 11/9/19.
//  Copyright © 2019 Nathan Ireland. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import Alamofire

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let currentUser = PFUser.current()

    @IBOutlet weak var tableView: UITableView!
    
    
    var posts = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
     
        DataRequest.addAcceptableImageContentTypes(["application/octet-stream"])

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className: "Post")
        query.includeKey("author.profilePicture")
        query.includeKey("author")
        query.limit = 20
        query.findObjectsInBackground{(posts, error) in
            if posts != nil{
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
        
              
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        let post = posts[indexPath.row]
        
        let user = post["author"] as! PFUser
        cell.nameField.text = user.username
        cell.commentField.text = post["caption"] as? String
        let postImagefile = post["image"] as! PFFileObject
        let profilUrlString = postImagefile.url!
        let profileUrl = URL(string: profilUrlString)!
        cell.ImageView.af_setImage(withURL: profileUrl)
        
        
        if user["profilePicture"] != nil{
            let imagefile = user["profilePicture"] as! PFFileObject
            let urlString = imagefile.url!
            let url = URL(string: urlString)!
            cell.profileImageView.af_setImage(withURL: url)
        }
        
        return cell
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
