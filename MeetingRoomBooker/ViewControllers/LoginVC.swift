
import UIKit
import Firebase
import FirebaseAuth


class LoginVC: BaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userLOgin: UIButton!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var adminButton: UIButton!
    @IBOutlet weak var adminView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 81.0/255.0, green: 38.0/255.0, blue: 69.0/255.0, alpha: 1.0)
        
        textFieldBorder(textField: emailTextField, color : .white, edge : 80)
        textFieldBorder(textField: passwordTextField, color : .white, edge : 80)
        
        emailTextField.text = ""
        passwordTextField.text = ""
        adminView.isHidden = true
        userButton.isSelected = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //On click of USER , (logged in as user)
    @IBAction func userButtonAction(_ sender: Any) {
        userButton.isSelected = true
        adminButton.isSelected = false
        adminView.isHidden = true
        userView.isHidden = false
        emailTextField.text = ""
        passwordTextField.text = ""
        
    }
    
    
    //On click of ADMIN, (logged in as Admin)
    @IBAction func adminButtonAction(_ sender: Any) {
        userButton.isSelected = false
        adminButton.isSelected = true
        adminView.isHidden = false
        userView.isHidden = true
        emailTextField.text = ""
        passwordTextField.text = ""
        
    }
    
    
    //MARK: User and admin Login Action
    @IBAction func loginAction(_ sender: Any) {
        
        let adminPassword = "admin123"
        let adminEmail = "admin@gmail.com"
        
        if let email = emailTextField.text, let password = passwordTextField.text , email.characters.count > 0, password.characters.count > 0 {
            
            if  userButton.isSelected == true {
                if(email == adminEmail) && (password == adminPassword) {
                    addAlert(title: InvalidPasswordOrEmailAlert.alertTitle, message: InvalidPasswordOrEmailAlert.message, cancelTitle: InvalidPasswordOrEmailAlert.cancelTile)
                    return
                }
                startActivityIndicator()
                userLogin(userEmail:email, userPassword: password)
            } else {
                adminLogin(email: email, password: password)
            }
        }
        else {
            self.addAlert(title: EmptyFieldAlert.alertTitle , message: EmptyFieldAlert.message, cancelTitle: EmptyFieldAlert.cancelTile)
        }
    }
    
    //login for User
    func userLogin(userEmail: String, userPassword: String)  {
        
        Auth.auth().signIn(withEmail: userEmail, password: userPassword, completion: { (user, error) in
            if  let error = error  {
                self.addAlert(title: ErrorAlert.alertTitle  , message: error.localizedDescription, cancelTitle: ErrorAlert.cancelTitle)
            }
            
            if user != nil {
                self.userDefault.set(userEmail, forKey: UserDefaultKey.userEmail)
                self.userDefault.set(userPassword, forKey: UserDefaultKey.userPassword)
                
                let roomsTableVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: RoomsTableVC.self)) as! RoomsTableVC
                self.navigationController?.pushViewController(roomsTableVC, animated: true)
                
            }
            self.stopActivityIndicator()
        })
    }
    
    
    //login for admin
    func adminLogin(email: String, password: String)
    {
        let adminPassword = "admin123"
        let adminEmail = "admin@gmail.com"
        
        if(email == adminEmail) && (password == adminPassword) {
            
            startActivityIndicator()
            
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if user != nil {
                    self.userDefault.set(email, forKey: UserDefaultKey.userEmail)
                    self.userDefault.set(password, forKey: UserDefaultKey.userPassword)
                    
                    let adminPageTableVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing : AdminPageTableVC.self)) as!  AdminPageTableVC
                    self.navigationController?.pushViewController(adminPageTableVC, animated: true)
                }
                self.stopActivityIndicator()
            })
        }
        else {
            addAlert(title: InvalidPasswordOrEmailAlert.alertTitle, message: InvalidPasswordOrEmailAlert.message, cancelTitle: InvalidPasswordOrEmailAlert.cancelTile)
        }
    }
    
}


extension LoginVC : UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
            return true;
        }
        return false
    }
}
