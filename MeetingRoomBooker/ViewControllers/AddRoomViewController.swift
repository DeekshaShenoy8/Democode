//
//  AddRoomViewController.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 08/09/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddRoomViewController: BaseViewController {

    @IBOutlet weak var projectorChechbox: UIButton!
    @IBOutlet weak var wifiCheckbox: UIButton!
    @IBOutlet weak var laptopCheckbox: UIButton!
    @IBOutlet weak var microphoneCheckbox: UIButton!
   
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var roomCapacityTextField: UITextField!
    
    var databaseref : DatabaseReference?
    var databaseHandle :DatabaseHandle?
    
    var facility = [String]()
    
    var checkimage = #imageLiteral(resourceName: "check")
    var uncheckimage = #imageLiteral(resourceName: "uncheck")
    
    var projectorBool : Bool = false
    var microphoneBool : Bool = false
    var wifiBool : Bool = false
    var laptopBool : Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        databaseref = Database.database().reference()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setImageForButton( image: UIImage)
    {
        
    }
    
    
    
    
    @IBAction func projectorCheckboxChanged(_ sender: Any) {
        
        projectorBool = !projectorBool
        if projectorBool == true {
            projectorChechbox.setImage(checkimage, for: UIControlState.normal)
            facility.append("projector")
            
        }
        else {
            projectorChechbox.setImage(uncheckimage, for: UIControlState.normal)
            if  let index = facility.index(of: "projector")
            {
            facility.remove(at: index)
            }
        }

    }
    
    @IBAction func wifiCheckBoxChanged(_ sender: Any) {
        wifiBool = !wifiBool
        if wifiBool == true {
            wifiCheckbox.setImage(checkimage, for: UIControlState.normal)
            facility.append("wifi")
        }
        else {
            wifiCheckbox.setImage(uncheckimage, for: UIControlState.normal)
            if  let index = facility.index(of: "wifi")
            {
                facility.remove(at: index)
            }
        }

    }
    
    
    @IBAction func laptopCheckBoxChanged(_ sender: Any) {
        laptopBool = !laptopBool
        if laptopBool == true {
            laptopCheckbox.setImage(checkimage, for: UIControlState.normal)
            facility.append("laptop")
        }
        else {
           laptopCheckbox.setImage(uncheckimage, for: UIControlState.normal)
            if  let index = facility.index(of: "laptop")
            {
                facility.remove(at: index)
            }
        }
        
    }
    
    
    @IBAction func microphoneCheckboxChanged(_ sender: Any) {
        
        microphoneBool = !microphoneBool
        
        if microphoneBool == true {
            microphoneCheckbox.setImage(checkimage, for: UIControlState.normal)
            facility.append("microphoone")
        }
        else {
            microphoneCheckbox.setImage(uncheckimage, for: UIControlState.normal)
            if  let index = facility.index(of: "microphoone")
            {
                facility.remove(at: index)
            }
        }
    }
  
    
    @IBAction func addRoomToDatabse(_ sender: Any) {
       
        guard ( (roomNameTextField.text?.isEmpty)! || (roomCapacityTextField.text?.isEmpty)!) else {
        
        if let roomName = roomNameTextField.text, let roomCapacity = roomCapacityTextField.text {
       
            databaseref?.child("rooms").child(roomName).setValue(["RoomName": roomName, "Capacity": roomCapacity, "facility" : facility])
            addAlert(title: "room added succesfully", message: "Thank you ", cancelTitle: "OK")
            
            
            }
            return
        }
        
    addAlert(title: "PLEASE FILL ALL THE DETAIL", message: "Try again", cancelTitle: "OK")
    }
    
  
    
  
}
