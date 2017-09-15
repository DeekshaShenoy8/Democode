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
        
        tableView.delegate = self
        databaseReference = Database.database().reference()
        fetchmeetingRoom()
                startActivityIndicator()
        let userData = UserDefaults.standard
        let userEmail = userData.string(forKey: "userName")
        
        if(userEmail != "admin@gmail.com")
        {
            navigationItem.hidesBackButton = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // logout button click action
    @IBAction func onLogoutAction(_ sender: Any) {
            let userData = UserDefaults.standard
            userData.removeObject(forKey: "userName") //We Will delete the userDefaults
            userData.removeObject(forKey: "userPassword")
            userData.synchronize()
            navigationController?.popToRootViewController(animated: true)
        
    }
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return roomlist.count
//    }
//    
//    //display room name in table view cell
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RoomsTableViewCell
//        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
//        cell?.roomsNameLabel.text = roomlist[indexPath.row].RoomName
//        
//        return cell!
//    }
//    
//    //on room name(cell) click action
//     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//       
//        let bookRoomVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookRoomViewController") as! BookRoomViewController
//        bookRoomVC.roomname = roomlist[indexPath.row].RoomName
//        self.navigationController?.pushViewController(bookRoomVC, animated: true)
//
//    }
//    
//    //to display title of sections
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Room Names"
//    }
//    
//    //fetch room detail from firebase
//    func fetchmeetingRoom() {
//        fetchRoomsFromDatabase(entityName: "rooms", complete: {
//            
//                })
//        
//        
//    }
//    
    
       /*
     // here perfom call back to firebaseDatabase class
     let firebaseDatabase = FirebaseDatabase()
     firebaseDatabase.fetchRoomsFromDatabase(entityName: "rooms", complete : { roomsData in
            print("completion task")
            let meetingRoom = MeetingRoom()
            
            for keys in roomsData.keys {
                 print(roomsData[keys])
                let data = roomsData[keys] as? [String: AnyObject]
                
                
                print(data?["Capacity"])
               print(data)
    }
})*/

 
  
        
        
  
    func fetchRoomsFromDatabase(entityName: String, complete : ()->()) {
        
        databaseReference?.child(entityName).observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.startActivityIndicator()
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
        
        
        let bookRoomVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookRoomViewController") as! BookRoomViewController
        bookRoomVC.roomname = roomlist[indexPath.row].RoomName
        self.navigationController?.pushViewController(bookRoomVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //to display title of sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Room Names"
    }
    
    //fetch room detail from firebase
    func fetchmeetingRoom() {
        fetchRoomsFromDatabase(entityName: "rooms", complete: {
            
        })
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}
