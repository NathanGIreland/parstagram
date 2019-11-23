//
//  ProfileCameraViewController.swift
//  parstagram
//
//  Created by Nathan Ireland on 11/14/19.
//  Copyright © 2019 Nathan Ireland. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class ProfileCameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let user = PFUser.current()
    @IBOutlet weak var profileSetImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmit(_ sender: Any) {
    
        let imageData = profileSetImageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
      
        
        user!.setObject(file!, forKey: "profilePicture")
        
        user!.saveInBackground{(success, error) in
            if success{
                self.dismiss(animated: true, completion: nil)
                print("saved!")
            }else{
                print("error!")
            }
        }
        
    }
    
    
    
    @IBAction func onImageSetTap(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        }else{
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
           print("hello from on picker btn")
           let image = info[.editedImage] as! UIImage
           let size = CGSize(width: 326, height: 326)
           let scaledImage = image.af_imageScaled(to: size)
           
           profileSetImageView.image = scaledImage
           
           dismiss(animated: true, completion: nil)
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
