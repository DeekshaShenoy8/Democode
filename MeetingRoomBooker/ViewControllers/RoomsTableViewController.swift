
import UIKit
import Firebase
import FirebaseDatabase

class RoomsTableViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var nextArrowButton: UIButton!
    
    var meetingRoom = MeetingRoom()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //To set navigationBar color, text
        setNavigationBarDetails()
        
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        //To display meeting rooms name
        fetchmeetingRoom()
        
        let userData = UserDefaults.standard
        let userEmail = userData.string(forKey: "userName")
        
        if(userEmail != "admin@gmail.com")
        {
            navigationItem.hidesBackButton = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
      
    }
    
    //Navigation bar title & color settings
    func setNavigationBarDetails() {
        
        navigationItem.title = "Rooms"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .done, target: self, action: #selector(addTapped))
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor =  .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "primaryHex") , for: .default)
        navigationController?.navigationBar.backgroundColor = UIColor.init(red: 81/255, green: 38/255, blue: 69/255, alpha: 1.0)
        
    }
    
    //On navigation bar profile tap action
    func addTapped() {
        
        let userProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileTableViewController") as! UserProfileTableViewController
        
        self.navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    
    //Logout button click action
    @IBAction func onLogoutAction(_ sender: Any) {
        
        let userData = UserDefaults.standard
        userData.removeObject(forKey: "userName") //Will delete the userDefaults
        userData.removeObject(forKey: "userPassword")
        userData.synchronize()
        
        if let mainVC = navigationController?.viewControllers[0] {
            
            self.navigationController?.popToViewController(mainVC, animated: true)
            
        }
        
    }
    
    
    //Fetch room detail from firebase
    func fetchmeetingRoom()  {
        
        tableView.reloadData()
        startActivityIndicator()
        
        meetingRoom.fetchRoomsFromDatabase(entityName: "rooms", complete : { [weak self] (success) in
            
            self?.stopActivityIndicator()
            if success {
                
                DispatchQueue.main.async(execute: {
                   // self?.fetchAvailableRoomsNow()
                    self?.tableView.reloadData()
                    
                })
            }
            
        })
        
    }
    
}



extension RoomsTableViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return meetingRoom.roomdetails.count
    }
    
    //Display room name in table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RoomsTableViewCell
        cell.roomsNameLabel.text =  meetingRoom.roomdetails[indexPath.row].RoomName
        return cell
        
    }
    
    
    //On room name(cell) click action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let roomsDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "RoomsDetailViewController") as! RoomsDetailViewController
        roomsDetailVC.meetingRoomdetails.roomdetail.RoomName = meetingRoom.roomdetails[indexPath.row].RoomName
        roomsDetailVC.meetingRoomdetails.roomdetail.Capacity = meetingRoom.roomdetails[indexPath.row].Capacity
        roomsDetailVC.meetingRoomdetails.roomdetail.facility = meetingRoom.roomdetails[indexPath.row].facility
        
        self.navigationController?.pushViewController(roomsDetailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
