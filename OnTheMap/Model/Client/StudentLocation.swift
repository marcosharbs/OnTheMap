//
//  UserLocation.swift
//  OnTheMap
//
//  Created by Marcos Harbs on 07/07/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Float?
    var longitude: Float?
    
    init(dictionary: [String:AnyObject]) {
        self.objectId = dictionary[ParseUdacityClient.BodyKeys.ObjectId] as? String
        self.uniqueKey = dictionary[ParseUdacityClient.BodyKeys.UniqueKey] as? String
        self.firstName = dictionary[ParseUdacityClient.BodyKeys.FirstName] as? String
        self.lastName = dictionary[ParseUdacityClient.BodyKeys.LastName] as? String
        self.mapString = dictionary[ParseUdacityClient.BodyKeys.MapString] as? String
        self.mediaURL = dictionary[ParseUdacityClient.BodyKeys.MediaURL] as? String
        self.latitude = (dictionary[ParseUdacityClient.BodyKeys.ObjectId] as? NSString)?.floatValue
        self.longitude = (dictionary[ParseUdacityClient.BodyKeys.ObjectId] as? NSString)?.floatValue
    }
    
    init(){}
    
}
