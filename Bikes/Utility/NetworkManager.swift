//
//  Network.swift
//  Bikes
//
//  Created by Andy Geipel on 12/16/20.
//

import Foundation
import CoreLocation

protocol UpdateStolenNearMe {
    func didUpdate(_ bikes: Bicycles)
}
protocol UpdateStolenSerialNumber {
    func didUpdate(_ bikes: Bicycles)
}

class NetworkManager {

    var updateStolenDelegate: UpdateStolenNearMe!
    var updateStolenSerialNumberDelgate: UpdateStolenSerialNumber!
    
        // Stores the session used in this class for unit testing mock (future todo)
        let session: URLSession

        // Dependency Injection + default argument for normal initialization
        init(session: URLSession = .shared) {
            self.session = session
        }
    
    var task: URLSessionDataTask?

    func getStolenBikesNearMe(location: CLLocationCoordinate2D) {
        let urlFromString =  "https://bikeindex.org:443/api/v3/search?page=1&per_page=30&location=\(location.latitude),\(location.longitude)&distance=50&stolenness=proximity"
        let components = URLComponents(string: urlFromString)
        var request = URLRequest(url: (components?.url!)!)
        request.httpMethod = "GET" // Optional, by default it's GET
        task?.cancel() //Guarantee only one task run at a time
        task = session.dataTask(with: request) { (data, response, error) in
        if let error = error {
          print(error.localizedDescription)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "noInternetAlert"), object: nil, userInfo: nil)
          return
        }
        guard let response = response as? HTTPURLResponse else {
          return
        }

        let statusCode = response.statusCode
        guard (200...299).contains(statusCode) else {
          return
        }
        guard let data = data else {
          return
        }
        let decoder = JSONDecoder()
        let result = try! decoder.decode(Bicycles.self, from: data)
        // Update delegate on StolenNearbyVC to display result on the TableView
        self.updateStolenDelegate.didUpdate(result)
      }
      task?.resume()
    }

    func getStolenBikesBySerialNumber(serialNumber: String) {
        let urlFromString =  "https://bikeindex.org:443/api/v3/search/close_serials?page=1&per_page=25&serial=\(serialNumber)&location=IP&distance=10000&stolenness=stolen"
        let components = URLComponents(string: urlFromString)
        var request = URLRequest(url: (components?.url!)!)
        
        request.httpMethod = "GET" // Optional, by default it's GET
        // Guarantee only one task run at a time
        task = session.dataTask(with: request) { (data, response, error) in
        if let error = error {
          print(error.localizedDescription)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "noInternetAlert"), object: nil, userInfo: nil)
          return
        }
        guard let response = response as? HTTPURLResponse else {
          return
        }
        let statusCode = response.statusCode
        guard (200...299).contains(statusCode) else {
          return
        }
        guard let data = data else {
          return
        }
        let decoder = JSONDecoder()
        let result = try! decoder.decode(Bicycles.self, from: data)
        // Update delegate on SearchBikesVC to display result on BikePopOverVC
        self.updateStolenSerialNumberDelgate.didUpdate(result)
      }
      task?.resume()
    }
}
