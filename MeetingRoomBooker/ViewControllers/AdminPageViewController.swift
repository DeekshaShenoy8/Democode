//
//  AdminPageViewController.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 08/09/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import UIKit

class AdminPageViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func AddUserAction(_ sender: Any) {
        let registerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        self.navigationController?.pushViewController(registerVC, animated: true)
    }

  
    @IBAction func addRoomClickAction(_ sender: Any) {
        let addRoomVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddRoomViewController") as! AddRoomViewController
        self.navigationController?.pushViewController(addRoomVC, animated: true)
    }
   
    @IBAction func viewBookedRoomAction(_ sender: Any) {
        
        let calendarTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalandarTableViewController") as! CalandarTableViewController
        
        self.navigationController?.pushViewController(calendarTableVC, animated: true)
    }
    
    
    @IBAction func viewRoomsAction(_ sender: Any) {
        let roomsTableVC = self.storyboard?.instantiateViewController(withIdentifier: "RoomsTableViewController") as! RoomsTableViewController
        navigationController?.pushViewController(roomsTableVC, animated: true)
    }

    @IBAction func logoutAction(_ sender: Any) {
        let userData = UserDefaults.standard
        userData.removeObject(forKey: "userName") //We Will delete the userDefaults
        userData.removeObject(forKey: "userPassword")
        userData.synchronize()
        navigationController?.popToRootViewController(animated: true)
    }
    
    
}
