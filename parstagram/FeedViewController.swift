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
import MessageInputBar
import ViewAnimator

extension CGRect{
     init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
         self.init(x:x,y:y,width:width,height:height)
     }

 }

extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
}



class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    //Varibles
    let currentUser = PFUser.current()
    let myrefreshControl = UIRefreshControl()
    let commentBar = MessageInputBar()
    let loadingView: UIView = UIView()
    let center = NotificationCenter.default
    let zoomAnimation = AnimationType.zoom(scale: 0.1)
    var numberOfPost: Int!
    var showsCommentbar = false
    var selectedPost: PFObject!
    var spinner = UIActivityIndicatorView()
    var posts = [PFObject]()
    
    
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.keyboardDismissMode = .interactive
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
        self.tableView.tableFooterView = UIView()
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
       
        
        commentBar.inputTextView.text = "Add A Comment"
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        commentBar.inputTextView.textColor =  UIColor.black
        
        myrefreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.refreshControl = myrefreshControl
        
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        DataRequest.addAcceptableImageContentTypes(["application/octet-stream"])
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshPost(fromWhere: 1)
    }
    
    
   // MARK: -  Comments & Queries
    
  
    func refreshPost(fromWhere: Int){
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
                    
                    if fromWhere == 1 {
                    let cells = self.tableView.visibleCells
                    UIView.animate(views: cells, animations: [self.zoomAnimation])
                    }
                    
                    self.hideActivityIndicator(uiView: self.view)
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
    
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String){
        
                let comment = PFObject(className: "Comments")
                comment["text"] = text
                comment["post"] = selectedPost
                comment["author"] = PFUser.current()!
        
                selectedPost.add(comment, forKey: "comments")
        
                selectedPost.saveInBackground{(success, error) in
                    if success {
                        print("comment saved")
                    }else{
                        print("error")
                    }
        
                }
        
        refreshPost(fromWhere: 2)
        showsCommentbar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    @objc func onRefresh() {
        refreshPost(fromWhere: 2)
    }
    
    
     // MARK: -  Table View
    
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
            
       
              if user["profilePicture"] != nil{
                          let imagefile = user["profilePicture"] as! PFFileObject
                          let urlString = imagefile.url!
                          let url = URL(string: urlString)!
                          cell.profilePictureView.af_setImage(withURL: url)
                      }
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
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == comments.count + 1 {
          showsCommentbar = true
          self.becomeFirstResponder()
          commentBar.inputTextView.becomeFirstResponder()
            
            selectedPost = post
        }
    }
    
    // MARK: - Table View Loading Spinner
    func showActivityIndicatory(uiView: UIView) {

        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.clear.withAlphaComponent(0.5)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10

        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        actInd.style = UIActivityIndicatorView.Style.large
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2,
                                y: loadingView.frame.size.height / 2);
        loadingView.addSubview(actInd)
        uiView.addSubview(loadingView)
        actInd.startAnimating()
    }
  
    
    func hideActivityIndicator(uiView: UIView) {
        spinner.stopAnimating()
        loadingView.isHidden = true
    }
    
    // MARK: -  Empty Table View, View
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "No Post?😞"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Tap Below."
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    

    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        let str = "Refresh"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        showActivityIndicatory(uiView: self.view)
        onRefresh()
    }
    
    
    
    
    // MARK: - Input Acessory Pod
    @objc func keyboardWillBeHidden(note: Notification){
        commentBar.inputTextView.text = nil
        showsCommentbar = false
        becomeFirstResponder()
        
    }
    override var inputAccessoryView: UIView?{
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool{
        return showsCommentbar
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
