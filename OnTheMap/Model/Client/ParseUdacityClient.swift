//
//  ParseUdacityClient.swift
//  OnTheMap
//
//  Created by Marcos Harbs on 07/07/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

import Foundation


class ParseUdacityClient {
    
    static let client = ParseUdacityClient()
    
    var session = URLSession.shared
    
    func changeStudentLocation(student: StudentLocation, completionHandler: @escaping (_ error: Error?) -> Void) {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath
        
        let request = NSMutableURLRequest(url: components.url!)
        request.httpMethod = "PUT"
        request.addValue(Constants.ApplicationId, forHTTPHeaderField: HeaderKeys.PaserApplicationId)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: HeaderKeys.ParserRestKey)
        request.addValue(Constants.ApplicationJson, forHTTPHeaderField: HeaderKeys.ContentType)
        request.httpBody = "{\"uniqueKey\": \"\(student.uniqueKey!)\", \"firstName\": \"\(student.firstName!)\", \"lastName\": \"\(student.lastName!)\",\"mapString\": \"\(student.mapString!)\", \"mediaURL\": \"\(student.mediaURL!)\",\"latitude\": \(student.latitude!), \"longitude\": \(student.longitude!)}".data(using: String.Encoding.utf8)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completionHandler(error)
                return
            }
            completionHandler(nil)
        }
        task.resume()
    }
    
    func postStudentLocation(student: StudentLocation, completionHandler: @escaping (_ error: Error?) -> Void) {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath
        
        let request = NSMutableURLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.addValue(Constants.ApplicationId, forHTTPHeaderField: HeaderKeys.PaserApplicationId)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: HeaderKeys.ParserRestKey)
        request.addValue(Constants.ApplicationJson, forHTTPHeaderField: HeaderKeys.ContentType)
        request.httpBody = "{\"uniqueKey\": \"\(student.uniqueKey!)\", \"firstName\": \"\(student.firstName!)\", \"lastName\": \"\(student.lastName!)\",\"mapString\": \"\(student.mapString!)\", \"mediaURL\": \"\(student.mediaURL!)\",\"latitude\": \(student.latitude!), \"longitude\": \(student.longitude!)}".data(using: String.Encoding.utf8)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completionHandler(error)
                return
            }
            completionHandler(nil)
        }
        task.resume()
    }
    
    func getLoggedStudentLocation(completionHandler: @escaping (_ studentLocation: StudentLocation?, _ error: Error?) -> Void) {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath
        components.queryItems = [URLQueryItem(name: "where", value: "{\"uniqueKey\":\"\(UdacityClient.client.accountKey!)\"}")]
        
        let request = NSMutableURLRequest(url: components.url!)
        request.addValue(Constants.ApplicationId, forHTTPHeaderField: HeaderKeys.PaserApplicationId)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: HeaderKeys.ParserRestKey)
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completionHandler(nil, error)
                return
            }
            
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
            } catch {
                completionHandler(nil, NSError(domain: "getStudentsLocations", code: 1, userInfo: nil))
            }
            
            if let results = parsedResult[ResponseKeys.Results] as? [[String:AnyObject]] {
                var studentesLocations = [StudentLocation]()
                for result in results {
                    studentesLocations.append(StudentLocation(dictionary: result))
                }
                if(studentesLocations.count > 0) {
                    completionHandler(studentesLocations[0], nil)
                } else {
                    completionHandler(StudentLocation(), nil)
                }
            } else {
                completionHandler(nil, NSError(domain: "getStudentsLocations", code: 2, userInfo: nil))
            }
        }
        task.resume()
    }
    
    func getStudentsLocations(completionHandler: @escaping (_ studentsLocations: [StudentLocation]?, _ error: Error?) -> Void) {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath
        
        let request = NSMutableURLRequest(url: components.url!)
        request.addValue(Constants.ApplicationId, forHTTPHeaderField: HeaderKeys.PaserApplicationId)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: HeaderKeys.ParserRestKey)
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completionHandler(nil, error)
                return
            }
            
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
            } catch {
                completionHandler(nil, NSError(domain: "getStudentsLocations", code: 1, userInfo: nil))
            }
            
            if let results = parsedResult[ResponseKeys.Results] as? [[String:AnyObject]] {
                var studentesLocations = [StudentLocation]()
                for result in results {
                    studentesLocations.append(StudentLocation(dictionary: result))
                }
                completionHandler(studentesLocations, nil)
            } else {
                completionHandler(nil, NSError(domain: "getStudentsLocations", code: 2, userInfo: nil))
            }
        }
        task.resume()
    }
    
}
