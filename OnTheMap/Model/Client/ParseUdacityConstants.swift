//
//  ParseUdacityConstants.swift
//  OnTheMap
//
//  Created by Marcos Harbs on 07/07/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

import Foundation

extension ParseUdacityClient {
    
    struct Constants {
        static let ApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes/StudentLocation"
        static let ApplicationJson = "application/json"
    }
    
    struct HeaderKeys {
        static let PaserApplicationId = "X-Parse-Application-Id"
        static let ParserRestKey = "X-Parse-REST-API-Key"
        static let ContentType = "Content-Type"
    }
    
    struct ResponseKeys {
        static let Results = "results"
    }
    
    struct BodyKeys {
        static let CreatedAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
    }
    
}
