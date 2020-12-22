//
//  DetailNearMeVC.swift
//  Bikes
//
//  Created by Andy Geipel on 12/17/20.
//

import UIKit
import SDWebImage

class BikePopoverVC: UIViewController {
    
    var tempBike = bike()
    var bikeImage = UIImage(named: "icons8-bicycle")

    @IBAction func dismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var featuredBikeImage: UIImageView!

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var manufacturerLbl: UILabel!
    @IBOutlet weak var frameLbl: UILabel!
    @IBOutlet weak var locationLbll: UILabel!
    @IBOutlet weak var serialLbl: UILabel!
    @IBOutlet weak var colorsLbl: UILabel!
    @IBOutlet weak var stolenDateLbl: UILabel!
    
    func updateUI() {
        featuredBikeImage.image = bikeImage
        featuredBikeImage.contentMode = .scaleAspectFill

        if let thumb = tempBike.thumb {
            // Use SDWebImage to get image from URL async
            // swiftlint:disable:next line_length
            featuredBikeImage!.sd_setImage(with: URL(string: "\(thumb)"), placeholderImage: UIImage(named: "icons8-bicycle"))
        }

        if let year = tempBike.year {
            dateLbl.text = "\(year)"
        }

        manufacturerLbl.text = tempBike.manufacturer_name
        frameLbl.text = tempBike.frame_model
        locationLbll.text = tempBike.location_found
        serialLbl.text = tempBike.serial
        if let stolenDate = tempBike.date_stolen {
            stolenDateLbl.text = "\(stolenDate)" }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()

    }

}
