//
//  HomeTableViewCell.swift
//  AirPlayDevices
//
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelIP: UILabel!
    @IBOutlet weak var labelName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
