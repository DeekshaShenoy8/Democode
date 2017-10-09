
import UIKit
import Firebase
import FirebaseDatabase

class RoomsTableVC: BaseViewController {
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
        
        
        let userEmail = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail)
        
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
        
        navigationItem.title = NavigationTitle.rooms
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .done, target: self, action: #selector(addTapped))
        navigationController?.navigationBar.barTintColor = UIColor(red: 81.0/255.0, green: 38.0/255.0, blue: 69.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor =  .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
    }
    
    //On navigation bar profile tap action
    func addTapped() {
        let userProfileVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: UserProfileTableVC.self) ) as! UserProfileTableVC
        self.navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    
    //Logout button click action
    @IBAction func onLogoutAction(_ sender: Any) {
        
        //let userData = UserDefaults.standard
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.userEmail) //Will delete the userDefaults
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.userPassword)
        UserDefaults.standard.synchronize()
        
        if let mainVC = navigationController?.viewControllers[0] {
            self.navigationController?.popToViewController(mainVC, animated: true)
        }
        
    }
    
    
    //Fetch room detail from firebase
    func fetchmeetingRoom()  {
        tableView.reloadData()
        startActivityIndicator()

        meetingRoom.fetchRoomsFromDatabase(entityName: FirebaseRoomData.entity, complete : { [weak self] (success) in
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



extension RoomsTableVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetingRoom.roomdetails.count
    }
    
    //Display room name in table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RoomsTableViewCell.self), for: indexPath) as! RoomsTableViewCell
        cell.roomsNameLabel.text =  meetingRoom.roomdetails[indexPath.row].RoomName
        return cell
    }
    
    
    //On room name(cell) click action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let roomsDetailVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: RoomsDetailVC.self) ) as! RoomsDetailVC
        roomsDetailVC.meetingRoomdetails.roomdetail.RoomName = meetingRoom.roomdetails[indexPath.row].RoomName
        roomsDetailVC.meetingRoomdetails.roomdetail.Capacity = meetingRoom.roomdetails[indexPath.row].Capacity
        roomsDetailVC.meetingRoomdetails.roomdetail.facility = meetingRoom.roomdetails[indexPath.row].facility
        
        self.navigationController?.pushViewController(roomsDetailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
