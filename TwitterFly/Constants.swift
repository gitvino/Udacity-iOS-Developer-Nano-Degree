//
//  Constants.swift
//  TwitterFly
//
//  Created by Vinoth on 24/7/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import Foundation

struct  Constants {

struct APIConstants {

    
    static let API_KEY = ""
    static let API_TOKEN = ""
    static let ACCESS_TOKEN = ""
    static let ACCESS_TOKEN_SECRET = ""
}

struct URLConstants {
        static let Apischeme = "https"
        static let Apihost = "api.twitter.com"
        static let statuses_path = "/1.1/statuses"
        static let home_timeline_path = "/home_timeline.json"
        static let user_timeline_path = "/user_timeline.json"
        static let favorites_path = "/1.1/favorites"
        static let favorites_list = "/list.json"
        static let trends_path = "/1.1/trends"
        static let trends_locations_path = "/closest.json"
        static let trends_place_path = "/place.json"
        static let direct_messages_path = "/1.1/direct_messages"
        static let direct_messages_events_list = "/events/list.json"
        static let users_path = "/1.1/users"
        static let users_lookup = "/lookup.json"
        static let status_update_path = "/update.json"
}
}

