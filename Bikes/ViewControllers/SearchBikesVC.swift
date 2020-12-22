//
//  ViewController.swift
//  Bikes
//
//  Created by Andy Geipel on 12/16/20.
//

import UIKit
import CoreLocation

class SearchBikesVC: UIViewController, UIPopoverPresentationControllerDelegate, CLLocationManagerDelegate, UpdateStolenSerialNumber {

    let network = NetworkManager()
    let locationManager = UserLocationManager.shared

    var localBike = bike()

    var textFieldEntry = ""

    @IBOutlet weak var checkNumberEntry: UITextField!
    @IBAction func checkNumberEntry(_ sender: UITextField) {
        textFieldEntry = sender.text ?? ""
    }

    @IBOutlet weak var searchBtn: UIButton!
    @IBAction func searchBtn(_ sender: UIButton) {
        // Check if textField is empty and display spinner animation while network call returns list of stolen bikes
        // If not empty
        if textFieldEntry != "" {
            if CharacterCheck().entryCharacterCheck(entryToCheck: textFieldEntry) == true {
                self.showSpinner()
                network.getStolenBikesBySerialNumber(serialNumber: textFieldEntry)
            } else {
                Alerts().alert(view: self, title: "Sorry!", message: "Characters do not match serial numbers")
            }
        // If empty
        } else {
            Alerts().alert(view: self, title: "Empty Field", message: "Please enter your serial number")
        }
        //Clear t=extField
        textFieldEntry = ""
        checkNumberEntry.text = ""
    }
    // Delegate from Network class
    func didUpdate(_ bikes: Bicycles) {
        DispatchQueue.main.async {
            if bikes.bikes.isEmpty {
                Alerts().alert(view: self, title: "No bike found!", message: "No bike was found with that serial number")
                self.removeSpinner()
            } else {
                //Create BikeDetailVC and pass it returned Bicycle
                guard let popVC = self.storyboard?.instantiateViewController(withIdentifier: "BikeDetailVC") as? BikePopoverVC else { return }
                    popVC.tempBike = bikes.bikes[0]
                   popVC.modalPresentationStyle = .popover
                   let popOverVC = popVC.popoverPresentationController
                   popOverVC?.delegate = self
                   popVC.preferredContentSize = CGSize(width: 250, height: 250)
                   self.present(popVC, animated: true)
                //Clear the UI
                self.entryTextField.text = ""
                self.removeSpinner()
            }
        }
    }

    @IBOutlet weak var entryTextField: UITextField!
    @IBAction func entryTextField(_ sender: UITextField) {
    }
    
    // Demonstrate the entry of a stolen bicycle
    @IBOutlet weak var demoBtnStolen: UIButton!
    @IBAction func demoBtnStolen(_ sender: UIButton) {
        //Filter out incorrect characters
        let demoSerialNumber = "f1206k1236"
        if CharacterCheck().entryCharacterCheck(entryToCheck: demoSerialNumber) == true {
            entryTextField.text = demoSerialNumber
            textFieldEntry = demoSerialNumber
        } else {
            Alerts().alert(view: self, title: "Incorrect Characters", message: "Serial number characters must be letters or numbers")
        }
    }
    
    // Demonstrate the entry of a non-stolen bicycle
    @IBOutlet weak var demoBtnNonStolen: UIButton!
    @IBAction func demoBtnNonStolen(_ sender: UIButton) {
        let demoSerialNumber = "196h4k375m"
        if CharacterCheck().entryCharacterCheck(entryToCheck: demoSerialNumber) == true {
            entryTextField.text = demoSerialNumber
            textFieldEntry = demoSerialNumber
        } else {
            Alerts().alert(view: self, title: "Incorrect Characters", message: "Serial number characters must be letters")
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
        
        // UI
        searchBtn.layer.cornerRadius = 10.0
        demoBtnStolen.layer.cornerRadius = 10.0
        demoBtnNonStolen.layer.cornerRadius = 10.0
        
        locationManager.start()
        
        network.updateStolenSerialNumberDelgate = self

        }
}
