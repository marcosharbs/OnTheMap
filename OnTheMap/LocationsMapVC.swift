//
//  LocationsMVC.swift
//  OnTheMap
//
//  Created by Marcos Harbs on 11/07/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

import UIKit
import MapKit

class LocationsMapVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var allLocations: [StudentLocation]!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.allLocations = appDelegate.studentsLocations
        self.drawLocationsOnMap()
    }
    
    func drawLocationsOnMap() {
        if let locations = self.allLocations {
            var annotations = [MKPointAnnotation]()
            
            for location in locations {
                let lat = CLLocationDegrees(location.latitude ?? 0)
                let long = CLLocationDegrees(location.longitude ?? 0)
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(location.firstName ?? "") \(location.lastName ?? "")"
                annotation.subtitle = location.mediaURL
                
                annotations.append(annotation)
            }
            
            self.mapView.addAnnotations(annotations)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
}
