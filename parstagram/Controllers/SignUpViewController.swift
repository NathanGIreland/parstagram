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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
           view.addGestureRecognizer(tap)
                   // Do any additional setup after loading the view.
    }
    
        @IBAction func onSignUp(_ sender: Any) {
            let user = PFUser()
            user.username = usernameFieldsignup.text
            user.password = passwordFieldsignup.text
            
            let imageData = UIImage(named: "image_placeholder")?.pngData()
            let file = PFFileObject(data: imageData!)
            user.setObject(file!, forKey: "profilePicture")

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
