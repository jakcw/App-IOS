//
//  FeedTableViewCell.swift
//  BabyApp
//
//  Created by Jack Westcott on 12/5/2023.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet var notes: UILabel!
    @IBOutlet var feedType: UILabel!
    @IBOutlet var feedDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
