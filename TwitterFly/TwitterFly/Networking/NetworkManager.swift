//
//  NetworkingManager.swift
//  TwitterFly
//
//  Created by Vinoth on 26/7/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import Foundation
import OhhAuth

final class NetworkManager {
    
    static let shared = NetworkManager()
    var session = URLSession.shared
    
    var isOffine:Bool{
        if let reachability = Reachability(), reachability.connection == .none {
            return true
        }else{
            return false
        }
    }
    
    
    private init() {
        
    }

    
    public func taskForGet (
        requestDetails: RequestDetails,
        successHandler: @escaping(_ responseData: Data) -> Void,
        failureHandler: @escaping (_ error: NSError) -> ())
                -> Void
        {
            
            if isOffine {
                let userInfo = [NSLocalizedDescriptionKey : "You are offline. Please check you internet connetion"]
                let error = NSError(domain: "Offline.", code: 0, userInfo: userInfo)
                failureHandler(error)
                
            } else {
                
                var url = addurlParameters(url: requestDetails.url,
                                           urlParameters: requestDetails.urlParameters)
                var mutableUrlRequest = NSMutableURLRequest(url: url)
                mutableUrlRequest.httpMethod = "GET"
                
                if requestDetails.headers != nil {
                    mutableUrlRequest = addHeaders(mutableUrlRequest, requestDetails.headers!)
                }
                var urlRequest = mutableUrlRequest as URLRequest
                let cc = (key: Constants.APIConstants.API_KEY, secret: Constants.APIConstants.API_TOKEN)
                let uc = (key: Constants.APIConstants.ACCESS_TOKEN, secret: Constants.APIConstants.ACCESS_TOKEN_SECRET)
                urlRequest.oAuthSign(method: "GET", urlFormParameters: [:], consumerCredentials: cc, userCredentials: uc)
                
                let dataTask = session.dataTask(with: urlRequest as URLRequest) { responseData, response, error in
      
                    func sendError(_ errorCode: Int, _ error: String) {
                        let userInfo = [NSLocalizedDescriptionKey : error]
                        failureHandler(NSError(domain: error, code: errorCode , userInfo: userInfo))
                    }
                    
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    
                    /* GUARD: Was there any data returned? */
                    guard responseData != nil else {
                        sendError(statusCode, "Empty data")
                        return
                    }
                    
        
                    switch statusCode {
                    case 200...299:
                    successHandler(responseData!)
                        
                    case 400...499:
                        var parsedResult: [String: AnyObject]!
                        do {
                            parsedResult = try JSONSerialization.jsonObject(with: responseData!, options: .allowFragments) as! [String: AnyObject]
                        }
                        catch {
                            sendError(statusCode, "Error while parsing the data ")
                        }
                            guard let errorResponse = parsedResult["errors"] as! [[String: AnyObject]]? else {
                                return
                            }
                            guard let errorItem = errorResponse[0] as [String: AnyObject]? else {
                                return
                            }
                            guard let errorCode = errorItem["code"] as! Int? else {
                                return
                            }
                            guard let errorMessage = errorItem["message"] as! String? else {
                                return
                            }
                            sendError(errorCode, errorMessage)
                        
                    case (100...199), (300...399), (500...599):
                        sendError(statusCode, "Unexpected Response from server")
                        
                    default:
                        sendError(statusCode, "Unexpected Response from server")
                    }
                }
                dataTask.resume()
            }
        }
    
    
    public func taskForPost (
        requestDetails: RequestDetails,
        successHandler: @escaping(_ responseData: Data) -> Void,
        failureHandler: @escaping (_ error: NSError?) -> ())
        -> Void
    {
        if isOffine {
            let userInfo = [NSLocalizedDescriptionKey : "You are offline. Please check you internet connetion"]
            let error = NSError(domain: "Offline.", code: 0, userInfo: userInfo)
            failureHandler(error)
            
        } else {
            
            var url = addurlParameters(url: requestDetails.url,
                                       urlParameters: requestDetails.urlParameters)
            var mutableUrlRequest = NSMutableURLRequest(url: url)
            mutableUrlRequest.httpMethod = "POST"
            
            if requestDetails.headers != nil {
                mutableUrlRequest = addHeaders(mutableUrlRequest, requestDetails.headers!)
            }
            var urlRequest = mutableUrlRequest as URLRequest
            let cc = (key: Constants.APIConstants.API_KEY, secret: Constants.APIConstants.API_TOKEN)
            let uc = (key: Constants.APIConstants.ACCESS_TOKEN, secret: Constants.APIConstants.ACCESS_TOKEN_SECRET)
            urlRequest.oAuthSign(method: "POST", urlFormParameters: [:], consumerCredentials: cc, userCredentials: uc)
            
            let dataTask = session.dataTask(with: urlRequest as URLRequest) { responseData, response, error in
                
                func sendError(_ errorCode: Int, _ error: String) {
                    let userInfo = [NSLocalizedDescriptionKey : error]
                    failureHandler(NSError(domain: error, code: errorCode , userInfo: userInfo))
                }
                
                let statusCode = (response as! HTTPURLResponse).statusCode
                
                /* GUARD: Was there any data returned? */
                guard responseData != nil else {
                    sendError(statusCode, "Empty data")
                    return
                }
                
                
                switch statusCode {
                case 200...299:
                    successHandler(responseData!)
                    
                case 400...499:
                    var parsedResult: [String: AnyObject]!
                    do {
                        parsedResult = try JSONSerialization.jsonObject(with: responseData!, options: .allowFragments) as! [String: AnyObject]
                    }
                    catch {
                        sendError(statusCode, "Error while parsing the data ")
                    }
                    guard let errorResponse = parsedResult["errors"] as! [[String: AnyObject]]? else {
                        return
                    }
                    guard let errorItem = errorResponse[0] as [String: AnyObject]? else {
                        return
                    }
                    guard let errorCode = errorItem["code"] as! Int? else {
                        return
                    }
                    guard let errorMessage = errorItem["message"] as! String? else {
                        return
                    }
                    sendError(errorCode, errorMessage)
                    
                case (100...199), (300...399), (500...599):
                    sendError(statusCode, "Unexpected Response from server")
                    
                default:
                    sendError(statusCode, "Unexpected Response from server")
                }
            }
            dataTask.resume()
        }
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
    
func addHeaders(_ urlRequest: NSMutableURLRequest, _ headers: [String:String]) -> NSMutableURLRequest {
        
        for (key, value) in headers {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        return urlRequest
    }
}

struct RequestDetails {
    
    var url: URL
    var headers: [String:String]?
    var urlParameters: [String: String]?
    
    init(url: URL, headers: [String:String]?, urlParameters: [String: String]? ) {
        self.url = url
        self.headers = headers
        self.urlParameters = urlParameters
    }
}

