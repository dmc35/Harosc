//
//  MapViewCell.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 12/21/17.
//  Copyright © 2017 Cuong Doan M. All rights reserved.
//

import UIKit
import MapKit
import MVVM

private struct Config {
    static let distance: Double = 750
}

final class DetailMapCell: UITableViewCell, MVVM.View {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var mapView: MKMapView!

    // MARK: - Properties
    var viewModel: DetailMapCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            addMapToCell(viewModel.lat, viewModel.long, viewModel.title, viewModel.subtitle, viewModel.id)
        }
    }

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(stopMap), name: NSNotification.Name(rawValue: "StopMap"), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(Notification.Name(rawValue: "StopMap"))
    }

    // MARK: - objc Private
    @objc func stopMap() {
        if mapView != nil {
            mapView.removeAnnotations(mapView.annotations)
            mapView.mapType = .hybrid
            mapView.delegate = nil
            mapView.removeFromSuperview()
            mapView = nil
        }
    }

    // MARK: - Private
    private func addMapToCell(_ lat: Double, _ long: Double, _ title: String, _ subtitle: String, _ id: Int) {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegionMakeWithDistance(coordinate, Config.distance, Config.distance)
        mapView.setRegion(region, animated: true)

        let pin = PinAnnotation(title: title, subtitle: subtitle, latitude: lat, longitude: long, id: id)
        mapView.delegate = self
        mapView.addAnnotation(pin)
        mapView.selectAnnotation(pin, animated: true)
    }
}

// MARK: - MKMapView Delegate
extension DetailMapCell: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: App.String.PinAnnotation)
        pinView.image = #imageLiteral(resourceName: "ic_pinSel")
        pinView.canShowCallout = true
        return pinView
    }
}
