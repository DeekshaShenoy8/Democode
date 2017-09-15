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
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                   self.addAlert(title: "successful", message: "registered successfully", cancelTitle: "ok")
                    let adminPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdminPageViewController") as! AdminPageViewController
                    self.navigationController?.pushViewController(adminPageVC, animated: true)
                    
                }
                
                //Error found
                if  let error = error  {
                    self.addAlert(title: "Error" , message: error.localizedDescription, cancelTitle: "OK")
                }        }
        }
    }
    
}
