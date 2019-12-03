//
//  VTAnnotation.swift
//  Virtual Tourist
//
//  Created by Vinoth kumar on 5/5/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class VTAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pinID: NSManagedObjectID
    
    init(coordinate: CLLocationCoordinate2D, pinID: NSManagedObjectID) {
        self.coordinate = coordinate
        self.pinID = pinID
    }
}
