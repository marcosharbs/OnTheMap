//
//  AddLocationVC.swift
//  OnTheMap
//
//  Created by Marcos Harbs on 15/07/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

import UIKit
import MapKit

class AddLocationVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var studentLocation: StudentLocation!
    var overwrite: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Location"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.drawLocation()
    }
    
    @IBAction func onFinish(_ sender: Any) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        ParseUdacityClient.client.postStudentLocation(student: self.studentLocation, overwrite: self.overwrite) { error in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            guard error == nil else {
                self.showError(error! as NSError)
                return
            }
            
            ParseUdacityClient.client.getStudentsLocations { studentsLocations, error in
                guard error == nil else {
                    self.showError(error! as NSError)
                    return
                }
                
                SharedData.shared.setStudentesLocations(studentsLocations: studentsLocations!)
                
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    func drawLocation() {
        let lat = CLLocationDegrees(self.studentLocation.latitude ?? 0)
        let long = CLLocationDegrees(self.studentLocation.longitude ?? 0)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = self.studentLocation.mapString ?? ""
        
        self.mapView.addAnnotations([annotation])
        
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        self.mapView.setRegion(region, animated: false)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
}
