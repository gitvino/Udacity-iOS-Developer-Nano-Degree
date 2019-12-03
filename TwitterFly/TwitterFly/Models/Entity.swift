//
//  Hashtags.swift
//  TwitterFly
//
//  Created by Vinoth on 29/7/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import Foundation

class TwitterIndex: NSObject {
    var startIndex: Int
    var endIndex: Int
    
    init(startIndex: Int, endIndex: Int) {
        self.startIndex = startIndex
        self.endIndex = endIndex
    }
}


class Hashtags {
    var text: String
    var indices: [TwitterIndex]
    init(text: String, indices: [TwitterIndex]) {
        self.text = text
        self.indices = indices
    }
}

class UrlsInTweet {
    var shortenUrl: URL
    var expandedUrl: URL
    var indices: [TwitterIndex]
    
    init(shortenUrl: URL, expandedUrl: URL, indices: [TwitterIndex] ) {
        self.shortenUrl = shortenUrl
        self.expandedUrl = expandedUrl
        self.indices = indices
    }
}

class UserMention {
    var name: String
    var indices: [TwitterIndex]
    var screenName: String
    var id: Int
    
    init(name: String, indices: [TwitterIndex], screenName: String, id: Int) {
        self.name = name
        self.indices = indices
        self.screenName = screenName
        self.id = id
    }
}

class Entitity: NSObject {
    var hashtags: [Hashtags]?
    var urlsInTweet: [UrlsInTweet]?
    var userMentions: [UserMention]?
    
    init(hashtags: [Hashtags]?, urlsInTweet: [UrlsInTweet]?, userMentions: [UserMention]?) {
        self.hashtags = hashtags
        self.urlsInTweet = urlsInTweet
        self.userMentions = userMentions
    }
}

