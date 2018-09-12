//
//  NetworkClient.swift
//  OnTheMap
//
//  Created by Al Manigsaca on 9/11/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import Foundation

class NetworkClient: NSObject {

    var session = URLSession.shared
    static let shared = NetworkClient()
    
    override init() {
        super.init()
    }
    
    func doGetUserId(username: String, password: String, completion: @escaping (_ data: [String: AnyObject]?, _ error : String?) -> Void) {
        networkRequest(requestUserId(username: username, password: password), isUdacity: true, completion: completion)
    }
    
    func doGetUserInformation(userId: String, completion: @escaping (_ data: [String: AnyObject]?, _ error : String?) -> Void) {
        networkRequest(requestUserInformation(userId: userId), isUdacity: true, completion: completion)
    }
    
    func doGetStudentLocations(completion: @escaping (_ data: [String: AnyObject]?, _ error : String?) -> Void) {
        networkRequest(requestStudentLocations(), isUdacity: false, completion: completion)
    }
    
    func doPostStudentLocation(userId: String?, firstName: String?, lastName: String?, locationName: String?, linkAddress: String?, latitude: Double?, longitude: Double?, completion: @escaping (_ data: [String: AnyObject]?, _ error : String?) -> Void) {
        networkRequest(requestStudentLocationCreate(userId: userId, firstName: firstName, lastName: lastName, locationName: locationName, linkAddress: linkAddress, latitude: latitude, longitude: longitude), isUdacity: false, completion: completion)
    }
    
    func doPutStudentLocation(objectId: String?, userId: String?, firstName: String?, lastName: String?, locationName: String?, linkAddress: String?, latitude: Double?, longitude: Double?, completion: @escaping (_ data: [String: AnyObject]?, _ error : String?) -> Void) {
        networkRequest(requestStudentLocationUpdate(objectId: objectId, userId: userId, firstName: firstName, lastName: lastName, locationName: locationName, linkAddress: linkAddress, latitude: latitude, longitude: longitude), isUdacity: false, completion: completion)
    }
    
    func doGetUser(userId: String?, completion: @escaping (_ data: [String: AnyObject]?, _ error : String?) -> Void) {
        networkRequest(requestCheckUser(userId: userId), isUdacity: false, completion: completion)
    }

    func doLogout(completion: @escaping (_ data: [String: AnyObject]?, _ error : String?) -> Void) {
        networkRequest(requestLogout(), isUdacity: true, completion: completion)
    }
    
    //MARK: - Private Network Functions
    private func networkRequest(_ request: URLRequest, isUdacity: Bool, completion: @escaping (_ data: [String: AnyObject]?, _ error : String?) -> Void) {

        let task = session.dataTask(with: request) { data, response, error in
            
            func sendError(_ error: String) {
                print(error)
                performUIUpdatesOnMain {
                    completion(nil, error)
                }
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request.")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            var newData = data
            
            if isUdacity {
            
                let range = Range(5..<data.count)
                newData = data.subdata(in: range) /* subset response data! */
            
            }
            
            let parsedResult: [String:AnyObject]!
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            } catch {
                sendError("Could not parse the data as JSON.")
                return
            }
            
            performUIUpdatesOnMain {
                completion(parsedResult, nil)
            }
        }
        task.resume()
    } 
}
