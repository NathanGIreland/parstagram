//
//  CameraViewController.swift
//  parstagram
//
//  Created by Nathan Ireland on 11/9/19.
//  Copyright © 2019 Nathan Ireland. All rights reserved.
//

import UIKit
import AlamofireImage
import CoreLocation
import Parse

class CameraViewController:  UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var locationLbl: UILabel!
    
    var locationManager = CLLocationManager()
    
     let geocoder = CLGeocoder()
     var userCity = ""
     var userState = ""
    var pickedLocation = ""
    var chosenLocFromSeg = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if CLLocationManager.locationServicesEnabled(){
                   locationManager.delegate = self
                   locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                   locationManager.startUpdatingLocation()
               }else{
        }
        
        locationLbl.text = ""
        
        submitBtn.isEnabled  =  true
    
        //self.locationManager.startUpdatingLocation()
        
       
        
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func onSubmit(_ sender: Any) {
        print("hello from on submit")
        submitBtn.isEnabled  =  false
       let post = PFObject(className: "Post")
        
        post["caption"] = commentField.text
        post["author"] = PFUser.current()!
        
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        post["image"] = file
        post["locations"] = locationLbl.text
        
        post.saveInBackground{(success, error) in
            if success{
                self.dismiss(animated: true, completion: nil)
                print("saved!")
            }else{
                print("error!")
            }
        }

        
        
    }
    
    
    @IBAction func onCameraBtn(_ sender: Any) {
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
        let size = CGSize(width: 375, height: 375)
        let scaledImage = image.af_imageScaled(to: size)
        
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
  
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
       
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

            
            geocoder.reverseGeocodeLocation(locations.last!, completionHandler: { (placemarks, error) -> Void in

            // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
           
                self.userCity = placeMark.locality! as String
                self.userState = placeMark.administrativeArea! as String
                print(self.userCity)
                self.locationManager.stopUpdatingLocation()

           })
            
        }
        

      
        
        
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "moveToMap"{
    //            let locationsVC = segue.destination as! LocationPickerViewController
    //            locationsVC.userCity = userCity
    //        }
    //    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
              
        
        let nav = segue.destination as! UINavigationController
        let lvc = nav.topViewController as! LocationPickerViewController
        
        lvc.userCity = self.userCity
        lvc.userState = self.userState
        
                
        }
    
    func changeLabel(){
        
        locationLbl.text = chosenLocFromSeg
        
        
    }
    
    @IBAction func unwindToCamera(_ Sender: UIStoryboardSegue){
        let backVC = Sender.source as? LocationPickerViewController
        locationLbl.text = backVC?.chosenLoc
        print(backVC?.chosenLoc as Any)
        
    }

    
}
