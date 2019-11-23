//
//  LocationPickerViewController.swift
//  parstagram
//
//  Created by Nathan Ireland on 11/21/19.
//  Copyright © 2019 Nathan Ireland. All rights reserved.
//

import UIKit

class LocationPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var locations: NSArray = []
    
    var userCity = ""
    var userState = ""
    var chosenLoc = ""
   
    
    let CLIENT_ID = "QA1L0Z0ZNA2QVEEDHFPQWK0I5F1DE3GPLSNW4BZEBGJXUCFL"
       let CLIENT_SECRET = "W2AOE1TYC4MHK5SZYOUGX0J3LVRALMPB4CXT3ZH21ZCPUMCU"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
               tableView.dataSource = self
               tableView.delegate = self
               searchBar.delegate = self
        searchBar.placeholder = "Enter Photo's Location ..."
                 fetchLocations(userCity)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onAdd(_ sender: Any) {
        chosenLoc = chosenLoc as String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationsCell") as! SearchLocationsTableViewCell
        
        cell.location = locations[(indexPath as NSIndexPath).row] as? NSDictionary
        
        return cell
    }
    
    //What to do when cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // This is the selected venue
        let venue = locations[(indexPath as NSIndexPath).row] as! NSDictionary

        
        chosenLoc = venue.value(forKeyPath: "name") as! String
       
        
        /*-------TODO--------*/
        //Set the latitude and longitude of the venue and send it to the protocol
        
        // Return to the PhotoMapViewController with the lat and lng of venue
        
     
       // print(chosenLoc)
    

    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = NSString(string: searchBar.text!).replacingCharacters(in: range, with: text)
        fetchLocations(newText)
        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchLocations(searchBar.text!)
    }
    
    func fetchLocations(_ query: String) {
        
        let baseUrlString = "https://api.foursquare.com/v2/venues/search?"
        let queryString = "client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)&v=20141020&near=\(userCity),\(userState)&query=\(query)"


        let url = URL(string: baseUrlString + queryString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
        let request = URLRequest(url: url)

        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            self.locations = responseDictionary.value(forKeyPath: "response.venues") as! NSArray
                            self.tableView.reloadData()

                    }
                }
        });
        task.resume()
    }


    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backVC = segue.destination as! CameraViewController //backVC is a reference to ViewController
        
        
        
        backVC.pickedLocation = chosenLoc
    }

}
