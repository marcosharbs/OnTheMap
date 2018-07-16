//
//  SharedData.swift
//  OnTheMap
//
//  Created by Marcos Harbs on 16/07/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

import Foundation

class SharedData {
    
    static let shared = SharedData()
    
    var studentsLocations = [StudentLocation]()
    
    var dataLoadedProtocols = [OnDataLoadProtocol]()
    
    func addDataLoadedProtocol(loadProtocol: OnDataLoadProtocol) {
        self.dataLoadedProtocols.append(loadProtocol);
    }
    
    func setStudentesLocations(studentsLocations: [StudentLocation]) {
        self.studentsLocations = studentsLocations
        
        for loadProtocol in self.dataLoadedProtocols {
            loadProtocol.onDataLoaded(studentsLocations: self.studentsLocations)
        }
    }
    
}

protocol OnDataLoadProtocol {
    
    func onDataLoaded(studentsLocations: [StudentLocation])
    
}
