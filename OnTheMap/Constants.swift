//
//  Constants.swift
//  OnTheMap
//
//  Created by Al Manigsaca on 9/4/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import Foundation

struct Constants {
    
    struct UDACITY {
        static let ApiScheme  = "https"
        static let ApiHost    = "www.udacity.com"
        static let SignUpPage = "https://auth.udacity.com/sign-up"
    }
    
    struct PARSE {
        static let ParseScheme     = "https"
        static let ParseHost       = "parse.udacity.com"
        static let ParseApiId      = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseRestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let UpdatedAt       = "-updatedAt"
        static let Order           = "order"
    }
    
    struct ACCOUNT {
        static let MethodPost   = "POST"
        static let MethodDelete = "DELETE"
        
        static let UdacityKey   = "udacity"
        static let UsernameKey  = "username"
        static let PasswordKey  = "password"
        static let AccountKey   = "account"
        static let KeyKey       = "key"
        static let UserKey      = "user"
        static let FirstnameKey = "first_name"
        static let LastnameKey  = "last_name"
        static let Session      = "session"
        static let Id           = "id"
    }
    
    struct LOCATION {
        struct ParameterKeys {
            static let Limit     = "limit"
            static let Latitude  = "latitude"
            static let Longitude = "longitude"
            static let Firstname = "firstName"
            static let Lastname  = "lastName"
            static let MediaURL  = "mediaURL"
            static let Where     = "where"
            static let UniqueKey = "uniqueKey"
            static let MapString = "mapString"
        }
        
        struct ParameterValues {
            static let Limit = "100"
        }
        
        struct HTTP {
            static let MethodPost = "POST"
            static let MethodPut  = "PUT"
        }
    }
    
    struct UI {
        struct Button {
            static let CornerRadius = 5.0
        }
        
        struct Map {
            static let Span : Double = 2.0
        }
    }
}
