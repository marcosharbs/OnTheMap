//
//  LocationsNC.swift
//  OnTheMap
//
//  Created by Marcos Harbs on 14/07/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

import UIKit

class LocationsNC: UINavigationController {
    
    var objectId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.topItem?.title = "On The Map"
        self.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(onLogout))
        self.navigationBar.topItem?.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAdd)), UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(onRefresh))]
    }
    
    @objc func onLogout() {
        UdacityClient.client.logout {error in
            guard error == nil else {
                self.showError(error! as NSError)
                return
            }
            
            SharedData.shared.studentsLocations.removeAll()
            
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc func onRefresh() {
        ParseUdacityClient.client.getStudentsLocations { studentsLocations, error in
            guard error == nil else {
                self.showError(error! as NSError)
                return
            }
            
            SharedData.shared.setStudentesLocations(studentsLocations: studentsLocations!)
        }
    }
    
    @objc func onAdd() {
        ParseUdacityClient.client.getLoggedStudentLocation { studentLocation, error in
            guard error == nil else {
                self.showError(error! as NSError)
                return
            }
            
            if studentLocation != nil && studentLocation?.objectId != nil {
                self.objectId = studentLocation?.objectId
                let alertController = UIAlertController(title: "", message: "User \"\(studentLocation?.firstName ?? "") \(studentLocation?.lastName ?? "")\" Has Already Posted a Student Location. Would You Like to Overwrite Their Location?", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default,handler: self.overrideLocation))
                alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            } else {
                let findLocationVC = self.storyboard!.instantiateViewController(withIdentifier: "FindLocationVC") as! FindLocationVC
                findLocationVC.overwrite = false
                self.tabBarController?.tabBar.isHidden = true
                self.pushViewController(findLocationVC, animated: true)
            }
        }
    }
    
    func overrideLocation(_ action: UIAlertAction) {
        let findLocationVC = self.storyboard!.instantiateViewController(withIdentifier: "FindLocationVC") as! FindLocationVC
        findLocationVC.overwrite = true
        findLocationVC.objectId = self.objectId
        self.tabBarController?.tabBar.isHidden = true
        self.pushViewController(findLocationVC, animated: true)
    }
    
}
