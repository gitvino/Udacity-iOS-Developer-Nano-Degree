//
//  Trend.swift
//  TwitterFly
//
//  Created by Vinoth on 14/8/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import Foundation

class Trend: NSObject {
    var name: String
    var query: String
    var trendURL: URL
    
    init(name: String,
                  query: String,
                  trendURL: URL) {
        self.name = name
        self.query = query
        self.trendURL = trendURL
        
    }
}
