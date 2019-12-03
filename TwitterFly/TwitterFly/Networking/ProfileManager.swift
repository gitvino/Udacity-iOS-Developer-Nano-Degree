//
//  ProfileManager.swift
//  TwitterFly
//
//  Created by Vinoth on 21/8/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import Foundation
class ProfileManager {
    
    static let shared = ProfileManager()
    private init(){}
    
    func getUserDetails(successHandler: @escaping(_ messages: TwitterUser) -> Void,
                        failureHandler: @escaping(_ error: NSError)-> Void)
        -> Void {
            
            var usersURLComponents = URLComponents()
            usersURLComponents.scheme = Constants.URLConstants.Apischeme
            usersURLComponents.host = Constants.URLConstants.Apihost
            usersURLComponents.path = Constants.URLConstants.users_path + Constants.URLConstants.users_lookup
            let usersURL = usersURLComponents.url!
            let HttpHeaders = ["Accept":"application/json",
                               "Content-Type":"application/json"]
            let userDetailURLParameters = ["screen_name":"vinoacc1"]
            let usersRequestDetails = RequestDetails(url: usersURL, headers: HttpHeaders, urlParameters: userDetailURLParameters)
            NetworkManager.shared.taskForGet(requestDetails: usersRequestDetails, successHandler: { (responseData) in
                var response: [[String: AnyObject]] = []
                
                do {
                    response = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! [[String: AnyObject]]
                }
                catch {
                    let userInfo = [NSLocalizedDescriptionKey : "Error while parsing the data"]
                    let error = NSError(domain: "Data.", code: 0, userInfo: userInfo)
                    failureHandler(error)
                }
                print(response[0])
                let userId = response[0]["id"] as? Int
                let userName = response[0]["name"] as? String
                let userScreenName = response[0]["screen_name"] as? String
                let userLocation = response[0]["location"] as? String
                let userDescription = response[0]["description"] as? String
                let userUrl = response[0]["url"] as? String
                let userProfileImageUrl = response[0]["profile_image_url_https"] as? String
                
                let userProfileBannerImageUrl = response[0]["profile_banner_url"] as? String
                let followersCount = response[0]["followers_count"] as? Int
                let followingCount = response[0]["friends_count"] as? Int
                let createdDateString = response[0]["created_at"] as? String
                let createdDateDF = DateFormatter()
                createdDateDF.dateFormat = "E, MMM d HH:mm:ss Z YYYY"
                let createdDate = createdDateDF.date(from: createdDateString!)
                
                let twitterUser = TwitterUser(userId: (userId)!,
                                              userName: (userName)!,
                                              userScreenName: (userScreenName)!,
                                              userLocation: (userLocation),
                                              userDescription: (userDescription),
                                              userUrl: (userUrl),
                                              userProfileImageUrl: (userProfileImageUrl),
                                              userProfileBannerImageUrl: userProfileBannerImageUrl,
                                              createdDate: createdDate,
                                              followersCount: followersCount,
                                              followingCount: followingCount)
                
                successHandler(twitterUser)
            }) { (error) in
                failureHandler(error)
            }
    }
    
    func getuserTweets(successHandler: @escaping(_ tweets: [Tweet]) -> Void,
                       failureHandler: @escaping(_ error: NSError) -> Void)
        -> Void {
            var timelineUrlComponents = URLComponents()
            timelineUrlComponents.scheme = Constants.URLConstants.Apischeme
            timelineUrlComponents.host = Constants.URLConstants.Apihost
            timelineUrlComponents.path = Constants.URLConstants.statuses_path + Constants.URLConstants.user_timeline_path
            
            let timelineUrl = timelineUrlComponents.url!
            let HttpHeaders = ["Accept":"application/json",
                               "Content-Type":"application/json"]
            
            let requestDetails = RequestDetails(url: timelineUrl, headers: HttpHeaders, urlParameters: [:])
            NetworkManager.shared.taskForGet(requestDetails: requestDetails, successHandler: { (responseData) in
                var response: [[String: AnyObject]] = []
                do {
                    response = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! [[String: AnyObject]]
                }
                catch {
                    let userInfo = [NSLocalizedDescriptionKey : "Error while parsing the data"]
                    let error = NSError(domain: "Data.", code: 0, userInfo: userInfo)
                    failureHandler(error)
                }
                guard response.count != 0 else {
                    return
                }
                
                var tweetsArray: [Tweet] = []
                for eachTweet in response {
                    //1. Parsing Tweet Details
                    let tweetCreatedAt = eachTweet["created_at"] as! String
                    let tweetId = eachTweet["id"] as! Int
                    let tweetText = eachTweet ["text"] as! String
                    
                    guard let user = eachTweet["user"] as! [String: AnyObject]? else {
                        return
                    }
                    
                    //2. Parsing User Details:
                    let userId = user["id"] as? Int
                    let userName = user["name"] as? String
                    let userScreenName = user["screen_name"] as? String
                    let userLocation = user["location"] as? String
                    let userDescription = user["description"] as? String
                    let userUrl = user["url"] as? String
                    let userProfileImageUrl = user["profile_image_url_https"] as? String
                    
                    let userProfileBannerImageUrl = user["profile_banner_url"] as? String
                    let followersCount = user["followers_count"] as? Int
                    let followingCount = user["freinds_count"] as? Int
                    let createdDateString = user["created_at"] as? String
                    let createdDateDF = DateFormatter()
                    createdDateDF.dateFormat = "E, MMM d HH:mm:ss Z YYYY"
                    let createdDate = createdDateDF.date(from: createdDateString!)
                    
                    let twitterUser = TwitterUser(userId: (userId)!,
                                                  userName: (userName)!,
                                                  userScreenName: (userScreenName)!,
                                                  userLocation: (userLocation),
                                                  userDescription: (userDescription),
                                                  userUrl: (userUrl),
                                                  userProfileImageUrl: (userProfileImageUrl),
                                                  
                                                  userProfileBannerImageUrl: userProfileBannerImageUrl,
                                                  createdDate: createdDate,
                                                  followersCount: followersCount,
                                                  followingCount: followingCount)
                    
                    
                    
                    //3. Parsing Entities
                    let entities = eachTweet["entities"] as! [String: AnyObject]
                    let hashtags = entities["hashtags"] as? [[String: AnyObject]]
                    let userMentions = entities["user_mentions"] as? [[String: AnyObject]]
                    let urlsInTweet = entities["urls"] as? [[String: AnyObject]]
                    
                    var hashtagArray: [Hashtags] = []
                    var userMentionsArray: [UserMention] = []
                    var urlsInTweetArray: [UrlsInTweet] = []
                    if hashtags!.count > 0 {
                        for eachHashtag in hashtags! {
                            let hashtagText = eachHashtag["text"] as! String
                            let hashtagIndices = eachHashtag["indices"] as! [Int]
                            let hashtagIndex = TwitterIndex(startIndex: hashtagIndices[0], endIndex: hashtagIndices[1])
                            let hashtag = Hashtags(text: hashtagText, indices: [hashtagIndex])
                            hashtagArray.append(hashtag)
                        }
                    }
                    if userMentions!.count > 0 {
                        for eachUserMention in userMentions! {
                            let userMentionName = eachUserMention["name"] as! String
                            let userMentionId = eachUserMention["id"] as! Int
                            let userMentionScreenName = eachUserMention["screen_name"] as! String
                            let userMentionIndices = eachUserMention["indices"] as! [Int]
                            let userMentionIndex = TwitterIndex(startIndex: userMentionIndices[0], endIndex: userMentionIndices[1])
                            let userMention = UserMention(name: userMentionName, indices: [userMentionIndex], screenName: userMentionScreenName, id: userMentionId)
                            userMentionsArray.append(userMention)
                        }
                    }
                    if urlsInTweet!.count > 0 {
                        for eachUrlInTweet in urlsInTweet! {
                            let urlsInTweetShortenUrl = URL(string: (eachUrlInTweet["url"] as! String))!
                            let urlsInTweetExpandedUrl = URL(string: (eachUrlInTweet["expanded_url"] as! String))!
                            let urlsInTweetIndices = eachUrlInTweet["indices"] as! [Int]
                            let urlsInTweetIndex = TwitterIndex(startIndex: urlsInTweetIndices[0], endIndex: urlsInTweetIndices[1])
                            let urlInTweet = UrlsInTweet(shortenUrl: urlsInTweetShortenUrl, expandedUrl: urlsInTweetExpandedUrl, indices: [urlsInTweetIndex])
                            urlsInTweetArray.append(urlInTweet)
                        }
                    }
                    let entity = Entitity(hashtags: hashtagArray, urlsInTweet: urlsInTweetArray, userMentions: userMentionsArray)
                    let tweet = Tweet(id: tweetId, createdAt: tweetCreatedAt, text: tweetText, twitterUser: twitterUser, entities: entity)
                    
                    tweetsArray.append(tweet)
                }
                //print(tweetsArray.count)
                successHandler(tweetsArray)
            }) { (error) in
                failureHandler(error)
            }
    }

    
    func getFavoriteTweets(successHandler: @escaping(_ tweets: [Tweet]) -> Void,
                           failureHandler: @escaping(_ error: NSError) -> Void)
        -> Void {
            var timelineUrlComponents = URLComponents()
            timelineUrlComponents.scheme = Constants.URLConstants.Apischeme
            timelineUrlComponents.host = Constants.URLConstants.Apihost
            timelineUrlComponents.path = Constants.URLConstants.favorites_path + Constants.URLConstants.favorites_list
            
            let timelineUrl = timelineUrlComponents.url!
            let HttpHeaders = ["Accept":"application/json",
                               "Content-Type":"application/json"]
            
            let requestDetails = RequestDetails(url: timelineUrl, headers: HttpHeaders, urlParameters: [:])
            NetworkManager.shared.taskForGet(requestDetails: requestDetails, successHandler: { (responseData) in
                var response: [[String: AnyObject]] = []
                do {
                    response = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! [[String: AnyObject]]
                }
                catch {
                    let userInfo = [NSLocalizedDescriptionKey : "Error while parsing the data"]
                    let error = NSError(domain: "Data.", code: 0, userInfo: userInfo)
                    failureHandler(error)
                }
                guard response.count != 0 else {
                    return
                }
                
                var tweetsArray: [Tweet] = []
                for eachTweet in response {
                    //1. Parsing Tweet Details
                    let tweetCreatedAt = eachTweet["created_at"] as! String
                    let tweetId = eachTweet["id"] as! Int
                    let tweetText = eachTweet ["text"] as! String
                    
                    guard let user = eachTweet["user"] as! [String: AnyObject]? else {
                        return
                    }
                    
                    //2. Parsing User Details:
                    let userId = user["id"] as? Int
                    let userName = user["name"] as? String
                    let userScreenName = user["screen_name"] as? String
                    let userLocation = user["location"] as? String
                    let userDescription = user["description"] as? String
                    let userUrl = user["url"] as? String
                    let userProfileImageUrl = user["profile_image_url_https"] as? String
                    
                    let userProfileBannerImageUrl = user["profile_banner_url"] as? String
                    let followersCount = user["followers_count"] as? Int
                    let followingCount = user["freinds_count"] as? Int
                    let createdDateString = user["created_at"] as? String
                    let createdDateDF = DateFormatter()
                    createdDateDF.dateFormat = "E, MMM d HH:mm:ss Z YYYY"
                    let createdDate = createdDateDF.date(from: createdDateString!)
                    
                    let twitterUser = TwitterUser(userId: (userId)!,
                                                  userName: (userName)!,
                                                  userScreenName: (userScreenName)!,
                                                  userLocation: (userLocation),
                                                  userDescription: (userDescription),
                                                  userUrl: (userUrl),
                                                  userProfileImageUrl: (userProfileImageUrl),
                                                  
                                                  userProfileBannerImageUrl: userProfileBannerImageUrl,
                                                  createdDate: createdDate,
                                                  followersCount: followersCount,
                                                  followingCount: followingCount)
                    
                    
                    
                    //3. Parsing Entities
                    let entities = eachTweet["entities"] as! [String: AnyObject]
                    let hashtags = entities["hashtags"] as? [[String: AnyObject]]
                    let userMentions = entities["user_mentions"] as? [[String: AnyObject]]
                    let urlsInTweet = entities["urls"] as? [[String: AnyObject]]
                    
                    var hashtagArray: [Hashtags] = []
                    var userMentionsArray: [UserMention] = []
                    var urlsInTweetArray: [UrlsInTweet] = []
                    if hashtags!.count > 0 {
                        for eachHashtag in hashtags! {
                            let hashtagText = eachHashtag["text"] as! String
                            let hashtagIndices = eachHashtag["indices"] as! [Int]
                            let hashtagIndex = TwitterIndex(startIndex: hashtagIndices[0], endIndex: hashtagIndices[1])
                            let hashtag = Hashtags(text: hashtagText, indices: [hashtagIndex])
                            hashtagArray.append(hashtag)
                        }
                    }
                    if userMentions!.count > 0 {
                        for eachUserMention in userMentions! {
                            let userMentionName = eachUserMention["name"] as! String
                            let userMentionId = eachUserMention["id"] as! Int
                            let userMentionScreenName = eachUserMention["screen_name"] as! String
                            let userMentionIndices = eachUserMention["indices"] as! [Int]
                            let userMentionIndex = TwitterIndex(startIndex: userMentionIndices[0], endIndex: userMentionIndices[1])
                            let userMention = UserMention(name: userMentionName, indices: [userMentionIndex], screenName: userMentionScreenName, id: userMentionId)
                            userMentionsArray.append(userMention)
                        }
                    }
                    if urlsInTweet!.count > 0 {
                        for eachUrlInTweet in urlsInTweet! {
                            let urlsInTweetShortenUrl = URL(string: (eachUrlInTweet["url"] as! String))!
                            let urlsInTweetExpandedUrl = URL(string: (eachUrlInTweet["expanded_url"] as! String))!
                            let urlsInTweetIndices = eachUrlInTweet["indices"] as! [Int]
                            let urlsInTweetIndex = TwitterIndex(startIndex: urlsInTweetIndices[0], endIndex: urlsInTweetIndices[1])
                            let urlInTweet = UrlsInTweet(shortenUrl: urlsInTweetShortenUrl, expandedUrl: urlsInTweetExpandedUrl, indices: [urlsInTweetIndex])
                            urlsInTweetArray.append(urlInTweet)
                        }
                    }
                    let entity = Entitity(hashtags: hashtagArray, urlsInTweet: urlsInTweetArray, userMentions: userMentionsArray)
                    let tweet = Tweet(id: tweetId, createdAt: tweetCreatedAt, text: tweetText, twitterUser: twitterUser, entities: entity)
                    
                    tweetsArray.append(tweet)
                }
                
                successHandler(tweetsArray)
            }) { (error) in
                failureHandler(error)
            }
            
    }
}
