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
    
    func postStudentLocation(student: StudentLocation, overwrite: Bool, completionHandler: @escaping (_ error: Error?) -> Void) {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = overwrite ? Constants.ApiPath + "/\(student.objectId!)" : Constants.ApiPath
 
        let request = NSMutableURLRequest(url: components.url!)
        request.httpMethod = overwrite ? "PUT" : "POST"
        request.addValue(Constants.ApplicationId, forHTTPHeaderField: HeaderKeys.PaserApplicationId)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: HeaderKeys.ParserRestKey)
        request.addValue(Constants.ApplicationJson, forHTTPHeaderField: HeaderKeys.ContentType)
        request.httpBody = "{\"uniqueKey\": \"\(student.uniqueKey!)\", \"firstName\": \"\(student.firstName!)\", \"lastName\": \"\(student.lastName!)\",\"mapString\": \"\(student.mapString!)\", \"mediaURL\": \"\(student.mediaURL!)\",\"latitude\": \(student.latitude!), \"longitude\": \(student.longitude!)}".data(using: String.Encoding.utf8)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(nil)
            }
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
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil, NSError(domain: "getStudentsLocations", code: 1, userInfo: nil))
                }
            }
            
            if let results = parsedResult[ResponseKeys.Results] as? [[String:AnyObject]] {
                var studentesLocations = [StudentLocation]()
                for result in results {
                    studentesLocations.append(StudentLocation(dictionary: result))
                }
                if(studentesLocations.count > 0) {
                    DispatchQueue.main.async {
                        completionHandler(studentesLocations[0], nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completionHandler(StudentLocation(), nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(nil, NSError(domain: "getStudentsLocations", code: 2, userInfo: nil))
                }
            }
        }
        task.resume()
    }
    
    func getStudentsLocations(completionHandler: @escaping (_ studentsLocations: [StudentLocation]?, _ error: Error?) -> Void) {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath
        components.queryItems = [URLQueryItem(name: "order", value: "-updatedAt"), URLQueryItem(name: "limit", value: "500")]
        
        let request = NSMutableURLRequest(url: components.url!)
        request.addValue(Constants.ApplicationId, forHTTPHeaderField: HeaderKeys.PaserApplicationId)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: HeaderKeys.ParserRestKey)
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil, NSError(domain: "getStudentsLocations", code: 1, userInfo: nil))
                }
            }
            
            if let results = parsedResult[ResponseKeys.Results] as? [[String:AnyObject]] {
                var studentesLocations = [StudentLocation]()
                for result in results {
                    studentesLocations.append(StudentLocation(dictionary: result))
                }
                DispatchQueue.main.async {
                    completionHandler(studentesLocations, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(nil, NSError(domain: "getStudentsLocations", code: 2, userInfo: nil))
                }
            }
        }
        task.resume()
    }
    
}
