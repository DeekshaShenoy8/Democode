
import UIKit
import Firebase
import FirebaseDatabase

class AddRoomVC: BaseViewController {
    
    @IBOutlet weak var projectorChechbox: UIButton!
    @IBOutlet weak var wifiCheckbox: UIButton!
    @IBOutlet weak var laptopCheckbox: UIButton!
    @IBOutlet weak var microphoneCheckbox: UIButton!
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var roomCapacityTextField: UITextField!
    
    var facility = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        navigationItem.title = NavigationTitle.addRoom
        
        projectorChechbox.isSelected = false
        wifiCheckbox.isSelected = false
        laptopCheckbox.isSelected = false
        microphoneCheckbox.isSelected = false
        
        textFieldBorder(textField: roomNameTextField, color : .black, edge: 40)
        textFieldBorder(textField: roomCapacityTextField, color : .black, edge: 40)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //Set check image on checkbox button click
    func checkBoxClicked(button : UIButton, checkBoxString : String) {
        button.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        facility.append(checkBoxString)
        print(facility)
    }
    
    
    //Set uncheck image on checkbox button uncheck
    func checkBoxUnchecked(button: UIButton, checkBoxString : String)  {
        button.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        if let index = facility.index(of: checkBoxString) {
            facility.remove(at: index)
        }
    }
    
    
    //Checkbox button click action
    @IBAction func onCheckBoxClickAction(_ sender: UIButton) {
        var checkBoxString = " "
        
        switch sender.tag {
        case 0:
            checkBoxString =  CheckBoxValue.projector //"projector"
            projectorChechbox.isSelected = !projectorChechbox.isSelected
        case 1:
            checkBoxString = CheckBoxValue.wifi
            wifiCheckbox.isSelected = !wifiCheckbox.isSelected
        case 2:
            checkBoxString = CheckBoxValue.laptop
            laptopCheckbox.isSelected = !laptopCheckbox.isSelected
        case 3:
            checkBoxString = CheckBoxValue.microphone
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
    
    
    func alertAddingRoom(title: String, message : String, cancelTitles: [String]) {
        
        alertController(title: title, message: message, cancelTitles: cancelTitles,actions: [{action1 in
            if let size = self.navigationController?.viewControllers.count {
                if let controller = self.navigationController?.viewControllers[size - 2] {
                    self.navigationController?.popToViewController(controller, animated: true)
                }
            }
            
            }])
    }
    
    
    //Add Rooms to firebase database, on AddRoom button press action
    @IBAction func addRoomToDatabse(_ sender: Any) {
        let meetingRoom = MeetingRoom()
        
        guard let roomName = roomNameTextField.text, let roomCapacity = roomCapacityTextField.text, !( (roomName.isEmpty) || (roomCapacity.isEmpty)) else {
            addAlert(title: EmptyFieldAlert.alertTitle, message: EmptyFieldAlert.message, cancelTitle: EmptyFieldAlert.cancelTile)
            return
        }
        
        meetingRoom.roomdetail.RoomName = roomName
        meetingRoom.roomdetail.Capacity = roomCapacity
        meetingRoom.roomdetail.facility = facility
        
        meetingRoom.loadRoomsToFirebaseDatabase {
            alertAddingRoom(title: SuccessAlert.roomAdded, message: SuccessAlert.message, cancelTitles: [SuccessAlert.cancelTitle])
        }
    }
}



extension AddRoomVC : UITextFieldDelegate {
    
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

