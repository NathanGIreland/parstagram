//
//  SignUpViewController.swift
//  parstagram
//
//  Created by Nathan Ireland on 11/13/19.
//  Copyright © 2019 Nathan Ireland. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameFieldsignup: UITextField!
    @IBOutlet weak var passwordFieldsignup: UITextField!
    @IBOutlet weak var inUselbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inUselbl.text = "Username in use"
        inUselbl.textColor = UIColor.red

        // Do any additional setup after loading the view.
    }
    
        @IBAction func onSignUp(_ sender: Any) {
            let user = PFUser()
            user.username = usernameFieldsignup.text
            user.password = passwordFieldsignup.text
    
            user.signUpInBackground{(success, error) in
                if success {
                    self.inUselbl.isHidden = true
                    self.performSegue(withIdentifier: "SignupSegue", sender: nil)
                }else{
                    print("Error: \(String(describing: error))")
                    self.inUselbl.isHidden = false
                    
                }
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
