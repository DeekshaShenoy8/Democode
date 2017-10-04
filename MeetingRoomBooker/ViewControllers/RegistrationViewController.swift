//
//  RegistrationViewController.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 08/09/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegistrationViewController: BaseViewController {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        navigationItem.title = "Registration"
        userEmailTextField.delegate = self
        userPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
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
        
        let valid = validateEmail(enteredEmail: userEmail!)
        
        if valid == false {
            addAlert(title: "check your email id", message: "try with valid email id", cancelTitle: "ok")
        }
        // Confirm the entered password by comparision
        if confirmPasswordTextField.text != userpassword
        {
            addAlert(title: "PLEASE CHECK THE PASSWORD YOU HAVE ENTERED", message: "Try again", cancelTitle: "ok")
        }
        
        // register the new user
        if let email = userEmail , let password = userpassword
        {
            
            Auth.auth().createUser(withEmail: email , password: password) { (user, error) in
                
                if user != nil {
                    
                    self.sucessfulRegistrationAlert(title: "Registered suceessfully", message: "Thank you", cancelTitle: "Ok")
                    
                }
                
                //Error found
                if  let error = error  {
                    self.addAlert(title: "Error" , message: error.localizedDescription, cancelTitle: "OK")
                }
            }
        }
    }
    
    func sucessfulRegistrationAlert(title: String, message: String, cancelTitle: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.default, handler: {action in
            
            if let size = self.navigationController?.viewControllers.count {
                if let controller = self.navigationController?.viewControllers[size - 2] {
                    
                    self.navigationController?.popToViewController(controller, animated: true)
                }
            }
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "^(?!.*?[._]{2})[A-Z0-9a-z._%+-]+@[A-Za-z.-]+\\.[A-Za-z]{2,4}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
    
    
    func alertRegistration(title: String, message :  String, cancelTitle : String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.default, handler: {action in
            
            if let controller = self.navigationController?.viewControllers[1] {
                self.navigationController?.popToViewController(controller, animated: true)
                
            }
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}


extension RegistrationViewController : UITextFieldDelegate {
    
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
