//
//  AppDelegate.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 11/28/17.
//  Copyright © 2017 Cuong Doan M. All rights reserved.
//

import UIKit
import MapKit
import LGSideMenuController
import RealmSwift
import SVProgressHUD

typealias Hud = SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    typealias Action = (String?, (() -> Void)?)

    static let shared: AppDelegate = {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError(App.String.kAppDelegateError)
        }
        return delegate
    }()

    enum VC {
        case login
        case home
    }

    var window: UIWindow?
    lazy var locationManager = CLLocationManager()
    var mapView: MKMapView?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configDatabase()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        if userDefault.string(forKey: UserDefaults.Key.accessToken) == nil {
            changeRootView(vc: .login)
        } else {
            api.session.accessToken = userDefault.string(forKey: UserDefaults.Key.accessToken)
            changeRootView(vc: .home)
        }
        return false
    }

    fileprivate func configDatabase() {
        Realm.Configuration.defaultConfiguration = {
            var config = Realm.Configuration.defaultConfiguration
            config.deleteRealmIfMigrationNeeded = true
            return config
        }()
    }

    // MARK: - Public
    func chooseViewController(vc: VC) -> UIViewController {
        let vcChose: UIViewController
        switch vc {
        case .login:
            vcChose = LoginViewController()
            return UINavigationController(rootViewController: vcChose)
        case .home:
            vcChose = HomeViewController()
            let navigationController = UINavigationController(rootViewController: vcChose)
            let sideMenuController = LGSideMenuController(rootViewController: navigationController)
            sideMenuController.leftViewController = SideMenuViewController()
            sideMenuController.leftViewWidth = 3 * UIScreen.main.bounds.width / 4
            sideMenuController.leftViewPresentationStyle = .slideBelow
            return sideMenuController
        }
    }

    func changeRootView(vc: VC) {
        let rootVC = chooseViewController(vc: vc)
        window?.rootViewController = rootVC
    }

    func showAlert(title: String, message: String, actions: [Action]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            if let handler = action.1 {
                let alertAction = UIAlertAction(title: action.0, style: .default, handler: { (_) in
                    handler()
                })
                alert.addAction(alertAction)
            } else {
                let alertAction = UIAlertAction(title: action.0, style: .default, handler: nil)
                alert.addAction(alertAction)
            }
        }
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

// MARK: - AppDelegate
extension AppDelegate {
    func configLocationService() {
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            enableLocationServices()
            startStandardLocationService()
        case .denied:
            let title = App.String.kAlertRequestTitle
            let message = App.String.kAlertRequestMessage
            let action: Action = (App.String.ok, nil)
            showAlert(title: title, message: message, actions: [action])
        case .restricted:
            break
        }
    }

    func enableLocationServices() {
        CLLocationManager.locationServicesEnabled()
    }

    func startStandardLocationService() {
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 500
        locationManager.startUpdatingLocation()
    }

    func stopStandardLocationService() {
        locationManager.stopUpdatingLocation()
    }

    func startSignificantChangeLocationService() {
        locationManager.startMonitoringSignificantLocationChanges()
    }

    func stopSignificantChangeLocationService() {
        locationManager.stopMonitoringSignificantLocationChanges()
    }
}

// MARK: - CLLocationManager Delegate
extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            stopStandardLocationService()
        case .authorizedWhenInUse, .authorizedAlways:
            enableLocationServices()
            startStandardLocationService()
        case .notDetermined:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        let region = MKCoordinateRegion(center: (lastLocation.coordinate), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView?.setRegion(region, animated: true)
        manager.stopUpdatingLocation()
    }
}
