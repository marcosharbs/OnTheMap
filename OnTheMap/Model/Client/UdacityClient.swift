//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Marcos Harbs on 07/07/18.
//  Copyright © 2018 Marcos Harbs. All rights reserved.
//

import Foundation

class UdacityClient {
    
    static let client = UdacityClient()
    
    var session = URLSession.shared
    
    var sessionId: String? = ""
    var accountKey: String? = ""
    var firstName: String? = ""
    var lastName: String? = ""
    
    func getUserInfos(userId: String, completionHandler: @escaping (_ error: Error?) -> Void) {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + Methods.Users + "/\(userId)"
        
        let request = NSMutableURLRequest(url: components.url!)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completionHandler(error)
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject
            } catch {
                completionHandler(NSError(domain: "login", code: 1, userInfo: nil))
            }
            
            if let userObj = parsedResult[BodyKeys.User] as AnyObject?,
                let firstName = userObj[BodyKeys.FirstName],
                let lastName = userObj[BodyKeys.LastName] {
                
                self.firstName = firstName as? String
                self.lastName = lastName as? String
            }
            
            completionHandler(nil)
        }
        task.resume()
    }
    
    func login(username: String, password: String, completionHandler: @escaping (_ error: Error?) -> Void) {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + Methods.Login

        let request = NSMutableURLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"\(Parameters.Username)\": \"\(username)\", \"\(Parameters.Password)\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
           
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject
            } catch {
                DispatchQueue.main.async {
                    completionHandler(NSError(domain: "login", code: 1, userInfo: nil))
                }
                return
            }
            
            if let responseError = parsedResult["error"], responseError != nil  {
                DispatchQueue.main.async {
                    completionHandler(NSError(domain: "login", code: 2, userInfo: [NSLocalizedDescriptionKey: responseError!]))
                }
                return
            }
            
            if let sessionObj = parsedResult[BodyKeys.Session] as AnyObject?,
                let sessionId = sessionObj[BodyKeys.Id] {
                self.sessionId = sessionId as? String
            }
            
            if let accountObj = parsedResult[BodyKeys.Account] as AnyObject?,
                let accountKey = accountObj[BodyKeys.Key] {
                self.accountKey = accountKey as? String
            }
            
            self.getUserInfos(userId: self.accountKey!, completionHandler: { error in
                DispatchQueue.main.async {
                    completionHandler(error)
                }
            })
        }
        task.resume()
    }
    
}
