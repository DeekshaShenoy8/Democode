
import UIKit
import Firebase
import FirebaseDatabase

class RoomsTableViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var nextArrowButton: UIButton!
    
    var meetingRoom = MeetingRoom()
    let cellId = "cell"
    
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
        navigationItem.title = "Rooms "
        
        if(userEmail != "admin@gmail.com")
        {
            navigationItem.hidesBackButton = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigationBarDetails() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .done, target: self, action: #selector(addTapped))
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor =  .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "primaryHex") , for: .default)
        navigationController?.navigationBar.backgroundColor = UIColor.init(red: 81, green: 38, blue: 69, alpha: 1.0)
        
    }
    
    //On navigation bar view schedule tap action
    func addTapped() {
        
        let userProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserProfileTableViewController") as! UserProfileTableViewController
        
        self.navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    
    // logout button click action
    @IBAction func onLogoutAction(_ sender: Any) {
        let userData = UserDefaults.standard
        userData.removeObject(forKey: "userName") //We Will delete the userDefaults
        userData.removeObject(forKey: "userPassword")
        userData.synchronize()
        print(navigationController?.viewControllers[0] as Any)
        print(navigationController?.viewControllers[1] as Any)
        

        if let mainVC = navigationController?.viewControllers[0] {
            self.navigationController?.popToViewController(mainVC, animated: true)
        }
        
    }
   
    
    //fetch room detail from firebase
    func fetchmeetingRoom()  {
        
        tableView.reloadData()
        startActivityIndicator()
        
       meetingRoom.fetchRoomsFromDatabase(entityName: "rooms", complete : { [weak self] (success) in
        
       self?.stopActivityIndicator()
        if success {
            
            DispatchQueue.main.async(execute: {
                
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
    
    //display room name in table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RoomsTableViewCell
        cell.roomsNameLabel.text =  meetingRoom.roomdetails[indexPath.row].RoomName
        return cell
        
    }
    
    
    //on room name(cell) click action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let roomsDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoomsDetailViewController") as! RoomsDetailViewController
        //roomsDetailVC.roomname = meetingRoom.roomdetails[indexPath.row].RoomName
        roomsDetailVC.meetingRoomdetails = meetingRoom
        self.navigationController?.pushViewController(roomsDetailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}
