
import UIKit
import Firebase
import FirebaseDatabase

class RoomsDetailViewController: BaseViewController {
    
    @IBOutlet weak var roomNameTextField: UITextField!
    
    @IBOutlet weak var capacityTextField: UITextField!
    
    @IBOutlet weak var facilityTextView: UITextView!
    
    var meetingRoomdetails = MeetingRoom()
   // var facilityArray = [String]()
   // var roomname :String?
   // var databaseReference : DatabaseReference?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "Room Detail "
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "BookRoom", style: .done, target: self, action: #selector(bookRoomTapped))
       // databaseReference = Database.database().reference()
        fetchDetail()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //ON Book Room click : move to next view Controller
    func bookRoomTapped() {
        
        let roomBookingTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoomBookingTableViewController") as! RoomBookingTableViewController
        
            roomBookingTableVC.roomname = meetingRoomdetails.roomdetail.RoomName
            roomBookingTableVC.actualCapacity = meetingRoomdetails.roomdetail.Capacity
            roomBookingTableVC.facilityArray = meetingRoomdetails.roomdetail.facility
        
        self.navigationController?.pushViewController(roomBookingTableVC, animated: true)
        
    }
    
    
    //MARK: ACCESS DETAIL OF PARTICULAR ROOMNAME
    func fetchDetail(){
        
                self.roomNameTextField.text = meetingRoomdetails.roomdetail.RoomName
                self.capacityTextField.text = meetingRoomdetails.roomdetail.Capacity
                for facilities in (meetingRoomdetails.roomdetail.facility) {
                    //self.facilityArray.append(facilities)
                    self.facilityTextView.text.append(facilities)
                    self.facilityTextView.text.append("\n")
                }
            }
        }
