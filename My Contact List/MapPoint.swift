//
//  MapPoint.swift
//  My Contact List
//
//  Created by user246123 on 4/4/24.
//

import Foundation
import MapKit

class MapPoint: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
