//
//  StolenTableVC.swift
//  Bikes
//
//  Created by Andy Geipel on 12/16/20.
//

import UIKit
import CoreLocation

class StolenNearbyVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, UpdateStolenNearMe {

    let network = NetworkManager()
    let locationManager = UserLocationManager.shared

    @IBOutlet weak var stolenTableView: UITableView!
    @IBOutlet weak var topSectionBackground: UIView!


    var tempBikes = Bicycles(bikes: [])

    // Delegate from Network class
    func didUpdate(_ bikes: Bicycles) {
        for i in bikes.bikes {
            tempBikes.bikes.append(i)
        }
        DispatchQueue.main.async {
            // Update UI
            self.removeSpinner()
            self.stolenTableView.reloadData()
        }
    }
    
    // Handle no internet; received from Network class
    @objc func noInternetAlert() {
        Alerts().alert(view: self, title: "No internet", message: "Please connect to a network")
        DispatchQueue.main.async() {
            self.removeSpinner()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(noInternetAlert), name: NSNotification.Name(rawValue: "noInternetAlert"), object: nil)
        
        network.updateStolenDelegate = self
        
        self.showSpinner()
        // Fetch array of stolen bikes from the network using CLLlocation coordinates
        network.getStolenBikesNearMe(location: locationManager.userLongLatLocation)
        
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempBikes.bikes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StolenCell", for: indexPath) as! StolenCell

        cell.manufacturerLbl.text = tempBikes.bikes[indexPath.row].manufacturer_name ?? ""

        if let year = tempBikes.bikes[indexPath.row].year {
            cell.yearLbl.text = "\(year)" 
        } else {
            cell.yearLbl.text = ""
        }

        if let bikeImage = tempBikes.bikes[indexPath.row].thumb {
            // Use SDWebImage to retreive images from URL
            // swiftlint:disable:next line_length
            cell.bikeImage!.sd_setImage(with: URL(string: "\(bikeImage)"), placeholderImage: UIImage(named: "icons8-bicycle"))
        }
        cell.seriaNumLbl.text = tempBikes.bikes[indexPath.row].serial ?? ""
        cell.locationLabel.text = tempBikes.bikes[indexPath.row].stolen_location ?? ""

        let radius: CGFloat = 5
        cell.contentView.layer.cornerRadius = radius
        // Mask the inside view
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        cell.layer.shadowRadius = 7.0
        cell.layer.shadowOpacity = 0.2
        cell.layer.masksToBounds = false
        // Matching the contentView radius here will keep the shadow
        // in sync with the contentView's rounded shape
        cell.layer.cornerRadius = radius
        // Prevent selection visual artifacts
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        // Cascading fade-in UI effect
        cell.alpha = 0
            UIView.animate(
                withDuration: 0.8,
                delay: 0.06 * Double(indexPath.row),
                animations: {
                cell.alpha = 1
            })

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Create new BikePopoverVC and pass bikes
             guard let popVC = storyboard?.instantiateViewController(withIdentifier: "BikeDetailVC") as? BikePopoverVC else { return }
                popVC.tempBike = tempBikes.bikes[indexPath.row]
                popVC.modalPresentationStyle = .popover
                let popOverVC = popVC.popoverPresentationController
                popOverVC?.delegate = self
                popVC.preferredContentSize = CGSize(width: 250, height: 250)
                self.present(popVC, animated: true)
    }
}
