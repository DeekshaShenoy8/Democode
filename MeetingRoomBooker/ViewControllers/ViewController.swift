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
   
    
    let userData = UserDefaults.standard

    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func userAdminSegmentAction(_ sender: Any) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    
    
    
    //MARK : User and admin Login Action
    @IBAction func loginAction(_ sender: Any) {
        

//        spinner.frame = CGRect(x: 120.0, y: 16.0, width: 60.0, height: 60.0) // position
        let adminPassword = "admin123"
        let adminEmail = "admin@gmail.com"
        
        if let email = emailTextField.text, let password = passwordTextField.text , email.characters.count > 0, password.characters.count > 0 {
            
           
            
            if segmentControl.selectedSegmentIndex == 0 {
                
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
                let roomsTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoomsTableViewController") as! RoomsTableViewController
                self.navigationController?.pushViewController(roomsTableVC, animated: true)
               // let userId:[String:String] = ["email": userEmail]
                self.userData.set(userEmail, forKey: "userName")
                self.userData.set(userPassword, forKey: "userPassword")
                self.userData.synchronize()

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
                    let adminPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdminPageViewController") as! AdminPageViewController
                    self.navigationController?.pushViewController(adminPageVC, animated: true)
                }
                self.stopActivityIndicator()
                
                self.userData.set(email, forKey: "userName")
                self.userData.set(password, forKey: "userPassword")
                self.userData.synchronize()
            })
            
                   }
        else {
         
            addAlert(title: "PLEASE ENTER CORRECT PASSWORD AND EMAIL ID", message: "Try again", cancelTitle: "OK")
        }
    }

    }

