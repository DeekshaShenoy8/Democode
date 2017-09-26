//
//  RoomBookingCustomTableViewCell.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 19/09/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import UIKit

class RoomBookingCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var roomsDetailLabel: UILabel!
    
    @IBOutlet weak var roomDeatailTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
