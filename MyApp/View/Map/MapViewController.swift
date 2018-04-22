//
//  MapViewController.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 12/13/17.
//  Copyright © 2017 Cuong Doan M. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MVVM

final class MapViewController: BaseController {

    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var sliderGroupView: [UIView]!
    @IBOutlet weak var sliderRadius: UISlider!

    // MARK: - Properties
    var viewModel = MapViewModel()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
        configData()
        mapView.delegate = self
        AppDelegate.shared.configLocationService()
        mapView.showsUserLocation = true
        mapView.removeOverlays(mapView.overlays)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Private
    private func configView() {
        title = viewModel.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_list"), style: .plain, target: self, action: #selector(showSideMenu))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_refresh"), style: .plain, target: self, action: #selector(refreshLocation))
        configBarColor()
        sliderRadius.maximumTrackTintColor = App.Color.extraColor
        sliderRadius.minimumTrackTintColor = App.Color.mainColor
        sliderRadius.thumbTintColor = App.Color.mainColor
        sliderGroupView.forEach { (view) in
            view.corner = UIView.cornerView(view: view)
            if view == sliderGroupView[0] {
                view.backgroundColor = App.Color.mainColor
            } else {
                view.backgroundColor = App.Color.extraColor
            }
        }
    }

    private func configData() {
        viewModel.getListPromotion { [weak self](result) in
            guard let this = self else { return }
            switch result {
            case .success:
                Hud.dismiss()
            case .failure(let msg):
                this.alert(msg: msg)
            }
        }
    }

    private func getAnnotation() {
        viewModel.getAnnotation()
        mapView.addAnnotations(viewModel.annotations)
    }

    private func updateLocation() {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        guard let center = viewModel.center else { return }
        let region = MKCoordinateRegionMakeWithDistance(center,
                                                        CLLocationDistance(2 * viewModel.radius + 200),
                                                        CLLocationDistance(2 * viewModel.radius + 200))
        let overlayCircle = MKCircle(center: center, radius: CLLocationDistance(viewModel.radius))
        mapView.setRegion(region, animated: true)
        mapView.add(overlayCircle)
        getAnnotation()
    }

    private func pushToDetailView(id: Int) {
        let vc = DetailViewController()
        vc.viewModel.id = id
        sideMenuController?.leftViewController = nil
        navigationController?.pushViewController(vc, animated: true)
    }

    private func showTinderView() {
        let tinderView: MapBranchView = MapBranchView.loadNib()
        tinderView.frame = view.bounds
        tinderView.viewModel = viewModel.viewModelForItem()
        view.addSubview(tinderView)
        tinderView.delegate = self
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    // MARK: - IBActions
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let value = sliderRadius.value
        switch value {
        case 1_000..<2_000:
            sliderRadius.setValue(1_000, animated: true)
            sliderGroupView[1].backgroundColor = App.Color.extraColor
            sliderGroupView[2].backgroundColor = App.Color.extraColor
            sliderGroupView[3].backgroundColor = App.Color.extraColor
            sliderGroupView[4].backgroundColor = App.Color.extraColor
        case 2_000..<4_000:
            sliderRadius.setValue(3_000, animated: true)
            sliderGroupView[1].backgroundColor = App.Color.mainColor
            sliderGroupView[2].backgroundColor = App.Color.extraColor
            sliderGroupView[3].backgroundColor = App.Color.extraColor
            sliderGroupView[4].backgroundColor = App.Color.extraColor
        case 4_000..<6_000:
            sliderRadius.setValue(5_000, animated: true)
            sliderGroupView[1].backgroundColor = App.Color.mainColor
            sliderGroupView[2].backgroundColor = App.Color.mainColor
            sliderGroupView[3].backgroundColor = App.Color.extraColor
            sliderGroupView[4].backgroundColor = App.Color.extraColor
        case 6_000..<8_000:
            sliderRadius.setValue(7_000, animated: true)
            sliderGroupView[1].backgroundColor = App.Color.mainColor
            sliderGroupView[2].backgroundColor = App.Color.mainColor
            sliderGroupView[3].backgroundColor = App.Color.mainColor
            sliderGroupView[4].backgroundColor = App.Color.extraColor
        default:
            sliderRadius.setValue(9_000, animated: true)
            sliderGroupView[1].backgroundColor = App.Color.mainColor
            sliderGroupView[2].backgroundColor = App.Color.mainColor
            sliderGroupView[3].backgroundColor = App.Color.mainColor
            sliderGroupView[4].backgroundColor = App.Color.mainColor
            viewModel.radius = 15_000
            updateLocation()
            return
        }
        viewModel.radius = sliderRadius.value
        updateLocation()
    }

    @IBAction func regionDidChange(_ sender: UIButton) {
        mapView(mapView, didUpdate: mapView.userLocation)
        updateLocation()
    }

    // MARK: - objc Private
    @objc func showSideMenu() {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }

    @objc func refreshLocation() {
        viewModel.center = mapView.centerCoordinate
        updateLocation()
    }
}

// MARK: MKMapView Delegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        viewModel.center = userLocation.coordinate
        if mapView.overlays.isEmpty {
            updateLocation()
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PinAnnotation else { return nil }
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: App.String.Map)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: App.String.Map)
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            pinView?.canShowCallout = true
            pinView?.calloutOffset = CGPoint(x: 0, y: 0)
            pinView?.contentMode = .scaleAspectFill
            pinView?.image = #imageLiteral(resourceName: "ic_pinSel")
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let drawRoute = RouteBetweenTwoAnnotations()
        if let annotation = view.annotation {
            drawRoute.drawRoute(mapView, annotation, mapView.userLocation)
        }
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? PinAnnotation else { return }
        let id = annotation.id
        viewModel.getListBranch(id: id)
        showTinderView()
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = #colorLiteral(red: 0.6263254285, green: 0.7929193377, blue: 0, alpha: 1)
            renderer.lineWidth = 5.0
            return renderer
        }
        if let circle = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: circle)
            circleRenderer.fillColor = #colorLiteral(red: 0.5632263422, green: 0.7628647685, blue: 0, alpha: 0.2450235445)
            circleRenderer.strokeColor = #colorLiteral(red: 0.1150010899, green: 0.6517065763, blue: 0.3915095031, alpha: 0.5)
            circleRenderer.lineWidth = 3
            circleRenderer.lineDashPhase = 10
            return circleRenderer
        }
        return MKOverlayRenderer()
    }
}

// MARK: - MapBranchView Delegate
extension MapViewController: MapBranchViewDelegate {
    func mapBranch(_ view: MapBranchView, needsPerformAction action: MapBranchView.Action) {
        switch action {
        case .remove:
            navigationItem.rightBarButtonItem?.isEnabled = true
        case .push(let id):
            pushToDetailView(id: id)
        }
    }
}
