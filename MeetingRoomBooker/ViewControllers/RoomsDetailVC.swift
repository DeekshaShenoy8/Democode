
import UIKit
import Firebase
import FirebaseDatabase

class RoomsDetailVC: BaseViewController {
    
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var capacityTextField: UITextField!
    @IBOutlet weak var facilityTextView: UITextView!
    
    var meetingRoomdetails = MeetingRoom()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = NavigationTitle.roomDetail
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "BookRoom", style: .done, target: self, action: #selector(bookRoomTapped))
        
        fetchDetail()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //ON Book Room click : move to next view Controller
    func bookRoomTapped() {
        
        let roomBookingTableVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: RoomBookingTableVC.self)) as! RoomBookingTableVC
        
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
            
            self.facilityTextView.text.append(facilities)
            self.facilityTextView.text.append("\n")
        }
    }
}
