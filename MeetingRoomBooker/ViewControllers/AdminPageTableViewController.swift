//
//  AdminPageTableViewController.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 16/09/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import UIKit

class AdminPageTableViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var buttonTitle = ["Add User", "Add Room", "View Rooms", "View Schedule"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.tintColor =  .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "primaryHex") , for: .default)
        
        tableView.tableFooterView = UIView()
        
        navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(addTapped))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //On logout Tap
    func addTapped() {
        
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



extension AdminPageTableViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return buttonTitle.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminCell", for: indexPath) as? AdminPageTableViewCell
        
        cell?.adminLabel.text = buttonTitle[indexPath.row]
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            
            let registerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
            self.navigationController?.pushViewController(registerVC, animated: true)
            
        } else if( indexPath.row == 1) {
            
            let addRoomVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddRoomViewController") as! AddRoomViewController
            self.navigationController?.pushViewController(addRoomVC, animated: true)
            
        } else if(indexPath.row == 2){
            
            let roomsTableVC = self.storyboard?.instantiateViewController(withIdentifier: "RoomsTableViewController") as! RoomsTableViewController
            navigationController?.pushViewController(roomsTableVC, animated: true)
            
        } else if(indexPath.row == 3) {
            
            let calendarTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalandarTableViewController") as! CalandarTableViewController
            self.navigationController?.pushViewController(calendarTableVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    
}


