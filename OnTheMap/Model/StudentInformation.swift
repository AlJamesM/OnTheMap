//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Al Manigsaca on 9/6/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    var firstname : String?
    var lastname  : String?
    var mediaURL  : String?
    var mapString : String?
    var latitude  : Double?
    var longitude : Double?
    
    init(_ student: [String: AnyObject]) {
        
        if let firstname = student[Constants.LOCATION.ParameterKeys.Firstname] as? String {
            self.firstname = firstname
        }
        
        if let lastname = student[Constants.LOCATION.ParameterKeys.Lastname] as? String {
            self.lastname = lastname
        }
        
        if let mediaURL = student[Constants.LOCATION.ParameterKeys.MediaURL] as? String {
            self.mediaURL = mediaURL
        }
        
        if let mapString = student[Constants.LOCATION.ParameterKeys.MapString] as? String {
            self.mapString = mapString
        }
        
        if let latitude = student[Constants.LOCATION.ParameterKeys.Latitude] as? Double {
            self.latitude = latitude
        }
        
        if let longitude = student[Constants.LOCATION.ParameterKeys.Longitude] as? Double {
            self.longitude = longitude
        }
    }
}
