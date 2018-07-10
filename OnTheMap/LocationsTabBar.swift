//
//  LocationsTabBar.swift
//  OnTheMap
//
//  Created by Marcos Harbs on 10/07/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

import UIKit

class LocationsTabBar: UITabBarController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadStudentsLocations()
    }
    
    func loadStudentsLocations() {
        ParseUdacityClient.client.getStudentsLocations { studentsLocations, error in
            guard error == nil else {
                self.showError(error! as NSError)
                return
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.studentsLocations = studentsLocations!
        }
    }
    
}
