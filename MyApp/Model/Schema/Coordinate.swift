//
//  Coordinate.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 1/22/18.
//  Copyright © 2018 Cuong Doan M. All rights reserved.
//

import Foundation
import MapKit

final class Coordonate {
    var address: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees

    init(address: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
}
