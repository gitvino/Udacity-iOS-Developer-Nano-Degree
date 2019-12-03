//
//  NetworkingManager.swift
//  On The Map
//
//  Created by Vinoth kumar on 31/3/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import Foundation
import UIKit


class NetworkingManager: NSObject {
    
    static let sharedInstance = NetworkingManager ()
    
    var session = URLSession.shared
    var loadingIndicatorView : LoadingIndicatorView!
    
    var isOffine:Bool{
        if let reachability = Reachability(), reachability.connection == .none {
            return true
        }else{
            return false
        }
    }
    public func taskForPost(url: URL,
                     headers: [String:String],
                     body: Data,
                     completionHandlerForPost: @escaping (_ jsonResult: [String:AnyObject]?, _ error: NSError? ) -> Void)
          {
            
            if isOffine {
                let userInfo = [NSLocalizedDescriptionKey : "You are offline. Please check you internet connetion"]
                let error = NSError(domain: "Offline.", code: 0, userInfo: userInfo)
                completionHandlerForPost(nil, error )
            } else {
            loadingIndicatorView = LoadingIndicatorView.fromNib()
            loadingIndicatorView.show()
            
            var urlRequest = NSMutableURLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = body
            urlRequest =  addHeaders(urlRequest, headers)

        let dataTask = session.dataTask(with: urlRequest as URLRequest) { data, response, error in

            self.loadingIndicatorView.hide()

            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPost(nil, NSError(domain: error, code: 1 , userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard var data = data else {
                sendError("No data was returned by the request!")
                return
            }
            if url.absoluteString.contains(UdacityClient.UdacityConstants.Apihost){
                let range = Range(5..<data.count)
                data = data.subdata(in: range)
                print(String(data: data, encoding: .utf8)!)
            }
            
            var parsedResult: [String: AnyObject]!
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                completionHandlerForPost(parsedResult, nil)
            }
            catch {
                sendError("Request Failed. Try again. \(error)")
            }
        }
        dataTask.resume()
        }
    }
    
    public func taskForGet (url: URL,
                            headers: [String:String]?,
                            urlParameters: [String: String]?,
                            completionHandlerForGet: @escaping (_ jsonResult: [String:AnyObject]?, _ error: NSError? ) -> Void)
          {
            
            if isOffine {
                let userInfo = [NSLocalizedDescriptionKey : "You are offline. Please check you internet connetion"]
                let error = NSError(domain: "Offline.", code: 0, userInfo: userInfo)
                completionHandlerForGet(nil, error )
            } else {
            loadingIndicatorView = LoadingIndicatorView.fromNib()
            loadingIndicatorView.show()
            
        var url = addurlParameters(url: url, urlParameters: urlParameters)
        var urlRequest = NSMutableURLRequest(url: url)
            urlRequest.httpMethod = "GET"
            
            if headers != nil {
                urlRequest = addHeaders(urlRequest, headers!)
            }
            
            let dataTask = session.dataTask(with: urlRequest as URLRequest) { data, response, error in
               
                 self.loadingIndicatorView.hide()
                
                func sendError(_ error: String) {
                    let userInfo = [NSLocalizedDescriptionKey : error]
                    completionHandlerForGet(nil, NSError(domain: error, code: 1 , userInfo: userInfo))
                }
                
                /* GUARD: Was there an error? */
                guard (error == nil) else {
                    sendError("There was an error with your request: \(error!.localizedDescription)")
                    return
                }
                
                /* GUARD: Did we get a successful 2XX response? */
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                    sendError("Your request returned a status code other than 2xx!")
                    return
                }
                
                /* GUARD: Was there any data returned? */
                guard var data = data else {
                    sendError("No data was returned by the request!")
                    return
                }
                if url.absoluteString.contains(UdacityClient.UdacityConstants.Apihost){
                    
                    let range = Range(5..<data.count)
                    data = data.subdata(in: range)
                    print(String(data: data, encoding: .utf8)!)
                }
                
                
                var parsedResult: [String: AnyObject]!
                
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                    
                } catch {
                    sendError("Error parsing the Result")
                }
                completionHandlerForGet(parsedResult, nil)
            }
        dataTask.resume()
            }
    }
    
    func taskForDelete (url:URL, httpCookie: HTTPCookie?, completionHandlerForDelete: @escaping() -> Void) {
        
      
            
        loadingIndicatorView = LoadingIndicatorView.fromNib()
        loadingIndicatorView.show()
        
        var urlRequest = URLRequest(url: url)
        
        if let xsrfCookie = httpCookie {
            urlRequest.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            self.loadingIndicatorView.hide()
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            print(String(data: newData, encoding: .utf8)!)
            
            if (response as? HTTPURLResponse)?.statusCode == 200 {
                completionHandlerForDelete()
            }
        }
        task.resume()
        
    }
    
    
    /* class func sharedInstance() -> NetworkingManager {
        static let shareInstance =NetworkingManager ()
        struct Singleton {
            
            static var sharedInstance = NetworkingManager()
        }
        return Singleton.sharedInstance
    } */
    
    
    
    func addHeaders(_ urlRequest: NSMutableURLRequest, _ headers: [String:String]) -> NSMutableURLRequest {
        
        for (key, value) in headers {
        urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        return urlRequest
    }
    
    
    func addurlParameters (url: URL, urlParameters: [String: String]?) -> URL {
        
       var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        if urlParameters != nil {
            urlComponents.queryItems = [URLQueryItem]()
            for (key, value) in urlParameters! {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems?.append(queryItem)
            }
            
        }
        return urlComponents.url!
    }
  
}
