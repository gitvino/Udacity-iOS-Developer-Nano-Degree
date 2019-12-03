//
//  Tweet.swift
//  TwitterFly
//
//  Created by Vinoth on 29/7/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import Foundation

class Tweet {
    var id: Int
    var createdAt: String
    var text: String
    var twitterUser: TwitterUser
    var entities: Entitity
    
    init(id: Int, createdAt: String, text: String, twitterUser: TwitterUser, entities: Entitity) {
        self.id = id
        self.createdAt = createdAt
        self.text = text
        self.twitterUser = twitterUser
        self.entities = entities
    }
}
