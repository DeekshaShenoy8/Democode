//
//  UserProfileTableViewController.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 19/09/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import UIKit
import MessageUI
class UserProfileTableViewController: BaseViewController {
    
    let userProfile = ["Email", "User Schedule", "View schedules","logout"]
    let userData = UserDefaults.standard
    let userEmail = UserDefaults.standard.string(forKey: "userName")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension UserProfileTableViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userProfile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.tableFooterView = UIView()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileCell") as! UserProfileTableViewCell
        cell.userProfileLabel.text = userProfile[indexPath.row]
        
        if(indexPath.row == 0){
            
            tableView.allowsSelection = false
            cell.userProfileEmailTextField.text = userEmail
            
        }
        else
        {
            tableView.allowsSelection = true
            cell.userProfileEmailTextField.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row == 1) {
            
            let userScheduleVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserScheduleTableViewController") as! UserScheduleTableViewController
            self.navigationController?.pushViewController(userScheduleVC, animated: true)
            
            
        }
        if(indexPath.row == 2 ){
            
            let calendarTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalandarTableViewController") as! CalandarTableViewController
            self.navigationController?.pushViewController(calendarTableVC, animated: true)

        }
     
        if(indexPath.row == 3) {
            userLogout()
            
        }
        
    }
    
    func userLogout() {
        
        let userData = UserDefaults.standard
        userData.removeObject(forKey: "userName") //We Will delete the userDefaults
        userData.removeObject(forKey: "userPassword")
        userData.synchronize()
        
        let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let navigationController = UINavigationController(rootViewController: mainVC)
        appDelegate.window?.rootViewController = navigationController
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    
}

