//
//  ComposeManager.swift
//  TwitterFly
//
//  Created by Vinoth on 30/8/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import Foundation
class ComposeManager {
    
    static let shared = ComposeManager()
    private init(){}

    func postTweet(statusString: String,
                   successHandler: @escaping(_ status: Bool) -> Void,
                   failureHandler: @escaping(_ error: NSError)-> Void)
        -> Void {
            
            var postTweetURLComponents = URLComponents()
            postTweetURLComponents.scheme = Constants.URLConstants.Apischeme
            postTweetURLComponents.host = Constants.URLConstants.Apihost
            postTweetURLComponents.path = Constants.URLConstants.statuses_path + Constants.URLConstants.status_update_path
            let usersURL = postTweetURLComponents.url!
            let HttpHeaders = ["Accept":"application/json",
                               "Content-Type":"application/json"]
            let postTweetParameters = ["status": statusString]
            let postTweetDetails = RequestDetails(url: usersURL, headers: HttpHeaders, urlParameters: postTweetParameters)
            NetworkManager.shared.taskForPost(requestDetails: postTweetDetails,
                                              successHandler: { (responseData) in
                var response: [String: AnyObject] = [:]
                do {
                    response = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! [String: AnyObject]
                    guard let _ = response["created_at"] as? String  else {
                        successHandler(false)
                        return
                    }
                    successHandler(true)
                }
                catch {
                    let userInfo = [NSLocalizedDescriptionKey : "Error while parsing the data"]
                    let error = NSError(domain: "Data.", code: 0, userInfo: userInfo)
                    failureHandler(error)
                }
            }) { (error) in
                failureHandler(error!)
            }
            
    }
}
