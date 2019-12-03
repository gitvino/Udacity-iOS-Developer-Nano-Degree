//
//  StudentModel.swift
//  On The Map
//
//  Created by Vinoth kumar on 27/3/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import Foundation

struct Student {

    var firstName: String
    var lastName: String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    var uniqueKey: String
    var objectId: String
    
    var fullname: String {
        return "\(firstName) \(lastName)"
    }
    
    static func createStudentIfValid(data:[String:AnyObject]) -> Student? {
        
        if let firstName = data["firstName"] as? String,
            let lastName = data["lastName"] as? String,
            let latitude = data["latitude"] as? Double,
            let longitude = data["longitude"] as? Double,
            let mapString = data["mapString"] as? String,
            let uniqueKey = data["uniqueKey"] as? String,
            let objectId = data["objectId"] as? String,
            let mediaURL = data["mediaURL"] as? String {
            let studentObject = Student(firstName: firstName, lastName: lastName, latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: mediaURL, uniqueKey: uniqueKey, objectId: objectId)
            
           return studentObject
        } else {
            return nil
            
        }
    }
}

class StudentsInformation {
    
    var studentList: [Student] = []
    
    class func sharedInstance() -> StudentsInformation {
        
        struct Singleton {
            static var sharedInstance = StudentsInformation()
        }
        
        return Singleton.sharedInstance
    }
}
