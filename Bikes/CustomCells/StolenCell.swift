//
//  StolenCell.swift
//  Bikes
//
//  Created by Andy Geipel on 12/16/20.
//

import UIKit

class StolenCell: UITableViewCell {

    @IBOutlet weak var manufacturerLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var bikeImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var seriaNumLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 8, bottom: 7, right: 8))
    }

}
