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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //ON Register button click action
    @IBAction func RegisterUserAction(_ sender: Any) {
        let userEmail = userEmailTextField.text
        let userpassword = userPasswordTextField.text
        
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
                    self.alertRegistration(title: "Registered suceessfully", message: "Thank you", cancelTitle: "Ok")
                  //  self.navigationController?.pushViewController(adminPageTableVC, animated: true)
                    
                }
                
                //Error found
                if  let error = error  {
                    self.addAlert(title: "Error" , message: error.localizedDescription, cancelTitle: "OK")
                }
            }
        }
    }
    
    
    
    func alertRegistration(title: String, message :  String, cancelTitle : String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.default, handler: {action in
//            let index = navigationController?.viewControllers.index(of: AdminPageTableViewController)
//            print (index)
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
