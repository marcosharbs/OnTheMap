//
//  ViewController.swift
//  OnTheMap
//
//  Created by Marcos Harbs on 07/07/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UdacityClient.client.login(username: "marcos.harbs@gmail.com", password: "mharbs88") { error in
            if let error = error as NSError? {
                let alertController = UIAlertController(title: "Error", message:
                    error.userInfo["message"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
            print(UdacityClient.client.sessionId!)
            print(UdacityClient.client.accountKey!)
            print(UdacityClient.client.firstName!)
            print(UdacityClient.client.lastName!)
            
            /*ParseUdacityClient.client.getLoggedStudentLocation(completionHandler: { student, error in
                print(student!)
            })*/
        }
        /*ParseUdacityClient.client.getStudentsLocations { studentsLocations, error in
            print(studentsLocations!)
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

