//
//  Bicycles.swift
//  Bikes
//
//  Created by Andy Geipel on 12/16/20.
//

import Foundation

struct Bicycles: Codable {
    var bikes: [bike]
}

struct bike: Codable {
    var date_stolen: Int?

    var frame_model: String?
    var id: Int?
    var is_stock_img: Bool?
    var large_img: String?
    var location_found: String?
    var manufacturer_name: String?
    var external_id: String?
    var registry_name: String?
    var registry_url: String?
    var serial: String?
    var status: String?
    var stolen: Bool?
    var stolen_location: String?
    var thumb: URL?
    var title: String?
    var url: String?
    var year: Int?
    var description: String?
}
