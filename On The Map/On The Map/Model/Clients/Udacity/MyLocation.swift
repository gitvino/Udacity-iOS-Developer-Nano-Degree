//
//  MyLocation.swift
//  On The Map
//
//  Created by Vinoth kumar on 31/3/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import Foundation
import MapKit

class MyLocation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
}
}
