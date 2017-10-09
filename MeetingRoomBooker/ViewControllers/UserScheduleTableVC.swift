
import UIKit
import Firebase
import FirebaseDatabase
import EventKit

class UserScheduleTableVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    var dabaseReference : DatabaseReference?
    
    var uid = [String]()
    var startTimeArray = [String]()
    var roomNameArray = [String]()
    var endTimeArray = [String]()
    var selectedDate : String = " "
    var eventId = [String]()
    var meetingTitle = [String]()
    var tagValue : Int = 0
    var bookMeetingRoom = BookMeetingRoom()
    
    let calendar = Calendar.current
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        prevButton.isEnabled = false
        dabaseReference = Database.database().reference()
        button1.backgroundColor = UIColor(red: 81.0/255.0, green: 38.0/255.0, blue: 69.0/255.0, alpha: 1.0)
        
        setTitleToButton()
        fetchTodaysRoomBook(dateString: findDates(tag: button1.tag) )
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setTitleToButton() {
        
        Utility.dateFormatter.dateFormat = "MM/dd/yyyy"
        Utility.dateFormatter.dateStyle = .short
        Utility.dateFormatter.timeStyle = .none
        
        button1.setTitle(findDates(tag: button1.tag), for: .normal)
        button2.setTitle(findDates(tag: button2.tag), for: .normal)
        button3.setTitle(findDates(tag: button3.tag), for: .normal)
        button4.setTitle(findDates(tag: button4.tag), for: .normal)
        
    }
    
    
    func findDates(tag : Int) -> String  {
        selectedDate = Utility.dateFormatter.string(from:Calendar.current.date(byAdding: .day, value: tag, to: Date())!)
        return Utility.dateFormatter.string(from:Calendar.current.date(byAdding: .day, value: tag, to: Date())!)
        // return selectedDate
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
    
    
    
    
    //Fetch Booked rooms of selected date of particular user
    
    func fetchTodaysRoomBook(dateString: String){
        
        startTimeArray = []
        roomNameArray = []
        endTimeArray = []
        uid = []
        
        let userEmail = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail)
        let bookMeetingRoom = BookMeetingRoom()
        
        tableView.reloadData()
        //startActivityIndicator()
        
        bookMeetingRoom.getBookedRoom(dateString: dateString, emailid : userEmail!, callback: { [weak self] (success, bookingid) in
            //self?.stopActivityIndicator()
            
            if success {
                
                for email in bookMeetingRoom.roomDetails {
                    
                    if (email.email == userEmail) {
                        
                        self?.roomNameArray.append(email.RoomName)
                        self?.startTimeArray.append(email.startTime)
                        self?.endTimeArray.append(email.endTime)
                        self?.meetingTitle.append(email.MeetingName)
                        
                        for id in bookingid {
                            
                            self?.uid.append(id)
                            
                        }
                        
                        self?.tableView.reloadData()
                        
                    }
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
        
        let startDate = Utility.dateFormatter.date(from: string) ?? Date()
        
        let endDate = Utility.dateFormatter.date(from: endStringTime) ?? Date()
        
        
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let existingEvents = eventStore.events(matching: predicate)
        for singleEvent in existingEvents {
            
            if singleEvent.title == calendarTitle && singleEvent.startDate ==  Utility.dateFormatter.date(from: string) {
                
//                print("event exist")
                do {
                    
//                    print("event found")
                    try eventStore.remove(singleEvent, span: .thisEvent, commit: true)
                } catch {
                    
                    print(error)
                }
                
            }
            
        }
        
    }
    
}




extension UserScheduleTableVC : UITableViewDataSource ,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return bookMeetingRoom.roomDetails.count
        return roomNameArray.count
    }
    
    
    //To display times in row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.tableFooterView = UIView()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserScheduleTableViewCell.self), for: indexPath) as! UserScheduleTableViewCell
        cell.startTimeLabel.text = startTimeArray[indexPath.row] //bookMeetingRoom.roomDetails[indexPath.row].startTime //
        cell.roomNameLabel.text = roomNameArray[indexPath.row] //bookMeetingRoom.roomDetails[indexPath.row].RoomName//
        cell.endTimeLabel.text = endTimeArray[indexPath.row] //bookMeetingRoom.roomDetails[indexPath.row].endTime//
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let hour = calendar.component(.hour, from: Date())
        
        let hours : String
        if(hour <= 9){
            hours = "0" + String(hour)
            
        }
            
        else {
            hours = String(hour)
        }
        
        //print(hours)
        let today = Utility.dateFormatter.string(from: Date())
        if selectedDate == today {
            if(startTimeArray[indexPath.row] <= hours) {
                addAlert(title: EventAlert.meetingOverAlertTitle, message: EventAlert.meetingOverMessage, cancelTitle: canceltitle)
            }
        }
        
        let meetingInviteVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing :MeetingInviteVC.self)) as! MeetingInviteVC
        tableView.deselectRow(at: indexPath, animated: true)
        meetingInviteVC.roomname = roomNameArray[indexPath.row]
        meetingInviteVC.startTime = startTimeArray[indexPath.row]
        meetingInviteVC.endTime = endTimeArray[indexPath.row]
        meetingInviteVC.selectedDate =  selectedDate
        self.navigationController?.pushViewController(meetingInviteVC, animated: true)
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let bookingUid = uid[indexPath.row]
        let eventTitle = meetingTitle[indexPath.row]

        if editingStyle == .delete {
            
            self.fetchEventsFromCalendar(calendarTitle: eventTitle , startAt: startTimeArray[indexPath.row], endAt: endTimeArray[indexPath.row])
            
            if self.eventId.count != 0 {
                let eventuid = self.eventId[indexPath.row]
                self.deleteEvent(eventIdentifier: eventuid)
            }
            
            self.fetchTodaysRoomBook(dateString: self.selectedDate)
            tableView.reloadData()
            
            
            
            dabaseReference?.child(FirebaseRoomBookingKey.endTime).child(bookingUid).removeValue(completionBlock: { (error, databaseReference) in
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
