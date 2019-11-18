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
import InputBarAccessoryView
import MessageKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let currentUser = PFUser.current()
    let randomComment = ["Cool Photo", "Wish I was there", "nice photo", "I wanna go next time", "next time invite me", "the picture kinds sucks", "lolol", "lolz"]
    var numberOfPost: Int!
    
    let myrefreshControl = UIRefreshControl()
    let commentBar = MessageInputBar()
    var showsCommentbar = false
    @IBOutlet weak var tableView: UITableView!
    
    
    var posts = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
        
        myrefreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.refreshControl = myrefreshControl
     
        DataRequest.addAcceptableImageContentTypes(["application/octet-stream"])

        // Do any additional setup after loading the view.
    }
    
    override var inputAccessoryView: UIView?{
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool{
        return showsCommentbar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshPost()
        
              
    }
    
    func refreshPost(){
         let query = PFQuery(className: "Post")
               query.includeKey("author.profilePicture")
               query.includeKey("author")
        query.includeKey("comments.author")
        query.order(byDescending: "createdAt")
               numberOfPost = 10
               query.limit = numberOfPost
               query.findObjectsInBackground{(posts, error) in
                   if posts != nil{
                       self.posts = posts!
                       self.tableView.reloadData()
                       self.myrefreshControl.endRefreshing()
                   }
               }
    }
    
    func morePost(){
        let query = PFQuery(className: "Post")
        query.includeKey("author.profilePicture")
        query.includeKey("author")
        query.includeKey("comments.author")
        query.order(byDescending: "createdAt")
        numberOfPost = numberOfPost + 20
        query.limit = numberOfPost
        query.findObjectsInBackground{(posts, error) in
            if posts != nil{
                self.posts = posts!
                self.tableView.reloadData()
                self.myrefreshControl.endRefreshing()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
            
            
            
            
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
        }else if indexPath.row <= comments.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentTableViewCell
            
            let comment = comments[indexPath.row - 1]
            cell.commentLbl.text = comment["text"] as? String
            let user = comment["author"] as! PFUser
            cell.nameLbl.text = user.username
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            return cell
        }
        
        
        
        
    
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == posts.count{
            morePost()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == comments.count + 1 {
          showsCommentbar = true
          self.becomeFirstResponder()
          commentBar.inputTextView.becomeFirstResponder()
        }
//        comment["text"] = randomComment[Int.random(in: 0..<8)]
//        comment["post"] = post
//        comment["author"] = PFUser.current()!
//
//        post.add(comment, forKey: "comments")
//
//        post.saveInBackground{(success, error) in
//            if success {
//                print("comment saved")
//            }else{
//                print("error")
//            }
//
//        }
    }
    
    @objc func onRefresh() {
        refreshPost()
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
