//
//  DrawRouteBetweenTwoAnnotations.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 1/2/18.
//  Copyright © 2018 Cuong Doan M. All rights reserved.
//

import UIKit
import MapKit

final class RouteBetweenTwoAnnotations {

    // MARK: - Public
    func drawRoute(_ mapView: MKMapView, _ chooseAnnotation: MKAnnotation, _ endAnnotation: MKAnnotation) {
        let chooseCoordinate = chooseAnnotation.coordinate
        let endCoordinate = endAnnotation.coordinate

        let choosePlacemark = MKPlacemark(coordinate: chooseCoordinate, addressDictionary: nil)
        let endPlacemark = MKPlacemark(coordinate: endCoordinate, addressDictionary: nil)

        let chooseMapItem = MKMapItem(placemark: choosePlacemark)
        let endMapItem = MKMapItem(placemark: endPlacemark)

        let directionRequest = MKDirectionsRequest()
        directionRequest.source = chooseMapItem
        directionRequest.destination = endMapItem
        directionRequest.transportType = .automobile

        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }

            let route = response.routes[0]
            mapView.removeOverlays(mapView.overlays)
            mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)

            let rect = route.polyline.boundingMapRect
            let edge = UIEdgeInsets(top: 75, left: 75, bottom: 75, right: 75)
            mapView.setVisibleMapRect(rect, edgePadding: edge, animated: true)
        }
    }
}
