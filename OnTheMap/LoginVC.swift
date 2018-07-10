//
//  ViewController.swift
//  OnTheMap
//
//  Created by Marcos Harbs on 07/07/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func onLogin(_ sender: Any) {
        UdacityClient.client.login(username: emailField.text!, password: passwordField.text!) { error in
            guard error == nil else {
                self.showError(error! as NSError)
                return
            }
            
            let locationsTabBar = self.storyboard!.instantiateViewController(withIdentifier: "LocationsTabBar") as! UITabBarController
            self.present(locationsTabBar, animated: true, completion: nil)
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.udacity.com/account/auth#!/signup")!, options: [:], completionHandler: nil)
    }
    
}

