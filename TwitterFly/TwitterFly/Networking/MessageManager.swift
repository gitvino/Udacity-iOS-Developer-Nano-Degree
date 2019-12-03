//
//  MessageManager.swift
//  TwitterFly
//
//  Created by Vinoth on 18/8/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import Foundation
class MessageManager {
    
    static let shared = MessageManager()
    private init(){}
    
    func getMessages(successHandler: @escaping(_ messages: [Message]) -> Void,
                     failureHandler: @escaping(_ error: NSError)-> Void)
        -> Void {
            var messages: [Message] = []
            var messagesURLComponents = URLComponents()
            messagesURLComponents.scheme = Constants.URLConstants.Apischeme
            messagesURLComponents.host = Constants.URLConstants.Apihost
            messagesURLComponents.path = Constants.URLConstants.direct_messages_path + Constants.URLConstants.direct_messages_events_list
            let messagesURL = messagesURLComponents.url!
            let HttpHeaders = ["Accept":"application/json",
                               "Content-Type":"application/json"]
            let requestDetails = RequestDetails(url: messagesURL, headers: HttpHeaders, urlParameters: [:])
            NetworkManager.shared.taskForGet(
                requestDetails: requestDetails,
                successHandler: { (responseData) in
                    var messageResponse: [String: AnyObject] = [:]
                    do {
                        messageResponse = try JSONSerialization.jsonObject(
                            with: responseData,
                            options: .allowFragments) as! [String: AnyObject]
                    }
                    catch {
                        let userInfo = [NSLocalizedDescriptionKey : "Error while parsing the data"]
                        let error = NSError(domain: "Data.", code: 0, userInfo: userInfo)
                        failureHandler(error)
                    }
                    guard let events = messageResponse["events"] as! [[String: AnyObject]]? else {
                        return
                    }
                    
                    var senderIdKeys: [String] = []
                    
                    for eachEvent in events {
                        guard let messageCreate = eachEvent["message_create"] as! [String: AnyObject]?  else {
                            return
                        }
                        guard let senderId = messageCreate["sender_id"] as! String? else {
                            return
                        }
                        senderIdKeys.append(senderId)
                    }
                    var senderUsersURLComponents = URLComponents()
                    senderUsersURLComponents.scheme = Constants.URLConstants.Apischeme
                    senderUsersURLComponents.host = Constants.URLConstants.Apihost
                    senderUsersURLComponents.path = Constants.URLConstants.users_path + Constants.URLConstants.users_lookup
                    let senderUsersURL = senderUsersURLComponents.url!
                    let HttpHeaders = ["Accept":"application/json",
                                       "Content-Type":"application/json"]
                    let senderUsersURLParameters = ["user_id":senderIdKeys.joined(separator: ",")]
                    let senderUsersRequestDetails = RequestDetails(url: senderUsersURL, headers: HttpHeaders, urlParameters: senderUsersURLParameters)
                    NetworkManager.shared.taskForGet(requestDetails: senderUsersRequestDetails, successHandler: { (responseData) in
                        var response: [[String: AnyObject]] = []
                        var sendersList: [String: TwitterUser] = [:]
                        do {
                            response = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! [[String: AnyObject]]
                        }
                        catch {
                            let userInfo = [NSLocalizedDescriptionKey : "Error while parsing the data"]
                            let error = NSError(domain: "Data.", code: 0, userInfo: userInfo)
                            failureHandler(error)
                        }
                        
                        for user in response {
                            let userId = user["id"] as? Int
                            let userName = user["name"] as? String
                            let userScreenName = user["screen_name"] as? String
                            let userLocation = user["location"] as? String
                            let userDescription = user["description"] as? String
                            let userUrl = user["url"] as? String
                            let userProfileImageUrl = user["profile_image_url_https"] as? String
                            
                            let userProfileBannerImageUrl = user["profile_banner_url"] as? String
                            let followersCount = user["friends_count"] as? Int
                            let followingCount = user["following_count"] as? Int
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
                            sendersList["\(userId!)"] = twitterUser
                        }
                        for eachEvent in events {
                            guard let messageCreate = eachEvent["message_create"] as! [String: AnyObject]?  else {
                                return
                            }
                            guard let messageIdString = eachEvent["id"] as! String? else {
                                return
                            }
                            guard let createdTimestamp = eachEvent["created_timestamp"] as! String? else {
                                return
                            }
                            guard let senderId = messageCreate["sender_id"] as! String? else {
                                return
                            }
                            guard let messageData = messageCreate["message_data"] as! [String: AnyObject]? else {
                                return
                            }
                            guard let messageText = messageData["text"] as! String? else {
                                return
                            }
                            let messageId = Int(messageIdString)!
                            let message = Message(id: messageId,
                                                  createdTimestamp: Date(timeIntervalSince1970: Double(createdTimestamp)!),
                                                  senderId: senderId,
                                                  messageData: messageText,
                                                  senderImageURL: sendersList[senderId]!.userProfileImageUrl!,
                                                  senderUserName: sendersList[senderId]!.userName,
                                                  senderScreenName: sendersList[senderId]!.userScreenName)
                          messages.append(message)
                        }

                        successHandler(messages)
                        
                    }, failureHandler: { (error) in
                        failureHandler(error)
                    })
                    
                    
                    
            }) { (error) in
                failureHandler(error)
            }
    }
}
