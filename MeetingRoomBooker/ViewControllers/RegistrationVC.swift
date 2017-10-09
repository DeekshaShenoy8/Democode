
import UIKit
import FirebaseAuth

class RegistrationVc: BaseViewController {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        navigationItem.title = NavigationTitle.registration
        textFieldBorder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldBorder() {
        textFieldBorder(textField: userEmailTextField, color : .black, edge: 80)
        textFieldBorder(textField: userPasswordTextField, color : .black, edge: 80)
        textFieldBorder(textField: confirmPasswordTextField, color : .black, edge: 80)
    }
    
    //ON Register button click action
    @IBAction func RegisterUserAction(_ sender: Any) {
        let userEmail = userEmailTextField.text
        let userpassword = userPasswordTextField.text
        let isValid = validateEmail(enteredEmail: userEmail!)
        
        if isValid == false {
            addAlert(title: InvalidPasswordOrEmailAlert.alertTitle, message: InvalidPasswordOrEmailAlert.message, cancelTitle: InvalidPasswordOrEmailAlert.cancelTile)
            return
        }
        
        // Confirm the entered password by comparision
        if confirmPasswordTextField.text != userpassword {
            addAlert(title: InvalidPasswordOrEmailAlert.alertTitle, message: InvalidPasswordOrEmailAlert.message, cancelTitle: InvalidPasswordOrEmailAlert.cancelTile)
        }
        
        //To register the new user
        if let email = userEmail , let password = userpassword {
            Auth.auth().createUser(withEmail: email , password: password) { (user, error) in
                
                if user != nil {
                    self.alert(title: SuccessAlert.registered, message: SuccessAlert.message, cancelTitles: [SuccessAlert.cancelTitle])
                }
                
                //Error found
                if  let error = error  {
                    self.addAlert(title: ErrorAlert.alertTitle , message: error.localizedDescription, cancelTitle: ErrorAlert.cancelTitle)
                }
            }
        }
    }
    
    
    //On successful registration alert it & on cancel title(ok) click move to previous view controller
    func alert(title: String, message : String, cancelTitles: [String]) {
        alertController(title: title, message: message, cancelTitles: cancelTitles,actions: [{action1 in
            if let size = self.navigationController?.viewControllers.count {
                if let controller = self.navigationController?.viewControllers[size - 2] {
                    self.navigationController?.popToViewController(controller, animated: true)
                }
            }
            
            }])
    }
    
    
    //To validate the email id using regular expression
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "^(?!.*?[._]{2})[A-Z0-9a-z._%+-]+@[A-Za-z.-]+\\.[A-Za-z]{2,4}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        
        return emailPredicate.evaluate(with: enteredEmail)
    }
}


extension RegistrationVc : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.textColor = .black
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            return true;
        }
        return false
    }
}
