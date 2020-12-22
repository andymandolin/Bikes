//
//  LocationServices.swift
//  Bikes
//
//  Created by Andy Geipel on 12/20/20.
//

import MapKit

class UserLocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = UserLocationManager()
    let locationManager: CLLocationManager

    // Location starts in Madison, WI
    var userLongLatLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 43.0731, longitude: -89.4012) {
        didSet {
            print("userLongLatLocation updated")
        }
    }

    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        super.init()
        locationManager.delegate = self
    }

    func start() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            print("locationManager didUpdateLocations error")
            return
        }
        userLongLatLocation = mostRecentLocation.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager error \(error)")
        locationManager.stopUpdatingLocation()
    }
}
