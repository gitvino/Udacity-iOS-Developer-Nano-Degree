//
//  User.swift
//  TwitterFly
//
//  Created by Vinoth on 29/7/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import Foundation

class TwitterUser: NSObject {
    var userId: Int
    var userName: String
    var userScreenName: String
    var userLocation: String?
    var userDescription: String?
    var userUrl: String?
    var userProfileImageUrl: String?
    
    var userProfileBannerImageUrl: String?
    var createdDate: Date?
    var followersCount: Int?
    var followingCount: Int?
    
    init(userId: Int,
         userName: String,
         userScreenName: String,
         userLocation: String?,
         userDescription: String?,
         userUrl: String?,
         userProfileImageUrl: String?,
         userProfileBannerImageUrl: String?,
         createdDate: Date?,
         followersCount: Int?,
        followingCount: Int?
        ) {
        self.userId = userId
        self.userName = userName
        self.userScreenName = userScreenName
        self.userLocation = userLocation
        self.userDescription = userDescription
        self.userUrl = userUrl
        self.userProfileImageUrl = userProfileImageUrl
        self.userProfileBannerImageUrl = userProfileBannerImageUrl
        self.createdDate = createdDate
        self.followersCount = followersCount
        self.followingCount = followingCount
    }
}
