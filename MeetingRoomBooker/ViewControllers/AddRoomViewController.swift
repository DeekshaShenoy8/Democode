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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        databaseref = Database.database().reference()
        
        navigationItem.title = "Add Room"
        
        projectorChechbox.isSelected = false
        wifiCheckbox.isSelected = false
        laptopCheckbox.isSelected = false
        microphoneCheckbox.isSelected = false
        
        roomNameTextField.delegate = self
        roomCapacityTextField.delegate = self
        
        textFieldBorder(textField: roomNameTextField, color : .black, edge: 40)
        textFieldBorder(textField: roomCapacityTextField, color : .black, edge: 40)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //set check image on checkbox button click
    func checkBoxClicked(button : UIButton, checkBoxString : String) {
        
        button.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        facility.append(checkBoxString)
    }
    
    //set uncheck image on checkbox button uncheck
    func checkBoxUnchecked(button: UIButton, checkBoxString : String)  {
        
        button.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        if let index = facility.index(of: checkBoxString) {
            facility.remove(at: index)
        }
    }
    
    
    //checkbox button click action
    @IBAction func onCheckBoxClickAction(_ sender: UIButton) {
        var checkBoxString = " "
        
        switch sender.tag {
        case 0: checkBoxString = "projector"
        projectorChechbox.isSelected = !projectorChechbox.isSelected
        case 1: checkBoxString = "wifi"
        wifiCheckbox.isSelected = !wifiCheckbox.isSelected
        case 2: checkBoxString = "laptop"
        laptopCheckbox.isSelected = !laptopCheckbox.isSelected
        case 3: checkBoxString = "microphone"
        microphoneCheckbox.isSelected = !microphoneCheckbox.isSelected
            
        default:
            break
            
        }
        
        if sender.isSelected == true {
            checkBoxClicked(button: sender, checkBoxString: checkBoxString)
            
        } else {
            checkBoxUnchecked(button: sender, checkBoxString: checkBoxString)
            
        }
        
    }
    
    //on alert cancel title click, move to home page VC
    func alertAddingRoom(title: String, message :  String, cancelTitle : String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.default, handler: {action in
            if let controller = self.navigationController?.viewControllers[0] {
                self.navigationController?.popToViewController(controller, animated: true)
            }
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    // add Rooms to firebase database
    @IBAction func addRoomToDatabse(_ sender: Any) {
        
        guard ( (roomNameTextField.text?.isEmpty)! || (roomCapacityTextField.text?.isEmpty)!) else {
            
            if let roomName = roomNameTextField.text, let roomCapacity = roomCapacityTextField.text {
                
                databaseref?.child("rooms").child(roomName).setValue(["RoomName": roomName, "Capacity": roomCapacity, "facility" : facility])
                alertAddingRoom(title: "room added succesfully", message: "Thank you ", cancelTitle: "OK")
                
                
            }
            return
        }
        
        addAlert(title: "PLEASE FILL ALL THE DETAIL", message: "Try again", cancelTitle: "OK")
    }
    
}



extension AddRoomViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if roomNameTextField.isFirstResponder {
            
            roomCapacityTextField.becomeFirstResponder()
        }
        else if roomCapacityTextField.isFirstResponder {
            
            roomCapacityTextField.resignFirstResponder()
            return true
        }
        
        return false
    }
    
}

