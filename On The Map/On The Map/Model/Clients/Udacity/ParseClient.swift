//
//  ParseClient.swift
//  On The Map
//
//  Created by Vinoth kumar on 31/3/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import Foundation
import CoreLocation


class ParseClient: NSObject {
    
    var session = URLSession.shared
    
func getLocations (completionHandler:  @escaping(_ result: [Student]?, _ error: NSError?) -> Void)  {
    
   
    let url = urlFromMethod(ParseConstants.path)
    let httpHeaders = [ParseHeaderKeys.ApplicationId: ParseHeaderValues.ApplicationId,
                       ParseHeaderKeys.ContentType: ParseHeaderValues.ContentType,
                       ParseHeaderKeys.RestApiKey: ParseHeaderValues.RestApiKey,
                       ParseHeaderKeys.Accept: ParseHeaderValues.Accept]
    let urlParameters = [URLParameterKeys.Order: URLParameterValues.Order,
                         URLParameterKeys.Limit: URLParameterValues.Limit]
    
    NetworkingManager.sharedInstance.taskForGet(url: url, headers: httpHeaders, urlParameters: urlParameters) { result, error in
        
        guard error == nil else {
            print("Error: \(String(describing: error))")
            completionHandler(nil, error)
            return
        }
        
        if let studentsArray = result?["results"] as? [[String: AnyObject]] {
            for eachStudent in studentsArray {
                
                if let validStudent = Student.createStudentIfValid(data: eachStudent) {
                    StudentsInformation.sharedInstance().studentList.append(validStudent)
                }
            }
            completionHandler(StudentsInformation.sharedInstance().studentList, nil)
        }
    
        }
    }

    
    func postLocation(uniqueKey: String,
                      firstName:String,
                      lastName: String,
                      mapString: String,
                      mediaURL: String,
                      location: CLLocationCoordinate2D,
                      completionHandler:  @escaping (_ result: [String : AnyObject]?, _ error: NSError?) -> Void)
                      -> Void {
                        
   
        
        let url = urlFromMethod(ParseConstants.path)
        let httpHeaders = [ParseHeaderKeys.ApplicationId: ParseHeaderValues.ApplicationId,
                           ParseHeaderKeys.ContentType: ParseHeaderValues.ContentType,
                           ParseHeaderKeys.RestApiKey: ParseHeaderValues.RestApiKey]

        let body = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(location.latitude), \"longitude\": \(location.longitude)}".data(using: .utf8)
        
        
    
        NetworkingManager.sharedInstance.taskForPost(url: url, headers: httpHeaders, body: body!) { (result, error) in

            guard error == nil else {
                print("Error: \(String(describing: error))")
                completionHandler(nil, error)
                return
            }
            print("Result: \(String(describing: result))")
            completionHandler(result, nil)
            }
    }

    private func urlFromMethod (_ method: String) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = ParseConstants.ApiScheme
        urlComponents.host = ParseConstants.Apihost
        urlComponents.path = method
        return urlComponents.url!
    }
    
   class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}

