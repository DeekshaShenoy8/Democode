//
//  RoomsTableViewController.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 09/09/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RoomsTableViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var nextArrowButton: UIButton!
    
    var databaseReference : DatabaseReference?
    var databaseHandle : DatabaseHandle?
    
    var roomlist = [MeetingRoom]()
    
    let cellId = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .done, target: self, action: #selector(addTapped))
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "blue") , for: .default)
        tableView.delegate = self
        databaseReference = Database.database().reference()
        tableView.tableFooterView = UIView()
        
        fetchmeetingRoom()
        
        let userData = UserDefaults.standard
        let userEmail = userData.string(forKey: "userName")
        navigationItem.title = "Rooms "
       
        if(userEmail != "admin@gmail.com")
        {
            navigationItem.hidesBackButton = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //On navigation bar view schedule tap action
    func addTapped() {
        
        let userProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserProfileTableViewController") as! UserProfileTableViewController
        
        self.navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    
    // logout button click action
    @IBAction func onLogoutAction(_ sender: Any) {
        let userData = UserDefaults.standard
        userData.removeObject(forKey: "userName") //We Will delete the userDefaults
        userData.removeObject(forKey: "userPassword")
        userData.synchronize()
        print(navigationController?.viewControllers[0] as Any)
        print(navigationController?.viewControllers[1] as Any)
        
        
//        let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! MeetingRoomBooker.ViewController
        if let mainVC = navigationController?.viewControllers[0] {
       self.navigationController?.popToViewController(mainVC, animated: true)
        }
        
    }
    
    //fetch room detail from firebase
    func fetchmeetingRoom()  {
        
        fetchRoomsFromDatabase(entityName: "rooms", complete : {
        })
        // here perfom call back to firebaseDatabase class
        //        let firebaseDatabase = FirebaseDatabase()
        //        let meetingRoom = MeetingRoom()
        //        firebaseDatabase.fetchRoomsFromDatabase(entityName: "rooms", complete : { [weak self] roomsData in
        //
        //            print("completion task")
        //
        //
        //            for keys in roomsData.keys {
        //                if let data = roomsData[keys] as? [String: AnyObject]
        //                {
        //
        //                    meetingRoom.RoomName = data["RoomName"] as! String
        //                    meetingRoom.Capacity = data["Capacity"] as! String
        //                    meetingRoom.facility = data["facility"] as! [String]
        //                    self?.roomlist.append(meetingRoom)
        //
        //                }
        //                DispatchQueue.main.async(execute: {
        //                    self?.tableView.reloadData()
        //
        //                })
        //            }
        //
        //        })
    }
    
    
    
    
    
    //Fetch rooms from firebase database
    func fetchRoomsFromDatabase(entityName: String, complete : ()->()) {
        
        self.startActivityIndicator()
        
        databaseReference?.child(entityName).observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let meetingRoom = MeetingRoom()
                
                meetingRoom.setValuesForKeys(dictionary)
                self.roomlist.append(meetingRoom)
                //print(meetingRoom)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    self.stopActivityIndicator()
                })
            }
            
        })
        
    }
    
    
    
}

extension RoomsTableViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomlist.count
    }
    
    //display room name in table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RoomsTableViewCell
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        cell?.roomsNameLabel.text = roomlist[indexPath.row].RoomName
        
        return cell!
    }
    
    
    //on room name(cell) click action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let roomsDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoomsDetailViewController") as! RoomsDetailViewController
         roomsDetailVC.roomname = roomlist[indexPath.row].RoomName
        self.navigationController?.pushViewController(roomsDetailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}
