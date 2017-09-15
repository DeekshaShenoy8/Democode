//
//  CalandarTableViewController.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 11/09/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CalandarTableViewController: BaseViewController, UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    var dabaseReference : DatabaseReference?
    var databaaseHandle : DatabaseHandle?
    
    
    var startTimeArray = [String]()
    var roomNameArray = [String]()
    var endTimeArray = [String]()
    
    var buttonPressed = " "
    
    var selectedDate = " "
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        
        dabaseReference = Database.database().reference()
        
        Utility.dateFormatter.dateFormat = "MM/dd/yyyy"
        Utility.dateFormatter.dateStyle = .short
        Utility.dateFormatter.timeStyle = .none
        
        
        button1.setTitle(findDates(tag: button1.tag), for: .normal)
        button2.setTitle(findDates(tag: button2.tag), for: .normal)
        button3.setTitle(findDates(tag: button3.tag), for: .normal)
        button4.setTitle(findDates(tag: button4.tag), for: .normal)
        
        fetchTodaysRoomBook(dateString: findDates(tag: button1.tag) )
        
        
        //fetchTodaysRoomBook()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    func findDates( tag : Int)-> String
    {
        return Utility.dateFormatter.string(from:Calendar.current.date(byAdding: .day, value: tag, to: Date())!)
        
    }
    
    
    func fetchTodaysRoomBook(dateString: String) {
        startTimeArray = []
        roomNameArray = []
        endTimeArray = []
        var idkeys = [String]()
        
        
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
                        
                        if let name = (dictionary["RoomName"] as? String), let startTime = (dictionary["startTime"] as? String), let endTime = (dictionary["endTime"] as? String) {
                            self.roomNameArray.append(name)
                            self.startTimeArray.append(startTime)
                            self.endTimeArray.append(endTime)
                            self.tableView.reloadData()
                        }
                    }
                    
                })
            }
            self.stopActivityIndicator()
        })
        }
    }
    
    
    
    
    @IBAction func onDatesButtonClickAction(_ sender: UIButton) {
        
        fetchTodaysRoomBook(dateString: findDates(tag: sender.tag))
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return roomNameArray.count
    }
    
    //To display times in row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "calandarCell", for: indexPath) as? CalanderTableViewCell
        // let timeString = timezone[indexPath.row]
        
        cell?.timeCellLabel.text = startTimeArray[indexPath.row]
        cell?.roomNameLbel.text = roomNameArray[indexPath.row]
        cell?.durationLabel.text = endTimeArray[indexPath.row]
        
        return cell!
        
    }
    
    // func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    
    //   return UIView()
    // }
    
    //to display title of section
    /*     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     return "Room Name Start Time(hr) EndTime(hr)"
     }
     
     */
    
}
