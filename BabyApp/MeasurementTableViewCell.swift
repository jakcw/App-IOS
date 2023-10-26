//
//  MeasurementTableViewCell.swift
//  BabyApp
//
//  Created by Jack Westcott on 12/5/2023.
//

import UIKit

class MeasurementTableViewCell: UITableViewCell {
    
    @IBOutlet var measureDate: UILabel!
    @IBOutlet var notes: UILabel!
    @IBOutlet var measurements: UILabel!
        override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
