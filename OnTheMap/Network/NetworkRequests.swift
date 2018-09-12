//
//  NetworkRequests.swift
//  OnTheMap
//
//  Created by Al Manigsaca on 9/11/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import Foundation

extension NetworkClient {
    
    //MARK: - URL Requests
    func requestUserId(username: String, password : String) -> URLRequest {
        
        // Build HTTP Request, no query parameters
        var request = URLRequest(url: udacityURLFromParameters(withPath: "/api/session"))
        
        request.httpMethod = Constants.ACCOUNT.MethodPost
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"\(Constants.ACCOUNT.UdacityKey)\": {\"\(Constants.ACCOUNT.UsernameKey)\": \"\(username)\", \"\(Constants.ACCOUNT.PasswordKey)\": \"\(password)\"}}".data(using: .utf8)
        
        return request
    }
    
    func requestUserInformation(userId: String) -> URLRequest {
        return URLRequest(url: udacityURLFromParameters(withPath: "/api/users/\(userId)"))
    }
    
    func requestStudentLocations() -> URLRequest {
        
        let methodParameters = [
            Constants.LOCATION.ParameterKeys.Limit: Constants.LOCATION.ParameterValues.Limit,
            Constants.PARSE.Order: Constants.PARSE.UpdatedAt
        ]
        
        var request = URLRequest(url: parseURLFromParameters(parameters: methodParameters as [String:AnyObject], withPath:"/parse/classes/StudentLocation"))
        
        request.addValue(Constants.PARSE.ParseApiId     , forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.PARSE.ParseRestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        return request
    }
    
    func requestStudentLocationCreate(userId: String?, firstName: String?, lastName: String?, locationName: String?, linkAddress: String?, latitude: Double?, longitude: Double?) -> URLRequest {
        
        var request = URLRequest(url: parseURLFromParameters(withPath: "/parse/classes/StudentLocation"))
        request.httpMethod = Constants.LOCATION.HTTP.MethodPost
        
        request.addValue(Constants.PARSE.ParseApiId     , forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.PARSE.ParseRestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"\(Constants.LOCATION.ParameterKeys.UniqueKey)\": \"\(userId!)\", \"\(Constants.LOCATION.ParameterKeys.Firstname)\": \"\(firstName!)\", \"\(Constants.LOCATION.ParameterKeys.Lastname)\": \"\(lastName!)\",\"\(Constants.LOCATION.ParameterKeys.MapString)\": \"\(locationName!)\", \"\(Constants.LOCATION.ParameterKeys.MediaURL)\": \"\(linkAddress!)\",\"\(Constants.LOCATION.ParameterKeys.Latitude)\": \(latitude!), \"\(Constants.LOCATION.ParameterKeys.Longitude)\": \(longitude!)}".data(using: .utf8)
        
        return request
    }
    
    func requestStudentLocationUpdate(objectId: String?, userId: String?, firstName: String?, lastName: String?, locationName: String?, linkAddress: String?, latitude: Double?, longitude: Double?) -> URLRequest {
        
        var request = URLRequest(url: parseURLFromParameters(withPath: "/parse/classes/StudentLocation/\(objectId!)"))
        request.httpMethod = Constants.LOCATION.HTTP.MethodPut
        
        request.addValue(Constants.PARSE.ParseApiId     , forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.PARSE.ParseRestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"\(Constants.LOCATION.ParameterKeys.UniqueKey)\": \"\(userId!)\", \"\(Constants.LOCATION.ParameterKeys.Firstname)\": \"\(firstName!)\", \"\(Constants.LOCATION.ParameterKeys.Lastname)\": \"\(lastName!)\",\"\(Constants.LOCATION.ParameterKeys.MapString)\": \"\(locationName!)\", \"\(Constants.LOCATION.ParameterKeys.MediaURL)\": \"\(linkAddress!)\",\"\(Constants.LOCATION.ParameterKeys.Latitude)\": \(latitude!), \"\(Constants.LOCATION.ParameterKeys.Longitude)\": \(longitude!)}".data(using: .utf8)
        
        return request
    }
    
    func requestCheckUser(userId: String?) -> URLRequest {
        
        let methodParameters = [
            Constants.LOCATION.ParameterKeys.Where: "{\"uniqueKey\":\"\(userId!)\"}"
        ]
        
        var request  = URLRequest(url: parseURLFromParameters(parameters: methodParameters as [String:AnyObject], withPath: "/parse/classes/StudentLocation"))
        
        request.addValue(Constants.PARSE.ParseApiId     , forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.PARSE.ParseRestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        return request
    }
    
    func requestLogout() -> URLRequest {
        var request = URLRequest(url: udacityURLFromParameters(withPath: "/api/session"))
        
        request.httpMethod = Constants.ACCOUNT.MethodDelete
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        return request
    }
}
