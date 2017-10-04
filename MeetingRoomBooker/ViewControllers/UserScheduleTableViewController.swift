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
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
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
    let calendar = Calendar.current
    var tagValue : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dabaseReference = Database.database().reference()
        setButtonTitle()
        Utility.dateFormatter.dateFormat = "MM/dd/yyyy"
        Utility.dateFormatter.dateStyle = .short
        Utility.dateFormatter.timeStyle = .none
        
        
        fetchTodaysRoomBook(dateString: findDates(tag: button1.tag) )
        
        prevButton.isEnabled = false
        
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
    
    func setButtonTitle() {
        button1.backgroundColor = UIColor(red: 81.0/255.0, green: 38.0/255.0, blue: 69.0/255.0, alpha: 1.0)
        
        button1.setTitle(findDates(tag: button1.tag), for: .normal)
        button2.setTitle(findDates(tag: button2.tag), for: .normal)
        button3.setTitle(findDates(tag: button3.tag), for: .normal)
        button4.setTitle(findDates(tag: button4.tag), for: .normal)
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
        
        if let buttonDate = sender.title(for: .normal) {
            sender.backgroundColor = UIColor(red: 81.0/255.0, green: 38.0/255.0, blue: 69.0/255.0, alpha: 1.0)
            fetchTodaysRoomBook(dateString: buttonDate)
            selectedDate = buttonDate
            tagValue = sender.tag
        }
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        fetchTodaysRoomBook(dateString:(findDates(tag: 4 + tagValue)))
        
        //setButtonsToGreyColor()
        prevButton.isEnabled = true
        nextButton.isEnabled = false
        button1.setTitle(findDates(tag: 4), for: .normal)
        button2.setTitle(findDates(tag: 5), for: .normal)
        button3.setTitle(findDates(tag: 6), for: .normal)
        button4.setTitle(findDates(tag: 7), for: .normal)
        
        
    }
    
    
    @IBAction func prevButtonAction(_ sender: Any) {
        
        fetchTodaysRoomBook(dateString:(findDates(tag: tagValue)))
        //setButtonsToGreyColor()
        button1.setTitle(findDates(tag: 0), for: .normal)
        button2.setTitle(findDates(tag: 1), for: .normal)
        button3.setTitle(findDates(tag: 2), for: .normal)
        button4.setTitle(findDates(tag: 3), for: .normal)
        prevButton.isEnabled = false
        nextButton.isEnabled = true
        
    }
    
    
    func findDates(tag : Int) -> String  {
        selectedDate = Utility.dateFormatter.string(from:Calendar.current.date(byAdding: .day, value: tag, to: Date())!)
        return Utility.dateFormatter.string(from:Calendar.current.date(byAdding: .day, value: tag, to: Date())!)
        // return selectedDate
    }
    
    
    //Fetch Booked rooms of selected date of particular user
    
    func fetchTodaysRoomBook(dateString: String){
        
        startTimeArray = []
        roomNameArray = []
        endTimeArray = []
        uid = []
        let userEmail = UserDefaults.standard.string(forKey: "userName")
        let bookMeetingRoom = BookMeetingRoom()
        
        tableView.reloadData()
        startActivityIndicator()
        
        bookMeetingRoom.getBookedRoom(dateString: dateString, emailid : userEmail!, callback: { [weak self] (success, bookingid) in
            
            self?.stopActivityIndicator()
            
            if success {
                
                if ( bookMeetingRoom.roomDetail.email == userEmail) {
                    
                    self?.roomNameArray.append(bookMeetingRoom.roomDetail.RoomName)
                    self?.startTimeArray.append(bookMeetingRoom.roomDetail.startTime)
                    self?.endTimeArray.append(bookMeetingRoom.roomDetail.endTime)
                    self?.meetingTitle.append(bookMeetingRoom.roomDetail.MeetingName)
                    
                    for id in bookingid {
                        self?.uid.append(id)
                    }
                    
                    self?.tableView.reloadData()
                    
                }
            }
        })
        
    }
    

    
    //MARK: Delete based on event identifier
    func deleteEvent( eventIdentifier : String) {
        
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
//        let event = EKEvent(eventStore: eventStore)
        
        string = selectedDate + " at " + startAt
        endStringTime = selectedDate + " at " + endAt
        
        Utility.dateFormatter.locale = Locale.current
        //Utility.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        Utility.dateFormatter.dateFormat = "MM/dd/yy 'at' HH:mm" //"M/dd/yyyy 'at' h:mm a "
        
        let startDate = Utility.dateFormatter.date(from: string) ?? Calendar.current.date(byAdding: .day, value: 5, to: Date())!//Date()
        
        let endDate = Utility.dateFormatter.date(from: endStringTime) ?? Calendar.current.date(byAdding: .day, value: 5, to: Date())!//Date()
        
//        event.startDate = Utility.dateFormatter.date(from: string) ?? Calendar.current.date(byAdding: .day, value: 5, to: Date())!//Date()
//        print(event.startDate.description(with: .current) )
//        
//        event.endDate =  Utility.dateFormatter.date(from: endStringTime) ?? Calendar.current.date(byAdding: .day, value: 5, to: Date())!//Date()
        
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
        cell.startTimeLabel.text = startTimeArray[indexPath.row]
        cell.roomNameLabel.text = roomNameArray[indexPath.row]
        cell.endTimeLabel.text = endTimeArray[indexPath.row]
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //validMeeting(startTimeArray[indexPath.row])
        
        let hour = calendar.component(.hour, from: Date())
        
        let hours : String
        if(hour <= 9){
            hours = "0" + String(hour)
            
        }
        else {
            hours = String(hour)
        }
        print(hours)
        let today = Utility.dateFormatter.string(from: Date())
        if selectedDate == today {
            if(startTimeArray[indexPath.row] <= hours) {
                addAlert(title: "meeting is already over", message: "You Canot Edit the Meeting Now", cancelTitle: "ok")
            }
        }
        
        let meetingInviteVC = self.storyboard?.instantiateViewController(withIdentifier: "MeetingInviteViewController") as! MeetingInviteViewController
        tableView.deselectRow(at: indexPath, animated: true)
        meetingInviteVC.roomname = roomNameArray[indexPath.row]
        meetingInviteVC.startTime = startTimeArray[indexPath.row]
        meetingInviteVC.endTime = endTimeArray[indexPath.row]
        meetingInviteVC.selectedDate = selectedDate
        self.navigationController?.pushViewController(meetingInviteVC, animated: true)
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let bookingUid = uid[indexPath.row]
        let eventTitle = meetingTitle[indexPath.row]
        // print("indexpath uid= \(bookingUid)")
        print("meeting name is \(eventTitle)")
        print("start time = \(startTimeArray[indexPath.row])")
        print("start time = \(endTimeArray[indexPath.row])")
        
        if editingStyle == .delete {
            
            self.fetchEventsFromCalendar(calendarTitle: eventTitle , startAt: startTimeArray[indexPath.row], endAt: endTimeArray[indexPath.row])
            
            if self.eventId.count != 0 {
                
                let eventuid = self.eventId[indexPath.row]
                
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
                    
                    
                }
            })
            
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
    
    
    
}
