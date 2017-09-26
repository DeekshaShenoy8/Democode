//
//  UserScheduleTableViewController.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 19/09/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class UserScheduleTableViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    var dabaseReference : DatabaseReference?
    var databaaseHandle : DatabaseHandle?
    
    
    var startTimeArray = [String]()
    var roomNameArray = [String]()
    var endTimeArray = [String]()
    var selectedDate : String = " "

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dabaseReference = Database.database().reference()
        //hideKeyboardWhenTappedAround()

//        tableView.dataSource = self
//        tableView.delegate = self
//        
        dabaseReference = Database.database().reference()
        
        Utility.dateFormatter.dateFormat = "MM/dd/yyyy"
        Utility.dateFormatter.dateStyle = .short
        Utility.dateFormatter.timeStyle = .none
        
        button1.backgroundColor = UIColor.black
        
        button1.setTitle(findDates(tag: button1.tag), for: .normal)
        button2.setTitle(findDates(tag: button2.tag), for: .normal)
        button3.setTitle(findDates(tag: button3.tag), for: .normal)
        button4.setTitle(findDates(tag: button4.tag), for: .normal)
        
        fetchTodaysRoomBook(dateString: findDates(tag: button1.tag) )



    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //On Dates BUtton click Action
    
    @IBAction func dateButtonClickAction(_ sender: UIButton) {
        
        button4.backgroundColor = UIColor.gray
        button1.backgroundColor = UIColor.gray
        button2.backgroundColor = UIColor.gray
        button3.backgroundColor = UIColor.gray
//        button1.setBackgroundImage(#imageLiteral(resourceName: "blue"), for: .normal)
//        button2.setBackgroundImage(#imageLiteral(resourceName: "blue"), for: .normal)
//        button4.setBackgroundImage(#imageLiteral(resourceName: "blueButtonImage"), for: .normal)
//        button1.setBackgroundImage(#imageLiteral(resourceName: "blueButtonImage"), for: .normal)
        
        sender.backgroundColor = UIColor.black
        fetchTodaysRoomBook(dateString: findDates(tag: sender.tag))
        
    }
    
    func findDates(tag : Int) -> String  {
        selectedDate = Utility.dateFormatter.string(from:Calendar.current.date(byAdding: .day, value: tag, to: Date())!)
        return selectedDate
    }
    
    
    //Fetch Booked rooms of selected date of particular user
    func fetchTodaysRoomBook(dateString: String){
        
    startTimeArray = []
    roomNameArray = []
    endTimeArray = []
    tableView.reloadData()
    var idkeys = [String]()
    let userEmail = UserDefaults.standard.string(forKey: "userName")
    
    if let query = dabaseReference?.child("RoomBooking").queryOrdered(byChild: "date").queryEqual(toValue: dateString){
        
    startActivityIndicator()
    
    query.observeSingleEvent(of: .value, with: { (snapshot) in
    
    for snap in snapshot.children.allObjects {
    let id = snap as! DataSnapshot
        
    idkeys.append(String(id.key))
    }
    
    for keys in idkeys {
    
    self.dabaseReference?.child("RoomBooking").child(keys).observeSingleEvent(of: .value, with: { (snapshots) in
    
    if let dictionary = snapshots.value as? [String: AnyObject] {
        
    
    if let name = (dictionary["RoomName"] as? String), let startTime = (dictionary["startTime"] as? String), let endTime = (dictionary["endTime"] as? String), let email = (dictionary["email"] as? String) {
       
        if( email == userEmail) {
            
    self.roomNameArray.append(name)
    self.startTimeArray.append(startTime)
    self.endTimeArray.append(endTime)
    self.tableView.reloadData()
            
    }
    }
    }
    })
    }
    self.stopActivityIndicator()
    })
    }
    }

}


extension UserScheduleTableViewController : UITableViewDataSource ,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return roomNameArray.count
    }
    
    //To display times in row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.tableFooterView = UIView()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userScheduleTableViewCell", for: indexPath) as! UserScheduleTableViewCell
        // let timeString = timezone[indexPath.row]
        
        cell.startTimeLabel.text = startTimeArray[indexPath.row]
        cell.roomNameLabel.text = roomNameArray[indexPath.row]
        cell.endTimeLabel.text = endTimeArray[indexPath.row]
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("selected")
        let meetingInviteVC = self.storyboard?.instantiateViewController(withIdentifier: "MeetingInviteViewController") as! MeetingInviteViewController
        tableView.deselectRow(at: indexPath, animated: true)
        meetingInviteVC.roomname = roomNameArray[indexPath.row]
        meetingInviteVC.startTime = startTimeArray[indexPath.row]
        meetingInviteVC.endTime = endTimeArray[indexPath.row]
        meetingInviteVC.selectedDate = selectedDate
        self.navigationController?.pushViewController(meetingInviteVC, animated: true)
        
    }

}
