//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Al Manigsaca on 8/24/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //MARK: - Globals
    var userId       : String? = nil
    var firstName    : String? = nil
    var lastName     : String? = nil
    var locationName : String? = nil
    var latitude     : Double? = nil
    var longitude    : Double? = nil
    var objectId     : String? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        return true
    }
}

extension AppDelegate {
    
    // Functions for building the URL
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

