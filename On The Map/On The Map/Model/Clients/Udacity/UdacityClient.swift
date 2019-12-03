//
//  UdacityClient.swift
//  On The Map
//
//  Created by Vinoth kumar on 24/3/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class UdacityClient: NSObject {
    
    var session = URLSession.shared
    
    var userId: String?
    var sessionId: String?
    var firstName: String?
    var lastName: String?
    
    func loginTask (username inputUserName: String,
                    password inputPassword: String,
                    completionHandlerForPost: @escaping (_ result: AnyObject?,_ error: NSError?) -> Void) {
        
        let url =  urlFromMethod(UdacityConstants.session_path)
        let HttpHeaders = ["Accept":"application/json",
                           "Content-Type":"application/json"]
        let httpBody = "{\"udacity\": {\"username\": \"\(inputUserName)\", \"password\": \"\(inputPassword)\"}}".data(using: .utf8)
 
        NetworkingManager.sharedInstance.taskForPost(url: url, headers: HttpHeaders, body: httpBody!) { (result, error) in
            guard error == nil else {
                print("Error: \(String(describing: error))")
                completionHandlerForPost(nil, error)
                return
            }
            print("Result: \(String(describing: result))")
            
            
            guard let session = result! ["session"] else {
                
                return
            }
            guard let account = result! ["account"] else {
                
                return
            }
            guard let session_ID = session["id"] else {
                
                return
            }
            
            guard let key = account["key"] else {
                
                return
            }
            let udacityUser = UdacityClient()
            
            udacityUser.sessionId = session_ID as! String
            udacityUser.userId = key as! String

            performUIUpdates {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.udacityUser = udacityUser
            }
            completionHandlerForPost(udacityUser, error)
            
        }
        
    }
    func getUserProfile(sessionID: String,
                        userID: String,
                        completionHandler: @escaping (_ result: AnyObject?,_ error: NSError?) -> Void) {
        

        let url = urlFromMethod(substituteKeyInMethod(UdacityConstants.users_path, key: "user_id", value: userID)!)
        let HttpHeaders = ["Accept":"application/json",
                           "Content-Type":"application/json"]
        NetworkingManager.sharedInstance.taskForGet(url: url, headers: HttpHeaders, urlParameters: nil) { (result, error) in
            
            guard error == nil else {
                print("Error: \(String(describing: error))")
                completionHandler(nil, error)
                return
            }
            guard let user = result! ["user"] else {
                return
            }
            guard let firstName = user["first_name"] else {
                return
            }
            guard let lastName = user["last_name"] else {
                return
            }
            let udacityUser = UdacityClient.sharedInstance()
            udacityUser.firstName = firstName as? String
            udacityUser.lastName = lastName as? String
            udacityUser.sessionId = sessionID
            udacityUser.userId = userID
            performUIUpdates {
                let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                appDelegate.udacityUser = udacityUser
            }
            
            completionHandler(udacityUser, nil)
        }
    
    }
    
    func logout(completionHandlerForDelete: @escaping ()->Void ){
        let url =  urlFromMethod(UdacityConstants.session_path)
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        
        NetworkingManager.sharedInstance.taskForDelete(url: url, httpCookie: xsrfCookie) {
            completionHandlerForDelete()
        }
        
    }
    
    private func urlFromMethod (_ method: String) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = UdacityConstants.Apischeme
        urlComponents.host = UdacityConstants.Apihost
        urlComponents.path = method
        return urlComponents.url!
    }
    
    private func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
