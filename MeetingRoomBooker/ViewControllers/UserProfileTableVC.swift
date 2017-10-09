
import UIKit
import MessageUI
class UserProfileTableVC: BaseViewController {
    
    let userProfile = ["Email", "User Schedule", "View schedules","logout"]
    let userEmail = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NavigationTitle.profile
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK : Logout action
    func userLogout() {
        
        //let userData = UserDefaults.standard
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.userEmail) //We Will delete the userDefaults
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.userPassword)
                UserDefaults.standard.synchronize()
        let isLoginPageIsPresentInNavigationStack = UserDefaults.standard.bool(forKey: UserDefaultKey.isLoginPageIsThereInNavigationStack)
       
        if isLoginPageIsPresentInNavigationStack == false {
            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: LoginVC.self)) as! LoginVC
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let navigationController = UINavigationController(rootViewController: mainVC)
            appDelegate.window?.rootViewController = navigationController
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        UserDefaults.standard.set(true, forKey: UserDefaultKey.isLoginPageIsThereInNavigationStack)
        
    }
    
}


extension UserProfileTableVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userProfile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.tableFooterView = UIView()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing : UserProfileTableViewCell.self)) as! UserProfileTableViewCell
        cell.userProfileLabel.text = userProfile[indexPath.row]
        
        
        switch indexPath.row {
        case 0:
            tableView.allowsSelection = false
            cell.userProfileEmailTextField.text = userEmail
            cell.accessoryType = .none
            cell.selectionStyle = .none
            
        default:
            tableView.allowsSelection = true
            cell.userProfileEmailTextField.isHidden = true
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
        case 1:
            let userScheduleVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: UserScheduleTableVC.self)) as! UserScheduleTableVC
            self.navigationController?.pushViewController(userScheduleVC, animated: true)
            

        case 2:
            let calendarTableVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: CalandarTableVC.self)) as! CalandarTableVC
            self.navigationController?.pushViewController(calendarTableVC, animated: true)
            
        case 3:
            userLogout()
            
        default :
            break

        }
        
    }
    
}

