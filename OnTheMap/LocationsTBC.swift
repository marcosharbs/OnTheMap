//
//  LocationsTBC.swift
//  OnTheMap
//
//  Created by Marcos Harbs on 10/07/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

import UIKit

class LocationsTBC: UITableViewController, OnDataLoadProtocol {
    
    var allLocations: [StudentLocation]!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.allLocations = appDelegate.studentsLocations
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.addDataLoadedProtocol(loadProtocol: self)
    }
    
    func onDataLoaded(studentsLocations: [StudentLocation]) {
        self.allLocations = studentsLocations
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let locations = allLocations {
            return locations.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell")!
        let location = self.allLocations[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = (location.firstName ?? "") + " " + (location.lastName ?? "")
        cell.detailTextLabel?.text = location.mediaURL
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = self.allLocations[indexPath.row]
        UIApplication.shared.open(URL(string: location.mediaURL ?? "")!, options: [:], completionHandler: nil)
    }
    
}
