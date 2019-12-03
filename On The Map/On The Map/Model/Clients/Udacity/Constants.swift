//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Vinoth kumar on 24/3/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    struct UdacityConstants {
        //Udacity URL
        static let Apischeme = "https"
        static let Apihost = "www.udacity.com"
        static let session_path = "/api/session"
        static let users_path = "/api/users/{user_id}"
    }
    
    struct  UdacityParameterKeys {
        
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        
    }
    struct  UdacityJSONResponseKeys {
        static let Account = "account"
        static let Session = "session"
        static let Registered = "registered"
        static let Key = "key"
        static let ID = "id"
        static let Expiration = "expiration"
    }
}

extension ParseClient {
    
    struct ParseConstants {
        static let ApiScheme = "https"
        static let Apihost = "parse.udacity.com"
        static let path = "/parse/classes/StudentLocation"
    }
    
    struct ParseHeaderKeys {
        static let ApplicationId = "X-Parse-Application-Id"
        static let RestApiKey = "X-Parse-REST-API-Key"
        static let ContentType = "Content-Type"
        static let Accept = "Accept"
    }
    
    struct ParseHeaderValues {
        static let ApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ContentType = "application/json"
        static let Accept = "application/json"
    }
    struct URLParameterKeys {
        static let Order = "order"
        static let Limit = "limit"
    }
    struct URLParameterValues {
        static let Order = "-updatedAt"
        static let Limit = "100"
    }
    
}

