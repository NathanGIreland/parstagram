//
//  LoginViewController.swift
//  parstagram
//
//  Created by Nathan Ireland on 11/9/19.
//  Copyright © 2019 Nathan Ireland. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameFieldlogin: UITextField!
    @IBOutlet weak var passwordFieldlogin: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
           view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func onLogin(_ sender: Any) {
        let username = usernameFieldlogin.text!
        let password = passwordFieldlogin.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password)
          { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }else{
               print("Error: \(String(describing: error))")
            }
        }
    }
    
    @objc func dismissKeyboard() {
                  //Causes the view (or one of its embedded text fields) to resign the first responder status.
                  view.endEditing(true)
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
