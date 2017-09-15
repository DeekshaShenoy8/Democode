//
//  RoomsTableViewCell.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 09/09/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import UIKit

class RoomsTableViewCell: UITableViewCell {
    @IBOutlet weak var roomsNameLabel: UILabel!
  

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func nextButtonAction(_ sender: Any) {
        
    }
   
}
