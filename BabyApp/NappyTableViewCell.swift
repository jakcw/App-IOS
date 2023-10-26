//
//  HistoryUITableViewCellTwo.swift
//  BabyApp
//
//  Created by Jack Westcott on 12/5/2023.
//

import UIKit

class NappyTableViewCell: UITableViewCell {

    @IBOutlet var dateTime: UILabel!
    @IBOutlet var entryType: UILabel!
    @IBOutlet var notes: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
