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
import EventKit

class UserScheduleTableViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    var dabaseReference : DatabaseReference?
    var databaaseHandle : DatabaseHandle?
//    var idkeys = [String]()
    var uid = [String]()
    var startTimeArray = [String]()
    var roomNameArray = [String]()
    var endTimeArray = [String]()
    var selectedDate : String = " "
    var eventId = [String]()
    var meetingTitle = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        button1.isEnabled = true
        button2.isEnabled = true
        button3.isEnabled = true
        button4.isEnabled = true
        tableView.reloadData()
        //fetchTodaysRoomBook(dateString: findDates(tag: button1.tag) )
        
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
        
        if let buttonDate = sender.title(for: .normal) {
        sender.backgroundColor = UIColor.black
        fetchTodaysRoomBook(dateString: buttonDate)
        selectedDate = buttonDate
        }
    }
    
    func findDates(tag : Int) -> String  {
        selectedDate = Utility.dateFormatter.string(from:Calendar.current.date(byAdding: .day, value: tag, to: Date())!)
        return Utility.dateFormatter.string(from:Calendar.current.date(byAdding: .day, value: tag, to: Date())!)
       // return selectedDate
    }
    
    
    //Fetch Booked rooms of selected date of particular user
    func fetchTodaysRoomBook(dateString: String){
    
    //tableView.reloadData()
    startTimeArray = []
    roomNameArray = []
    endTimeArray = []
        eventId = []
    tableView.reloadData()
        var idkeys = [String]()
        uid = []
        meetingTitle = []
        
    let userEmail = UserDefaults.standard.string(forKey: "userName")
    
    if let query = dabaseReference?.child("RoomBooking").queryOrdered(byChild: "date").queryEqual(toValue: dateString){
        
    startActivityIndicator()
    
    query.observeSingleEvent(of: .value, with: { (snapshot) in
    
    for snap in snapshot.children.allObjects {
    let id = snap as! DataSnapshot
        
    idkeys.append(String(id.key))
    }
    print(idkeys)
        
    for keys in idkeys {
    
    self.dabaseReference?.child("RoomBooking").child(keys).observeSingleEvent(of: .value, with: { (snapshots) in
    
    if let dictionary = snapshots.value as? [String: AnyObject] {
        
    
    if let name = (dictionary["RoomName"] as? String), let startTime = (dictionary["startTime"] as? String), let endTime = (dictionary["endTime"] as? String), let email = (dictionary["email"] as? String), let meetingName =  (dictionary["MeetingName"] as? String) {
       //, let eventIdentity = (dictionary["EventId"] as? String)
        if( email == userEmail) {
            
    self.roomNameArray.append(name)
    self.startTimeArray.append(startTime)
    self.endTimeArray.append(endTime)
    self.meetingTitle.append(meetingName)
  // self.eventId.append(eventIdentity)
    self.uid.append(keys)
            
//            if let eventIdentity = (dictionary["EventId"] as? String) {
//                self.eventId.append(eventIdentity)
//            }
            
     self.tableView.reloadData()
            /*if snapshot.hasChild("EventId") {
               if let  eventIdentity = (dictionary["EventId"] as? String)
               {
                self.eventId.append(eventIdentity)
                }
            }*/
    }
    }
    }
    })
    }
    self.stopActivityIndicator()
    })
    }
    }
  
    
    //MARK: Delete based on event identifier
    func deleteEvent( eventIdentifier : String) {
        
        let id = eventIdentifier.replacingOccurrences(of: "\"", with: "")
        print(eventIdentifier)
        //print(eventId)
        let eventStore2 = EKEventStore()
        let eventToRemove = eventStore2.event(withIdentifier: eventIdentifier)
        if(eventToRemove != nil) {
            do {
                
                print("deleted = \(eventIdentifier)")
                try eventStore2.remove(eventToRemove!, span: .thisEvent)
                
            } catch {
                print("error during delete \(error)")
            }
        }
    }

    
    
    //MARK: Fetch event from calendar, if already exist event found then delete
    
    
    func fetchEventsFromCalendar(calendarTitle: String, startAt: String , endAt: String) -> Void {
        let eventStore = EKEventStore()
        var string = " "
        var endStringTime = " "
        let event = EKEvent(eventStore: eventStore)
       // if let date = self.selectedDate {
            print("selected date is \(selectedDate)")
            string = selectedDate + " at " + startAt
            endStringTime = selectedDate + " at " + endAt
            Utility.dateFormatter.locale = Locale.current
            //Utility.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            Utility.dateFormatter.dateFormat = "MM/dd/yy 'at' HH:mm" //"M/dd/yyyy 'at' h:mm a " //
            
            
            event.startDate = Utility.dateFormatter.date(from: string) ?? Calendar.current.date(byAdding: .day, value: 5, to: Date())!//Date()
            print(event.startDate.description(with: .current) )
            
            event.endDate =  Utility.dateFormatter.date(from: endStringTime) ?? Calendar.current.date(byAdding: .day, value: 5, to: Date())!//Date()
            
            
            let startDate = Utility.dateFormatter.date(from: string) ?? Calendar.current.date(byAdding: .day, value: 5, to: Date())!//Date()
            
            let endDate = Utility.dateFormatter.date(from: endStringTime) ?? Calendar.current.date(byAdding: .day, value: 5, to: Date())!//Date()
            let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
            let existingEvents = eventStore.events(matching: predicate)
            for singleEvent in existingEvents {
                if singleEvent.title == calendarTitle && singleEvent.startDate ==  Utility.dateFormatter.date(from: string) {
                    print("event exist")
                    do {
                        print("event found")
                        try eventStore.remove(singleEvent, span: .thisEvent, commit: true)
                    } catch {
                        print("error during fetch delete\(error)")
                    }
                    
                }
                
            }
            
       // }
        
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        print(uid)
        let bookingUid = uid[indexPath.row]
        let eventTitle = meetingTitle[indexPath.row]
        print("indexpath uid= \(bookingUid)")
       print("meeting name is \(eventTitle)")
        print("start time = \(startTimeArray[indexPath.row])")
            print("start time = \(endTimeArray[indexPath.row])")
        if editingStyle == .delete {
            
            self.fetchEventsFromCalendar(calendarTitle: eventTitle , startAt: startTimeArray[indexPath.row], endAt: endTimeArray[indexPath.row])
            
            if self.eventId.count != 0 {
                
                let eventuid = self.eventId[indexPath.row]
                
               // self.fetchEventsFromCalendar(calendarTitle: , startAt: <#T##String#>, endAt: <#T##String#>)
                self.deleteEvent(eventIdentifier: eventuid)
                print("deleted")
                //print(self.eventId)
                
            }
            
            self.fetchTodaysRoomBook(dateString: self.selectedDate)
            tableView.reloadData()
            
            

          dabaseReference?.child("RoomBooking").child(bookingUid).removeValue(completionBlock: { (error, databaseReference) in
            if error != nil {
                print(error ?? "erroe during deletion")
            } else {
                
                //self.eventId.remove(at: indexPath.row)
                //self.fetchTodaysRoomBook(dateString: self.selectedDate)
                //tableView.reloadData()
                
            }
            })
            
            
        }
        
    }
    

}
