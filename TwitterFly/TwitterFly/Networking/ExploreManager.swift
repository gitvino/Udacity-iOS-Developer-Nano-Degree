//
//  ExploreManager.swift
//  TwitterFly
//
//  Created by Vinoth on 7/8/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import Foundation
import CoreLocation
class ExploreManager {
    
    
    static let shared = ExploreManager()
    private init(){}
    
    func getTrendsLocation(locationCoordinate: CLLocationCoordinate2D,
                           successHandler: @escaping(_ weoid: Int?,_ location: String?) -> ()?,
                           failureHandler: @escaping (_ error: NSError?) -> ())
        -> Void {
     var trendsLocationURLCompononents = URLComponents()
        trendsLocationURLCompononents.scheme = Constants.URLConstants.Apischeme
        trendsLocationURLCompononents.host = Constants.URLConstants.Apihost
        trendsLocationURLCompononents.path = Constants.URLConstants.trends_path + Constants.URLConstants.trends_locations_path
        let url = trendsLocationURLCompononents.url!
        let HttpHeaders = ["Accept":"application/json",
                           "Content-Type":"application/json"]
        let location = ["lat":"\(locationCoordinate.latitude)",
                        "long":"\(locationCoordinate.longitude)"]
        
            let requestDetails = RequestDetails(url: url, headers: HttpHeaders, urlParameters: location)
            
        NetworkManager.shared.taskForGet(requestDetails: requestDetails,
                                         successHandler: { (responseData) in
           var response: [[String: AnyObject]] = []
           do {
            response = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! [[String: AnyObject]]
           }
            catch {
                let userInfo = [NSLocalizedDescriptionKey : "Error while parsing the data"]
                let error = NSError(domain: "Data.", code: 0, userInfo: userInfo)
                failureHandler(error)
            }
            successHandler(response[0]["woeid"] as? Int, response[0]["name"] as? String)
            
        }) { (error) in
            print(error)
        }
    }
    func getTrendsByLocation(woeid: Int,
                             sucessHandler: @escaping(_ trendsResult: [Trend])->(),
                             failureHandler: @escaping (_ error: NSError?) -> () )
        -> Void {
            
            var trendsByLocationURLComponents = URLComponents()
            trendsByLocationURLComponents.scheme = Constants.URLConstants.Apischeme
            trendsByLocationURLComponents.host = Constants.URLConstants.Apihost
            trendsByLocationURLComponents.path = Constants.URLConstants.trends_path + Constants.URLConstants.trends_place_path
            
            let url = trendsByLocationURLComponents.url!
            let httpHeaders = ["Accept":"application/json",
                               "Content-Type":"application/json"]
            let requestDetails = RequestDetails(url: url, headers: httpHeaders, urlParameters: ["id": "\(woeid)"])
                NetworkManager.shared.taskForGet(requestDetails: requestDetails,
                
                successHandler: { (responseData) in
                    var response: [[String: AnyObject]] = []
                    do {
                        response = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! [[String: AnyObject]]
                    }
                    catch {
                        let userInfo = [NSLocalizedDescriptionKey : "Error while parsing the data"]
                        let error = NSError(domain: "Offline.", code: 0, userInfo: userInfo)
                        failureHandler(error)
                    }
                guard let trends = response[0]["trends"] as? [[String: AnyObject]] else {
                    return
                }
                var trendsArray: [Trend] = []
                
                for eachTrend in trends {
                    guard let name = eachTrend["name"] as? String else { return }
                    guard let query = eachTrend["query"] as? String else { return }
                    guard let url = eachTrend["url"] as? String else { return }
                    let trend = Trend(name: name, query: query, trendURL: URL(string: url)! )
                    trendsArray.append(trend)
                }
                
                    
                sucessHandler(trendsArray)
 
            }) { (error) in
                failureHandler(error)
            }
            
            
    }
}
