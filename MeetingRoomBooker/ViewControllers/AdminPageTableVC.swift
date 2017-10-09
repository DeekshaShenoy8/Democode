
import UIKit

class AdminPageTableVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var adminRights = ["Add User", "Add Room", "View Rooms", "View Schedule"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        navigationController?.navigationBar.barTintColor = UIColor(red: 81.0/255.0, green: 38.0/255.0, blue: 69.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor =  .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationItem.hidesBackButton = true
        
        tableView.tableFooterView = UIView()
      
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutTapped))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //On logout Tap
    func logoutTapped() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.userEmail) // Will delete the userDefaults
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.userPassword )
        UserDefaults.standard.synchronize()
        
        let isLoginPageIsPresentInNavigationStack = UserDefaults.standard.bool(forKey: UserDefaultKey.isLoginPageIsThereInNavigationStack)
        
        if isLoginPageIsPresentInNavigationStack == false {
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: LoginVC.self)) as! LoginVC
            let navigationController = UINavigationController(rootViewController: loginVC)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = navigationController
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        UserDefaults.standard.set(true, forKey: UserDefaultKey.isLoginPageIsThereInNavigationStack)
    }
}



extension AdminPageTableVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adminRights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AdminPageTableViewCell.self), for: indexPath) as? AdminPageTableViewCell
        cell?.adminLabel.text = adminRights[indexPath.row]
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
        
        switch  indexPath.row {
        case 0:
            let registerVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: RegistrationVc.self) ) as! RegistrationVc
        self.navigationController?.pushViewController(registerVC, animated: true)
            
        case 1 :
            let addRoomVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: AddRoomVC.self)) as! AddRoomVC
            self.navigationController?.pushViewController(addRoomVC, animated: true)
        
        case 2 :
            let roomsTableVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: RoomsTableVC.self) ) as! RoomsTableVC
            navigationController?.pushViewController(roomsTableVC, animated: true)
            
        case 3:
            let calendarTableVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: CalandarTableVC.self) ) as! CalandarTableVC
            self.navigationController?.pushViewController(calendarTableVC, animated: true)
            
        default:
            break
        }
    }

}


