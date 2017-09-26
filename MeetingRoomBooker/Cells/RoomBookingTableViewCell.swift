//
//  RoomBookingTableViewCell.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 19/09/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import UIKit

//protocol CellResponder {
//    func setNextResponder(_ fromCell: UITableViewCell)
//}

class RoomBookingTableViewCell: UITableViewCell { //,UITextFieldDelegate {

    @IBOutlet weak var roomsDetailLabel: UILabel!
    @IBOutlet weak var roomsDetailTextField: UITextField!
    
    //var responder : CellResponder?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //roomsDetailTextField.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        responder?.setNextResponder(self)
//        return true
//    }

}

//extension RoomBookingTableViewCell: UITextFieldDelegate {
//   
//        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//            
//            if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
//                nextField.becomeFirstResponder()
//                
//            } else {
//                textField.resignFirstResponder()
//                return true;
//            }
//            return false
//        }
//    
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        
//    }
//        
//    }
//
