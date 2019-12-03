//
//  Message.swift
//  TwitterFly
//
//  Created by Vinoth on 18/8/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import Foundation

class Message: NSObject {
    
    var id: Int
    var createdTimestamp: Date
    var senderId: String
    var messageData: String
    var senderImageURL: String
    var senderUserName: String
    var senderScreenName: String
    
    init(id: Int,
         createdTimestamp: Date,
         senderId: String,
         messageData: String,
         senderImageURL: String,
         senderUserName: String,
         senderScreenName: String
        ) {
        
        self.id = id
        self.createdTimestamp = createdTimestamp
        self.senderId = senderId
        self.messageData = messageData
        self.senderImageURL = senderImageURL
        self.senderUserName = senderUserName
        self.senderScreenName = senderScreenName
    }
}
