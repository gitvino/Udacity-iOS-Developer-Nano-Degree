//
//  NetworkingManager.swift
//  Virtual Tourist
//
//  Created by Vinoth kumar on 2/5/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class NetworkingManager {
    
    static let sharedInstance = NetworkingManager()
    
    private init() {
        
    }

    
    func getPhotoURLsByLocation(latitude: String,
                                longitude: String,
                                successHandler: @escaping (_ photo:[String]) -> Void,
                                failureHandler: @escaping (_ error: String) -> Void) {
        
        let methodParameters = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.BoundingBox: bboxString(latitude: latitude, longitude: longitude),
            Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback,
            Constants.FlickrParameterKeys.PerPage: Constants.FlickrParameterValues.PerPage
        ]
        
        //successHandler()
        let session = URLSession.shared
        let request = URLRequest(url: flickrURLFromParameters(methodParameters as [String : AnyObject]))
        let task = session.dataTask(with: request) { (data, response, error) in
            guard (error == nil) else {
                failureHandler((error?.localizedDescription)!)
                return
            }
            let parsedResult: [String:AnyObject]!
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                failureHandler(error.localizedDescription)
                return
            }
           
            
            guard let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
                failureHandler("Error in response. Try again.")
                return
            }
            guard let photosArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String: AnyObject]] else {
                failureHandler("Error in response. Try again.")
                return
            }
            var photosURL = [String]()
            for eachPhoto in photosArray {
                photosURL.append(eachPhoto[Constants.FlickrResponseValues.MediumURL]! as! String)
            }
            successHandler(photosURL)
        }
        task.resume()
        
    }
    
    func getDataFromUrl(url: URL) {
        var destinationFilename = ""
        let session = URLSession.shared
        let request = URLRequest(url: url)
        let downloadTask = session.downloadTask(with: request) { (location, response, error) in
            let fm = FileManager.default
            let documentsPathURL = fm.urls(for: .documentDirectory, in: .userDomainMask).first
            let fileName = request.url?.lastPathComponent
            destinationFilename = (documentsPathURL?.absoluteString)! + "/DownloadedImages/" + fileName!
            
            do {
                print("moving file to + \(destinationFilename)")
                try fm.moveItem(at: location!, to: URL(string: destinationFilename)!) 
            } catch {
                print(error)
            }
            
        }
        downloadTask.resume()
        
    }
    
   
    func downloadImage(
        photoURL:String,
        successCompletionHandler: @escaping(_ downloadedImage: Data) -> Void,
        failureCompletionHandler: @escaping(_ errorMessage: String) -> Void) -> Void {
        
        let photoWebURL = URL(string: photoURL)!
        let session = URLSession.shared
        let request = URLRequest(url: photoWebURL)
        let downloadTask = session.downloadTask(with: request) { (location, response, error) in
            guard error == nil else{
                failureCompletionHandler("error")
                return
            }
            let downloadedImageData = try? Data(contentsOf: location!)
            successCompletionHandler(downloadedImageData!)
            }
        downloadTask.resume()
        
        
    }

    
    private func flickrURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    private func bboxString(latitude: String, longitude: String) -> String {
        // ensure bbox is bounded by minimum and maximums
        if let latitude = Double(latitude),
            let longitude = Double(longitude) {
            let minimumLon = max(longitude - Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.0)
            let minimumLat = max(latitude - Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.0)
            let maximumLon = min(longitude + Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.1)
            let maximumLat = min(latitude + Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.1)
            return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
        } else {
            return "0,0,0,0"
        }
    }
    
    
}
