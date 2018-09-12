//
//  NetworkURLFunctions.swift
//  OnTheMap
//
//  Created by Al Manigsaca on 9/11/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import Foundation

extension NetworkClient {
    
    func udacityURLFromParameters(withPath: String? = nil) -> URL {
        
        var components = URLComponents()
        
        components.scheme = Constants.UDACITY.ApiScheme
        components.host   = Constants.UDACITY.ApiHost
        components.path   = withPath ?? ""
        
        return components.url!
    }
    
    func udacityURLFromParameters(parameters: [String:AnyObject], withPath: String? = nil) -> URL {
        
        var components = URLComponents()
        
        components.scheme = Constants.UDACITY.ApiScheme
        components.host   = Constants.UDACITY.ApiHost
        components.path   = withPath ?? ""
        
        components.queryItems = [URLQueryItem]()
        
        if !parameters.isEmpty {
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
    
    func parseURLFromParameters(withPath: String? = nil) -> URL {
        
        var components = URLComponents()
        
        components.scheme = Constants.PARSE.ParseScheme
        components.host   = Constants.PARSE.ParseHost
        components.path   = withPath ?? ""
        
        return components.url!
    }
    
    func parseURLFromParameters(parameters: [String:AnyObject], withPath: String? = nil) -> URL {
        
        var components = URLComponents()
        
        components.scheme = Constants.PARSE.ParseScheme
        components.host   = Constants.PARSE.ParseHost
        components.path   = withPath ?? ""
        
        components.queryItems = [URLQueryItem]()
        
        if !parameters.isEmpty {
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        return components.url!
    }
}
