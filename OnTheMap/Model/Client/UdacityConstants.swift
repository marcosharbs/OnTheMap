//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Marcos Harbs on 07/07/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

extension UdacityClient {
    
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    struct Methods {
        static let Login = "/session"
        static let Users = "/users"
    }
    
    struct Parameters {
        static let Username = "username"
        static let Password = "password"
    }
    
    struct BodyKeys {
        static let Account = "account"
        static let Key = "key"
        static let Session = "session"
        static let Id = "id"
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
    }
    
}
