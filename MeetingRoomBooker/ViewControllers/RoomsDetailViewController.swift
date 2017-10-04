
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
        fetchDetail()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //ON Book Room click : move to next view Controller
    func bookRoomTapped() {
        
        let roomBookingTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoomBookingTableViewController") as! RoomBookingTableViewController
        if let selectedRoomName = roomname , let roomCapacity = capacityTextField.text  {
            roomBookingTableVC.roomname = selectedRoomName
            roomBookingTableVC.actualCapacity = roomCapacity
            roomBookingTableVC.facilityArray = facilityArray
        }
        self.navigationController?.pushViewController(roomBookingTableVC, animated: true)
        
    }
    
    
    //MARK: ACCESS DETAIL OF PARTICULAR ROOMNAME
    func fetchDetail(){
        let bookMeetingRoom = BookMeetingRoom()
        bookMeetingRoom.getRoomDetail(roomname: roomname!) {[weak self] (success) in
            if success {
                self?.roomNameTextField.text = bookMeetingRoom.roomDetail.RoomName
                self?.capacityTextField.text = bookMeetingRoom.roomDetail.Capacity
                for facilities in (bookMeetingRoom.roomDetail.Facility) {
                    self?.facilityArray.append(facilities)
                    self?.facilityTextView.text.append(facilities)
                    self?.facilityTextView.text.append("\n")
                }
            }
        }
    }
    
}
