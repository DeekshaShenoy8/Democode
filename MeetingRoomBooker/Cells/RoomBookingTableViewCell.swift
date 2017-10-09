//
//  RoomBookingTableViewCell.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 19/09/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import UIKit


class RoomBookingTableViewCell: UITableViewCell {

    @IBOutlet weak var roomsDetailLabel: UILabel!
    @IBOutlet weak var roomsDetailTextField: UITextField!
    
       override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

