//
//  RoomBookingCheckBoxTableViewCell.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 20/09/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import UIKit

class RoomBookingCheckBoxTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBoxTitleLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
