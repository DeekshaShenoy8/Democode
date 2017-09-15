//
//  CalanderTableViewCell.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 11/09/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import UIKit

class CalanderTableViewCell: UITableViewCell {
  
    @IBOutlet weak var timeCellLabel: UILabel!
    
    @IBOutlet weak var roomNameLbel: UILabel!

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var timeCellText: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
