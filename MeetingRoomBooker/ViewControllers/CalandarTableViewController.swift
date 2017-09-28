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

class CalandarTableViewController: BaseViewController{
    
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
//    
//    var buttonPressed = " "
//    
//    var selectedDate = " "
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
       
        tableView.tableFooterView = UIView()
        
        
        dabaseReference = Database.database().reference()
        
        Utility.dateFormatter.dateFormat = "MM/dd/yyyy"
        Utility.dateFormatter.dateStyle = .short
        Utility.dateFormatter.timeStyle = .none
        
        button4.backgroundColor = UIColor.gray
        button1.backgroundColor = UIColor.black
        button2.backgroundColor = UIColor.gray
        button3.backgroundColor = UIColor.gray
        
        button1.setTitle(findDates(tag: button1.tag), for: .normal)
        button2.setTitle(findDates(tag: button2.tag), for: .normal)
        button3.setTitle(findDates(tag: button3.tag), for: .normal)
        button4.setTitle(findDates(tag: button4.tag), for: .normal)
        
        fetchTodaysRoomBook(dateString: findDates(tag: button1.tag) )
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    
    func findDates( tag : Int)-> String
    {
        
        return Utility.dateFormatter.string(from:Calendar.current.date(byAdding: .day, value: tag, to: Date())!)
        
    }
    
    //Fetch Booked rooms of selected date
    func fetchTodaysRoomBook(dateString: String) {
        startTimeArray = []
        roomNameArray = []
        endTimeArray = []
        var idkeys = [String]()
        
        tableView.reloadData()
        
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
        
//        button4.backgroundColor = UIColor.black
//        button1.backgroundColor = UIColor.black
//        button2.backgroundColor = UIColor.black
//        button3.backgroundColor = UIColor.black
        button4.backgroundColor = UIColor.gray
        button1.backgroundColor = UIColor.gray
        button2.backgroundColor = UIColor.gray
        button3.backgroundColor = UIColor.gray
        
        fetchTodaysRoomBook(dateString: findDates(tag: sender.tag))
        
        sender.backgroundColor = UIColor.black
        
    }
    
//    func onClick(sender :UIButton) {
//        sender.backgroundColor = .purple
//    }
//    
//    func onRelease(sender: UIButton) {
//        sender.backgroundColor = .black
//    }
}

extension CalandarTableViewController: UITableViewDataSource, UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print("selected")
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            tableView.beginUpdates()
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            tableView.endUpdates()
//            
//        }

//}

}
//extension UIButton {
//    
//    func setBackgroundColor(color: UIColor, forState: UIControlState) {
//        
//    }
//}
