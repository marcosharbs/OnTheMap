//
//  FindLocationVC.swift
//  OnTheMap
//
//  Created by Marcos Harbs on 14/07/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

import UIKit
import CoreLocation

class FindLocationVC: UIViewController {
    
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var websiteText: UITextField!
    
    var overwrite: Bool!
    var objectId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Location"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(onCancel))
    }
    
    @IBAction func onFindLocation(_ sender: Any) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(self.addressText.text!) { (placemarks, error) in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    let alertController = UIAlertController(title: "Error", message: "Location Not Found!", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return
            }
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            let name = placemarks.first?.name

            let addLocationVC = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationVC") as! AddLocationVC
            
            var studentLocation = StudentLocation()
            studentLocation.objectId = self.objectId
            studentLocation.uniqueKey = UdacityClient.client.accountKey
            studentLocation.firstName = UdacityClient.client.firstName
            studentLocation.lastName = UdacityClient.client.lastName
            studentLocation.mapString = name
            studentLocation.mediaURL = self.websiteText.text!
            studentLocation.latitude = lat
            studentLocation.longitude = lon
            
            addLocationVC.overwrite = self.overwrite
            addLocationVC.studentLocation = studentLocation
            
            self.navigationController?.pushViewController(addLocationVC, animated: true)
        }
    }
    
    @objc func onCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
