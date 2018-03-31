//
//  MapAnnotationPin.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 12/21/17.
//  Copyright © 2017 Cuong Doan M. All rights reserved.
//

import MapKit

final class PinAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var id: Int

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(title: String, subtitle: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, id: Int) {
        self.title = title
        self.subtitle = subtitle
        self.latitude = latitude
        self.longitude = longitude
        self.id = id
    }
}
