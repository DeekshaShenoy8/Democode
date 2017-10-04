//
//  ViewController.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 07/09/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class ViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userLOgin: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    //var window: UIWindow?
    
    
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var userView: UIView!
    
    @IBOutlet weak var adminButton: UIButton!
    @IBOutlet weak var adminView: UIView!
    
    
    let userData = UserDefaults.standard
    
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "primaryHex") , for: .default)
        
        view.layer.backgroundColor = UIColor(red: 81.0/255.0, green: 38.0/255.0, blue: 69.0/255.0, alpha: 1.0).cgColor
        emailTextField.backgroundColor = UIColor(red: 81.0/255.0, green: 38.0/255.0, blue: 69.0/255.0, alpha: 1.0)
        passwordTextField.backgroundColor = UIColor(red: 81.0/255.0, green: 38.0/255.0, blue: 69.0/255.0, alpha: 1.0)
        

        let x = emailTextField.frame.width
        print("width =\(x)")
        textFieldBorder(textField: emailTextField, color : .white, edge : 80)
        textFieldBorder(textField: passwordTextField, color : .white, edge : 80)
        
        adminView.isHidden = true
        userButton.isSelected = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func userButtonAction(_ sender: Any) {
        userButton.isSelected = true
        adminButton.isSelected = false
        adminView.isHidden = true
        userView.isHidden = false
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    

    
    
    @IBAction func adminButtonAction(_ sender: Any) {
        userButton.isSelected = false
        adminButton.isSelected = true
        adminView.isHidden = false
        userView.isHidden = true
        emailTextField.text = ""
        passwordTextField.text = ""
        
    }

    
    
    //MARK : User and admin Login Action
    @IBAction func loginAction(_ sender: Any) {
        
        //        spinner.frame = CGRect(x: 120.0, y: 16.0, width: 60.0, height: 60.0) // position
        let adminPassword = "admin123"
        let adminEmail = "admin@gmail.com"
        
        if let email = emailTextField.text, let password = passwordTextField.text , email.characters.count > 0, password.characters.count > 0 {
            
            
            
            if  userButton.isSelected == true { //segmentControl.selectedSegmentIndex == 0
                
                if(email == adminEmail) && (password == adminPassword) {
                    addAlert(title: "Canot login as a user", message: "try again", cancelTitle: "ok")
                    return
                }
                
                //Authentication
                startActivityIndicator()
                userLogin(userEmail:email, userPassword: password)
                
            } else {
                
                adminLogin(email: email, password: password)
            }
        }
        else {
            self.addAlert(title: "PLEASE FILL ALL THE DETAIL", message: "Try again", cancelTitle: "OK")
            
        }
        
    }
    
    //login for User
    func userLogin(userEmail: String, userPassword: String)  {
        
        Auth.auth().signIn(withEmail: userEmail, password: userPassword, completion: { (user, error) in
            
            if  let error = error  {
                self.addAlert(title: "Error" , message: error.localizedDescription, cancelTitle: "OK")
            }
         
            
            if user != nil {
                
                self.userData.set(userEmail, forKey: "userName")
                self.userData.set(userPassword, forKey: "userPassword")
                
                let roomsTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoomsTableViewController") as! RoomsTableViewController
   
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
                    
                    self.userData.set(email, forKey: "userName")
                    self.userData.set(password, forKey: "userPassword")
                    
                    let adminPageTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdminPageTableViewController") as! AdminPageTableViewController
                    self.navigationController?.pushViewController(adminPageTableVC, animated: true)
                    
                }
                self.stopActivityIndicator()
                
                
                //self.userData.synchronize()
            })
            
        }
        else {
            
            addAlert(title: "PLEASE ENTER CORRECT PASSWORD AND EMAIL ID", message: "Try again", cancelTitle: "OK")
        }
    }
    
}



extension ViewController : UITextViewDelegate {
    
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
