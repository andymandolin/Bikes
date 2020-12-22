//
//  NearMeTableVC.swift
//  Bikes
//
//  Created by Andy Geipel on 12/16/20.
//

import UIKit
import MapKit
import CoreLocation

class LocateStoresVC: UIViewController, MKMapViewDelegate {
    
    let locationManager = UserLocationManager.shared
    
    @IBOutlet private var mapView: MKMapView!

    func centerViewOnUserLocation(userLocation: CLLocationCoordinate2D) {
        // Set view and search area size in meteres
        let region = MKCoordinateRegion.init(center: userLocation, latitudinalMeters: 20000, longitudinalMeters: 20000)
            
            mapView.setRegion(region, animated: true)

            //MARK: - Search
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = "bicycle"
            searchRequest.region = mapView.region

            let search = MKLocalSearch(request: searchRequest)

            search.start { response, error in
                guard let response = response else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error").")
                    Alerts().alert(view: self, title: "No internet", message: "Please connect to a network")
                    return
                }
                // Annotate map with locations and info
                    for item in response.mapItems {
                          let annotation = MKPointAnnotation()
                          annotation.title = item.name
                        annotation.subtitle = item.phoneNumber
                          annotation.coordinate = item.placemark.coordinate
                          DispatchQueue.main.async {
                              self.mapView.addAnnotation(annotation)
                          }
                }
            }
    }
    
    // Open Apple Maps and pass placemark location for immediate use
    func openMapsAppWithDirections(to coordinate: CLLocationCoordinate2D, destinationName name: String) {
      let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
      let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = name // Provide the name of the destination in the To: field
        mapItem.openInMaps(launchOptions: options)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //  Mapview properties
        mapView.layer.cornerRadius = 10.0
        mapView.showsUserLocation = true
        // Center and zoom on user location provided by LocationManager
        centerViewOnUserLocation(userLocation: locationManager.userLongLatLocation)
    }

        // MARK: - mapView Methods
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {return nil}

            let reuseId = "pin"

            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.animatesDrop = true
                let calloutButton = UIButton(type: .detailDisclosure)
                pinView!.rightCalloutAccessoryView = calloutButton
                pinView!.sizeToFit()
            } else {
                pinView!.annotation = annotation
            }

            return pinView
        }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if control == view.rightCalloutAccessoryView {
                if let optionalTitle = view.annotation?.title {
                    openMapsAppWithDirections(to: view.annotation!.coordinate, destinationName: (optionalTitle!))
                 }
            }
        }
}
