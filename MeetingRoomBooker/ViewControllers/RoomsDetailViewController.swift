//
//  RoomsDetailViewController.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 19/09/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RoomsDetailViewController: BaseViewController {
    
    @IBOutlet weak var roomNameTextField: UITextField!
    
    @IBOutlet weak var capacityTextField: UITextField!
    
    @IBOutlet weak var facilityTextView: UITextView!
    
    var facilityArray = [String]()
    var roomname :String?
    var databaseReference : DatabaseReference?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Room Detail "
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "BookRoom", style: .done, target: self, action: #selector(bookRoomTapped))
        databaseReference = Database.database().reference()
        fetchRoomDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bookRoomTapped() {
        
        let roomBookingTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoomBookingTableViewController") as! RoomBookingTableViewController
        if let selectedRoomName = roomname , let roomCapacity = capacityTextField.text  {
        roomBookingTableVC.roomname = selectedRoomName
            roomBookingTableVC.actualCapacity = roomCapacity
            roomBookingTableVC.facilityArray = facilityArray
        }
                self.navigationController?.pushViewController(roomBookingTableVC, animated: true)
        
    }
    func fetchRoomDetail()
    {
        databaseReference?.child("rooms").child(roomname!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                self.roomNameTextField.text = dictionary["RoomName"] as? String
                self.capacityTextField.text = dictionary["Capacity"] as? String
                self.facilityArray = dictionary["facility"] as! [String]
                
            }
            
            //display available facilities in text view
            for items in self.facilityArray {
                self.facilityTextView.text.append(items)
                self.facilityTextView.text.append("\n")
            }
            
        })
    }
    

    
}
