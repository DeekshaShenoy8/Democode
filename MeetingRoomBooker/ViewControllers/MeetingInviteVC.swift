
import UIKit
import Firebase
import FirebaseDatabase
import MessageUI
import EventKit
import  EventKitUI

class MeetingInviteVC: BaseViewController {
    
    @IBOutlet weak var meetingTitleTextField: UITextField!
    @IBOutlet weak var roomnameTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var meetingDescriptionTextView: UITextView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var calendarEventButton: UIButton!

   
    var roomPicker : UIPickerView!
    var dabaseReference : DatabaseReference?
    var roomname : String?
    var startTime: String?
    var endTime : String?
    var selectedDate: String?
    var meetingTitle : String?
    var uid = " "
    var eventId = " "
    var roomNameArray = [String]()
    var datePicker = UIDatePicker()
    var startTimePicker = UIDatePicker()
    var endTimePicker = UIDatePicker()
    let formatter = DateFormatter()
    let eventStore = EKEventStore()
    let calendar = Calendar.current
    let dispatchGroup = DispatchGroup()
    
    let toolbar = UIToolbar()
    let toolbar2 = UIToolbar()
    let toolbar3 = UIToolbar()
    
    
    var prevMeetingTitle = " "
    var prevMeetingDate = " "
    var prevMeetingStartAt = " "
    var prevMeetingEndAt = " "
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        dabaseReference = Database.database().reference()
        updateButton.isSelected = false
        
        calendarEventButton.setBackgroundImage(#imageLiteral(resourceName: "buttonGrey"), for: .normal)
        mailButton.setBackgroundImage(#imageLiteral(resourceName: "secondary803850"), for: .normal)
        updateButton.setBackgroundImage(#imageLiteral(resourceName: "buttonGrey"), for: .normal)
        
        if let selectedDate = selectedDate {
            fetchTodaysRoomBook(dateString: selectedDate)
        }
        
        
        hideKeyboardWhenTappedAround()
        
        createDatePicker()
        startTimePickerCreation()
        fetchRoomName()
        endTimePickerCreation()
        roomNamePickerCreation()
        
        toolbar.sizeToFit()
        toolbar2.sizeToFit()
        toolbar3.sizeToFit()
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        if let selectedDate = selectedDate {
//            fetchTodaysRoomBook(dateString: selectedDate)
//        }
//        
//    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    
    //Create Rooms name list picker
    func roomNamePickerCreation() {
        
        roomPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 160))
        roomPicker.backgroundColor = UIColor.white
        roomPicker.delegate = self
        roomPicker.dataSource = self
        
        let roomNameToolbar = UIToolbar()
        roomNameToolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressAction))
        roomNameToolbar.setItems([doneButton], animated: false)
        
        roomnameTextField.inputView = roomPicker
        roomnameTextField.inputAccessoryView = roomNameToolbar
        
    }
    
    //on room list picker done press action
    func donePressAction() {
        
        roomnameTextField.resignFirstResponder()
    }
    
    //To create date picker
    func createDatePicker() {
        
        datePicker.datePickerMode = .date
        self.datePicker.minimumDate = Date()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        
        
    }
    
    //on Date picker Done press Action
    func  donePressed() {
        
        
        Utility.dateFormatter.dateFormat = "MM/dd/yyyy"
        Utility.dateFormatter.dateStyle = .short
        Utility.dateFormatter.timeStyle = .none
        
        //selectedDate = Utility.dateFormatter.string(from: datePicker.date)
        dateTextField.text = Utility.dateFormatter.string(from: datePicker.date)
        
        self.view.endEditing(true)
    }
    
    
    //CREATE START TIME PICKER
    func startTimePickerCreation()  {
        
        startTimePicker.datePickerMode = UIDatePickerMode.time
        startTimePicker.frame = CGRect(x: 0.0, y: (self.view.frame.height/2 + 60), width: self.view.frame.width, height: 150.0)
        startTimePicker.backgroundColor = UIColor.white
        startTimePicker.locale = Locale(identifier: "en_GB")
        
        var minimumTime = calendar.dateComponents([.hour], from: Date())
        minimumTime.hour = 08
        var maximumTime = calendar.dateComponents([.hour], from: Date())
        maximumTime.hour = 20
        
        formatter.dateFormat = "HH:mm"
        let minTime = calendar.date(from: minimumTime)
        formatter.dateFormat = "HH:mm"
        let maxTime = calendar.date(from: maximumTime)
        
        startTimePicker.minimumDate = minTime
        startTimePicker.maximumDate = maxTime
        startTimePicker.minuteInterval = 15
        
        let doneButton2 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(setTime))
        toolbar2.setItems([doneButton2], animated: false)
        
        startTimeTextField.inputAccessoryView = toolbar2
        startTimeTextField.inputView = startTimePicker
        
        
    }
    
    
    //CREATE END TIME PICKER
    func endTimePickerCreation()  {
        
        endTimePicker.datePickerMode = UIDatePickerMode.time
        endTimePicker.frame = CGRect(x: 0.0, y: (self.view.frame.height/2 + 60), width: self.view.frame.width, height: 150.0)
        endTimePicker.backgroundColor = UIColor.white
        endTimePicker.locale = Locale(identifier: "en_GB")
        //formatter.locale = Locale(identifier: "en_GB")
        //var minimumTime = calendar.dateComponents([.hour], from: Date())
        
        // minimum end time is start time
        let minimumEndTime =  calendar.dateComponents([.hour], from: startTimePicker.date)
        
        var maximumTime = calendar.dateComponents([.hour], from: Date())
        maximumTime.hour = 21
        
        //set minimum and maximum end time limits
        formatter.dateFormat = "HH:mm"
        let minTime = calendar.date(from: minimumEndTime)
        formatter.dateFormat = "HH:mm"
        let maxTime = calendar.date(from: maximumTime)
        
        endTimePicker.minimumDate = minTime
        endTimePicker.maximumDate = maxTime
        endTimePicker.minuteInterval = 15
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(setEndTime))
        toolbar3.setItems([doneButton], animated: false)
        endTimeTextField.inputAccessoryView = toolbar3
        endTimeTextField.inputView = endTimePicker
        
    }
    
    //On end time picker done press action
    func setEndTime()
    {
        
        endTimeTextField.text = formatter.string(from: endTimePicker.date)
        self.view.endEditing(true)
        
    }
    
    //On start time picker done press action
    func setTime()
    {
        
        startTime = formatter.string(from: startTimePicker.date)
        startTimeTextField.text = formatter.string(from: startTimePicker.date)
        self.view.endEditing(true)
        endTimePickerCreation()
        
    }
    
    
    
    //MARK : Fetch Booked rooms of selected date of particular user(one cell detail)
    func fetchTodaysRoomBook(dateString: String){
        
        var idkeys = [String]()
        let userEmail = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail)
        
        if let query = dabaseReference?.child(FirebaseRoomBookingKey.entity).queryOrdered(byChild: FirebaseRoomBookingKey.date).queryEqual(toValue: dateString){
            
            startActivityIndicator()
            
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                
                for snap in snapshot.children.allObjects {
                    let id = snap as! DataSnapshot
                    
                    idkeys.append(String(id.key))
                }
                
                for keys in idkeys {
                    
                    self.dabaseReference?.child(FirebaseRoomBookingKey.entity).child(keys).observeSingleEvent(of: .value, with: { (snapshots) in
                        
                        if let dictionary = snapshots.value as? [String: AnyObject] {
                            
                            
                            if let roomName = (dictionary[FirebaseRoomBookingKey.roomName] as? String), let startTime = (dictionary[FirebaseRoomBookingKey.startTime] as? String), let endTime = (dictionary[FirebaseRoomBookingKey.endTime] as? String), let email = (dictionary[FirebaseRoomBookingKey.email] as? String), let meetingName = (dictionary[FirebaseRoomBookingKey.meetingTitle] as? String), let meetingDetail = (dictionary[FirebaseRoomBookingKey.meetingDescription]) {
                                
                                if( email == userEmail && roomName == self.roomname && startTime == self.startTime && endTime == self.endTime ) {
                                    
                                    self.roomnameTextField.text = roomName
                                    self.meetingTitleTextField.text = meetingName
                                    self.meetingDescriptionTextView.text = meetingDetail as! String
                                    self.dateTextField.text = self.selectedDate
                                    self.startTimeTextField.text = startTime
                                    self.endTimeTextField.text = endTime
                                    self.userNameTextField.text = email
                                    self.uid = keys
                                    
                                }
                            }
                        }
                    })
                }
                self.stopActivityIndicator()
            })
        }
    }
    
    
    
    
    //Fetch rooms name ,(for roomaName picker data)
    func fetchRoomName()
    {
        var idKeys = [String]()
        let query = dabaseReference?.child(FirebaseRoomData.entity).queryOrdered(byChild: FirebaseRoomData.roomName)
        
        query?.observeSingleEvent(of: .value, with: { (snapshot) in
            
            for snap in snapshot.children.allObjects {
                let id = snap as! DataSnapshot
                idKeys.append(String(id.key))
                
            }
            for keys in idKeys {
                self.roomNameArray.append(keys)
            }
            
        })
        
    }
    
    
    
    //on update button click, allow text field editing
    //Update the changes into database
    @IBAction func updateButtonAction(_ sender: Any) {
        //var editable : Bool = false
        updateButton.isSelected = !updateButton.isSelected
        if updateButton.isSelected {
            
            prevMeetingTitle = meetingTitleTextField.text!
            prevMeetingDate = dateTextField.text!
            prevMeetingStartAt = startTimeTextField.text!
            prevMeetingEndAt = endTimeTextField.text!
            
            updateButton.setBackgroundImage(#imageLiteral(resourceName: "secondary803850"), for: .selected)
            //editable = true
            
            meetingTitleTextField.isEnabled = true
            roomnameTextField.isEnabled = true
            meetingDescriptionTextView.isEditable = true
            dateTextField.isEnabled = true
            startTimeTextField.isEnabled = true
            endTimeTextField.isEnabled = true
            
            
            
        }
        else {
            
            searchInDatabaseForUpload()
            //editable = false
            updateButton.backgroundColor = UIColor.gray
            meetingTitleTextField.isEnabled = false
            roomnameTextField.isEnabled = false
            meetingDescriptionTextView.isEditable = false
            dateTextField.isEnabled = false
            startTimeTextField.isEnabled = false
            endTimeTextField.isEnabled = false
            
        }
        
    }
    
    
    //MARK: Invite button click action, send mails
    @IBAction func inviteAction(_ sender: Any) {
        
        addEvent()
        
    }
    
    
    //To delete calendar event, if it is already present
    @IBAction func deleteCalendarEvent(_ sender: Any) {
       
        if let eventTitle = meetingTitleTextField.text {
            
            fetchEventsFromCalendar(eventStore: eventStore, calendarTitle: eventTitle)
            
        }
    }
    
    
    
    //Alert if already current event is exist
    //MARK: Fetch events from calendar, and compare with current event
    func fetchEventsFromCalendar(eventStore : EKEventStore, calendarTitle: String) {
        
        var string = " "
        var endStringTime = " "
        var eventFound = false
        
        if let date = self.selectedDate , let startAt = self.startTime, let endAt = self.endTime {
            
            string = date + " at " + startAt
            endStringTime = date + " at " + endAt
            Utility.dateFormatter.locale = Locale.current
            //Utility.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            Utility.dateFormatter.dateFormat = "MM/dd/yy 'at' HH:mm" //"M/dd/yyyy 'at' h:mm a " //
            
            
            let startDate = Utility.dateFormatter.date(from: string) ?? Calendar.current.date(byAdding: .day, value: 5, to: Date())!//Date()
            
            let endDate = Utility.dateFormatter.date(from: endStringTime) ?? Calendar.current.date(byAdding: .day, value: 5, to: Date())!//Date()
            let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
            let existingEvents = eventStore.events(matching: predicate)
            for singleEvent in existingEvents {
                
                if singleEvent.title == calendarTitle && singleEvent.startDate ==  Utility.dateFormatter.date(from: string) {
                    do {
                        eventFound = true
                        try eventStore.remove(singleEvent, span: .thisEvent, commit: true)
                        addAlert(title: EventAlert.eventRemoved, message: SuccessAlert.message, cancelTitle: canceltitle)
                    } catch {
                        print(error)
                    }
                }
            }
            if (eventFound == false) {
                addAlert(title: EventAlert.noEventFound, message: EventAlert.notFoundMessage, cancelTitle: canceltitle)
            }
        }
    }
    
    //Find Calendar event is already present, then delete it before update
    func FindcalendarEvent() {
        //let eventStore = EKEventStore()
        var prevstring = " "
        var prevendStringTime = " "
        var string = " "
        var endStringTime = " "
        let event = EKEvent(eventStore: eventStore)
        
        if let date = dateTextField.text , let startAt = startTimeTextField.text , let endAt = endTimeTextField.text, let meetingTitle = meetingTitleTextField.text {
            
            prevstring = prevMeetingDate + " at " + prevMeetingStartAt
            prevendStringTime = prevMeetingDate + " at " + prevMeetingEndAt
            string = date + " at " + startAt
            endStringTime = date + " at " + endAt
            
            Utility.dateFormatter.locale = Locale.current
            //Utility.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            Utility.dateFormatter.dateFormat = "MM/dd/yy 'at' HH:mm" //"M/dd/yyyy 'at' h:mm a " //
            
            let startDate = Utility.dateFormatter.date(from: prevstring) ?? Date()
            let endDate = Utility.dateFormatter.date(from: prevendStringTime) ?? Date()
            let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
            let existingEvents = eventStore.events(matching: predicate)
            
            for singleEvent in existingEvents {
                
                if singleEvent.title == prevMeetingTitle && singleEvent.startDate ==  startDate {
                    singleEvent.startDate = Utility.dateFormatter.date(from: string) ?? Date()
                    singleEvent.endDate = Utility.dateFormatter.date(from: endStringTime) ?? Date()
                    singleEvent.title = meetingTitle
                    singleEvent.calendar = eventStore.defaultCalendarForNewEvents
                    do {
                        
                        event.calendar = eventStore.defaultCalendarForNewEvents
                        try eventStore.save(singleEvent, span: .thisEvent, commit: true)
                        
                    } catch {
                        
                        print(error)
                    }
                }
            }
        }
    }
    
    
    
    //If no update change in date and time then update here
    func noChangeIndate() {
        update()
    }
    
    //MARK: Fetch and compare data with already stored data
    //If no booking found then update firebase data
    func searchInDatabaseForUpload() {
        
        var idkeys = [String]()
        var foundDate : Bool = false
        var foundNameTime : Bool = false
        
        //Check for emty fields condition
        
        guard  let startTime = startTimeTextField.text , let endTime = endTimeTextField.text , let dateTime = dateTextField.text, let meetingname = meetingTitleTextField.text, let meetingDescription = meetingDescriptionTextView.text, let roomName = roomnameTextField.text,  !( (meetingname.isEmpty) || (meetingDescription.isEmpty) || (dateTime.isEmpty) || (startTime.isEmpty) || (endTime.isEmpty)) else {
            
            addAlert(title: EmptyFieldAlert.alertTitle, message: EmptyFieldAlert.message, cancelTitle: EmptyFieldAlert.cancelTile)
            return
        }
        
        
        if (self.startTime == startTime && self.endTime == endTime && self.selectedDate == dateTime){
            
            noChangeIndate()
            
        } else {
            
            
            //start time must lesser then endtime
            
            
            guard (startTime < endTime ) else {
                addAlert(title: RoomBookingAlert.validStartAndEndTimeAlertTitle, message: RoomBookingAlert.validStartAndEndTimeMessage, cancelTitle: canceltitle)
                return
                
            }
            let hour = calendar.component(.hour, from: Date())
            let hours : String
            if(hour <= 9){
                hours = "0" + String(hour)
                
            }
            else {
                hours = String(hour)
            }
            print(hours)
            
            print(startTime)
            let today = Utility.dateFormatter.string(from: Date())
            
            ///if let starttingTime = Int(startTime) {
            //start time must greater then, present time(if present day book)
            if selectedDate == today {
                
                if(startTime < hours) {
                    
                    let  timeTitle = "Time is Alredy" + "\(hours)"
                    addAlert(title: timeTitle, message: RoomBookingAlert.validStartAndEndTimeMessage, cancelTitle: canceltitle)
                    
                }
            }
            
            
            
            
            
            //compare booking detail with firebase already booked detail
            //find same date booked room uid
            dispatchGroup.enter()
            let query = dabaseReference?.child(FirebaseRoomBookingKey.entity).queryOrdered(byChild: FirebaseRoomBookingKey.date).queryEqual(toValue: dateTime)
            query?.observeSingleEvent(of: .value, with: { (snapshot) in
                
                
                //if date is already present in database, then fetch those keys
                for snap in snapshot.children.allObjects {
                    
                    foundDate = true
                    let id = snap as! DataSnapshot
                    idkeys.append(String(id.key))
                    
                }
                
                
                //same date booked room found,(check for room name and time)
                if foundDate  {
                    
                    foundNameTime = self.fetchBookingDetailFromDate(dateTime: dateTime, startTime: startTime , endTime: endTime, roomname: roomName , idkeys: idkeys)
                }
                
                self.dispatchGroup.leave()
            })
            
            dispatchGroup.notify(queue: .main) {
                
                if foundDate == false || foundNameTime == false {
                    self.update()
                }
            }
        }
    }
    
    
    //Fetch booking detail from found( date )keys, check if Room is free or not
    
    func fetchBookingDetailFromDate(dateTime: String, startTime : String, endTime:String, roomname: String, idkeys : [String] ) -> Bool {
        //same date booked room found,(check for room name and time)
        var foundNameTimeBool : Bool = false
        for keys in idkeys {
            
            dispatchGroup.enter()
            
            self.dabaseReference?.child(FirebaseRoomBookingKey.roomName).child(keys).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    if let name = (dictionary[FirebaseRoomBookingKey.roomName] as? String), let beginningtime = (dictionary[FirebaseRoomBookingKey.startTime] as? String), let endingtime = (dictionary[FirebaseRoomBookingKey.endTime] as? String){
                        
                        
                        // condition to check roomname and booked time
                        if((roomname == name) && ( (startTime >= beginningtime && endTime <= endingtime) || ( startTime <= beginningtime && endTime > beginningtime) || ( startTime >= beginningtime && startTime <= endingtime ) ))
                        {
                            foundNameTimeBool = true
                            //room is booked on same date and time
//                            print((String(describing: roomname)))
                            
                            self.addAlert(title: RoomBookingAlert.roomIsBookedAlertTitle, message: RoomBookingAlert.roomIsBookedMessage, cancelTitle: canceltitle)
                            return
                            
                        }
                    }
                    
                }
                
                self.dispatchGroup.leave()
            })
            
        }
        
        return foundNameTimeBool
        
    }
    
    
    
    
    
    
    //MARK : Upload data into database
    
    func update() {
        
        FindcalendarEvent()
        if  let meetingTitle = meetingTitleTextField.text , let description = meetingDescriptionTextView.text , let roomName = roomnameTextField.text , let date = dateTextField.text, let starttingTime = startTimeTextField.text , let endingTime = endTimeTextField.text{
            
            dabaseReference?.child(FirebaseRoomBookingKey.roomName).child(uid).updateChildValues([FirebaseRoomBookingKey.meetingTitle : meetingTitle, FirebaseRoomBookingKey.meetingDescription : description, FirebaseRoomBookingKey.roomName: roomName, FirebaseRoomBookingKey.date: date, FirebaseRoomBookingKey.startTime : starttingTime, FirebaseRoomBookingKey.endTime: endingTime], withCompletionBlock: { (error, databaseReference) in
                
                if error != nil {
                    print(String(describing: error))
                }
                else {
                self.addAlert(title: SuccessAlert.changesSaved, message: SuccessAlert.message, cancelTitle: SuccessAlert.cancelTitle)
                }
            })
        }
    }
    
}


extension MeetingInviteVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return roomNameArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return roomNameArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        roomnameTextField.text = roomNameArray[row]
    }
}



extension MeetingInviteVC :  EKEventEditViewDelegate {
    
    func addEvent() {
        var string = " "
        var endStringTime = " "
        let addController = EKEventEditViewController()
        
        // Set addController's event store to the current event store
        addController.eventStore =  self.eventStore
        addController.editViewDelegate = self
        
        let event = EKEvent(eventStore : eventStore)
        if let date = self.selectedDate , let startAt = self.startTime, let endAt = self.endTime {
            
            string = date + " at " + startAt
            endStringTime = date + " at " + endAt
            Utility.dateFormatter.locale = Locale.current
            //Utility.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            Utility.dateFormatter.dateFormat = "MM/dd/yy 'at' HH:mm" //"M/dd/yyyy 'at' h:mm a " //
            
            
            let startDate = Utility.dateFormatter.date(from: string) ?? Calendar.current.date(byAdding: .day, value: 5, to: Date())!//Date()
            
            let endDate = Utility.dateFormatter.date(from: endStringTime) ?? Calendar.current.date(byAdding: .day, value: 5, to: Date())!//Date()
            print(startDate)
            if let meetingTitle = meetingTitleTextField.text {
                event.title = meetingTitle
                event.startDate = startDate
                event.endDate = endDate
                event.calendar = eventStore.defaultCalendarForNewEvents
                addController.event = event
            }
        }
        
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        switch status {
        case .authorized:
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.present(addController, animated: true, completion: nil)
            })
            
        case .notDetermined:
            eventStore.requestAccess(to: EKEntityType.event, completion: { (granted, error) -> Void in
                if granted == true {
                    //self.setNavBarAppearanceStandard()
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.present(addController, animated: true, completion: nil)
                    })
                }
            })
            
        case .denied, .restricted:
            
            addAlert(title: "Access Denied", message: "Permission is needed to access the calendar. Go to Settings > Privacy > Calendars to allow access for the Be Collective app.", cancelTitle: "ok")
            return
        }
        
        
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
