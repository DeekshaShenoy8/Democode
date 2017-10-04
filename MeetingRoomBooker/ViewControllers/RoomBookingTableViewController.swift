
import UIKit
import Firebase
import FirebaseDatabase
import EventKit

class RoomBookingTableViewController: BaseViewController{// CellResponder  {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var roomname : String = " "
    var actualCapacity : String = " "
    var facilityArray = [String]()
    
    let roomsDetail = [ "Meeting Title", "Description", "Date", "Start Time","End Time", "Capacity", "Facility"]
    
    let userEmail = UserDefaults.standard.string(forKey: "userName")
    
    var datePicker = UIDatePicker()
    var startTimePicker = UIDatePicker()
    var endTimePicker = UIDatePicker()
    let formatter = DateFormatter()
    
    let toolbar = UIToolbar()
    let toolbar2 = UIToolbar()
    let toolbar3 = UIToolbar()
    
    var meetingName : String?
    var meetingDescription : String?
    var selectedDate : String?
    var startTime : String?
    var endTime : String?
    var capacity : String?
    var facility = [String]()
    var eventId = " "
    let calendar = Calendar.current
    let dispatchGroup = DispatchGroup()
    var databaseReference : DatabaseReference?
    var startHour : Int = 0
    var startMinute: Int = 0
    
    let eventStore = EKEventStore()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        
        databaseReference = Database.database().reference()
        self.navigationItem.title = roomname
        
        hideKeyboardWhenTappedAround()
        
        createDatePicker()
        startTimePickerCreation()
        
        toolbar.sizeToFit()
        toolbar2.sizeToFit()
        toolbar3.sizeToFit()
        setupTableFooterView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Date picker creation
    func createDatePicker() {
        
        datePicker.datePickerMode = .date
        self.datePicker.minimumDate = Date()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        
    }
    
    //on Date picker Done press Action
    func  donePressed() {
        
        
        Utility.dateFormatter.dateFormat = "MM/dd/yyyy"
        Utility.dateFormatter.dateStyle = .short
        Utility.dateFormatter.timeStyle = .none
        
        selectedDate = Utility.dateFormatter.string(from: datePicker.date)
        tableView.reloadData()
        
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
        
    }
    
    
    //CREATE END TIME PICKER
    func endTimePickerCreation()  {
        
        endTimePicker.datePickerMode = UIDatePickerMode.time
        endTimePicker.frame = CGRect(x: 0.0, y: (self.view.frame.height/2 + 60), width: self.view.frame.width, height: 150.0)
        endTimePicker.backgroundColor = UIColor.white
        endTimePicker.locale = Locale(identifier: "en_GB")
        
        let minimumEndTime =  calendar.dateComponents([.hour,.minute], from: startTimePicker.date)
        
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
        
    }
    
    func setEndTime()
    {

        endTime = formatter.string(from: endTimePicker.date)
        tableView.reloadData()
        self.view.endEditing(true)
        
    }
    
    func setTime()
    {
        
        //formatter.timeStyle = .short
        //        startTimeText.text = Utility.dateFormatter.string(from: startTimePicker.date)
        startTime = formatter.string(from: startTimePicker.date)
        startHour = calendar.component(.hour, from: startTimePicker.date)
        startMinute = calendar.component(.minute, from: startTimePicker.date)
        tableView.reloadData()
        self.view.endEditing(true)
        endTimePickerCreation()
    }
    
    
    //To store Booked Room into Firebase
    func addRoomTooDatabase() {
        
        var idkeys = [String]()
        var foundDate : Bool = false
        var foundNameTime : Bool = false
        
        //Check for emty fields condition
        guard  let startTime = startTime , let endTime = endTime , let dateTime = selectedDate, let meetingname = meetingName, let meetingDescription = meetingDescription, let userEmail = userEmail, let requiredCapacity = capacity, !( (meetingname.isEmpty) || (meetingDescription.isEmpty) || (dateTime.isEmpty) || (startTime.isEmpty) || (endTime.isEmpty)) else {
            
            addAlert(title: "PLEASE FILL ALL THE DETAIL", message: "Try again", cancelTitle: "ok")
            return
        }
        
        
        tableView.reloadData()
        
        guard (startTime < endTime ) else {
            addAlert(title: "Enter valid Start and End Time", message: "Room booking is valid from 8am to 8pm", cancelTitle: "Ok")
            return
            
        }
        
        
        let hour = calendar.component(.hour, from: Date())
        let minute = calendar.component(.minute, from: Date())
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
        let  timeTitle = "Time is Alredy" + "\(hours)" + ":" + "\(minute)"
        
        if selectedDate == today {
            
            if(startHour < hour) {
                
                
                addAlert(title: timeTitle, message: "select any other valid time", cancelTitle: "Ok")
                
            }
            
            if startHour == hour {
                if startMinute < minute {
                    addAlert(title: timeTitle, message: "select any other valid time", cancelTitle: "ok")
                }
            }
            
        }
        
        print("capacity entered = \(requiredCapacity), real capacity = \(actualCapacity)")
        //compare booking detail with firebase already booked detail
        //find same date booked room uid
        dispatchGroup.enter()
        let query = databaseReference?.child("RoomBooking").queryOrdered(byChild: "date").queryEqual(toValue: dateTime)
        query?.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            //if date is already present in database, then fetch those keys
            for snap in snapshot.children.allObjects {
                
                foundDate = true
                let id = snap as! DataSnapshot
                idkeys.append(String(id.key))
                
            }
            
            
            //same date booked room found,(check for room name and time)
            if foundDate  {
                print("capacity entered = \(requiredCapacity), real capacity = \(self.actualCapacity)")
                
                foundNameTime = self.fetchBookingDetailFromDate(dateTime: dateTime, startTime: startTime , endTime: endTime, roomname: self.roomname , idkeys: idkeys)
            }
            
            self.dispatchGroup.leave()
        })
        
        dispatchGroup.notify(queue: .main) {
            
            if foundDate == false || foundNameTime == false {
                //print("capacity =\(requiredCapacity)")
                //Room is free, accept the request and save it into database
                print("capacity entered = \(requiredCapacity), real capacity = \(self.actualCapacity)")
                
                self.loadToFirebase(roomname: self.roomname, meetingname: meetingname, meetingDescription: meetingDescription, dateTime: dateTime, startTime: startTime, endTime: endTime, mailId : userEmail)
            }
            
        }
    }
    
    
    
    // Successfully loaded function
    
    func loadToFirebase(roomname: String, meetingname: String, meetingDescription: String, dateTime: String, startTime : String, endTime:String, mailId : String)
    {
        
        
        if let requiredCapacity = self.capacity, let numericRequiredCapacity = Int(requiredCapacity), let realCapacity = Int(self.actualCapacity){
            
            if  numericRequiredCapacity > realCapacity {
                
                addAlert(title: "Entered Capacity is more then Room capacity", message: "try again", cancelTitle: "ok")
                return
            }
        }
        
        //store booking details into firebase
        self.databaseReference?.child("RoomBooking").childByAutoId().setValue(["RoomName": self.roomname, "MeetingName": meetingname, "MeetingDescription": meetingDescription, "date" : dateTime, "startTime"
            : startTime, "endTime": endTime, "email" : mailId, "Capacity" : capacity ?? self.actualCapacity, "Facity" : facility ])
        stopActivityIndicator()
        print("added successfully")
        print("room is free")
        self.alertBooking(title: "Room Booked Succesfully ", message: "Thank you", cancelTitle: "ok")
    }
    
    
    // MARK :- alert action, on Cancel title press move to other VC
    func alertBooking(title: String, message :  String, cancelTitle : String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.default, handler: {action in
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: RoomsTableViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    
    //Based on date check roomname and time detail
    func fetchBookingDetailFromDate(dateTime: String, startTime : String, endTime:String, roomname: String, idkeys : [String] ) -> Bool {
        //same date booked room found,(check for room name and time)
        var foundNameTimeBool : Bool = false
        for keys in idkeys {
            //print(keys)
            var name : String = " "
            var beginningtime : String = " "
            var endingtime : String = " "
            
            dispatchGroup.enter()
            
            self.databaseReference?.child("RoomBooking").child(keys).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    name = (dictionary["RoomName"] as? String)!
                    beginningtime = (dictionary["startTime"] as? String)!
                    endingtime = (dictionary["endTime"] as? String)!
                    
                    
                    // condition to check roomname and booked time
                    if((roomname == name) && ( (startTime >= beginningtime && endTime <= endingtime) || ( startTime <= beginningtime && endTime > beginningtime) || ( startTime >= beginningtime && startTime <= endingtime ) ))
                    {
                        foundNameTimeBool = true
                        //room is booked on same date and time
                        print("enterd room \(String(describing: roomname))")
                        
                        self.alertBooking(title: "Room is alreday booked", message: "try with other rooms", cancelTitle: "Ok")
                        return
                        
                    }
                    
                }
                
                self.dispatchGroup.leave()
            })
            
        }
        
        return foundNameTimeBool
        
    }
    
    func viewScheduleTapped() {
        
        let calendarTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalandarTableViewController") as! CalandarTableViewController
        self.navigationController?.pushViewController(calendarTableVC, animated: true)
    }
    
    
    
    func createEvent(eventStore : EKEventStore, title : String ) {
        
        var string = " "
        var endStringTime = " "
        //        var eventId = " "
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        
        if let date = self.selectedDate , let startAt = self.startTime, let endAt = self.endTime {
            
            string = date + " at " + startAt
            endStringTime = date + " at " + endAt
            Utility.dateFormatter.locale = Locale.current
            //Utility.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            Utility.dateFormatter.dateFormat = "MM/dd/yy 'at' HH:mm" //"M/dd/yyyy 'at' h:mm a " //
            
            
            event.startDate = Utility.dateFormatter.date(from: string) ?? Calendar.current.date(byAdding: .day, value: 5, to: Date())!//Date()
            print(event.startDate.description(with: .current) )
            
            event.endDate =  Utility.dateFormatter.date(from: endStringTime) ?? Calendar.current.date(byAdding: .day, value: 5, to: Date())!//Date()
            
        }
        print(event.startDate)
        print(event.endDate)
        
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent, commit: true)
            print("saved")
            eventId = event.eventIdentifier
            print(eventId)
            //update(eventId: eventId)
            //update()
        } catch {
            print(error)
            print("bad thing  happnd")
        }
    }
}




extension RoomBookingTableViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //NUMBER OF ROWS IN EACH SECTIONS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return roomsDetail.count
        default :
            return facilityArray.count
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (indexPath.section == 1) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "roomBookingCheckboxTableViewCell", for: indexPath) as! RoomBookingCheckBoxTableViewCell
            
            cell.checkBoxTitleLabel.text = self.facilityArray[indexPath.row]
            cell.checkBoxButton.tag = indexPath.row
            cell.checkBoxButton.addTarget(self, action: #selector(checkBoxClickAction), for: .touchUpInside)
            
            return cell
        }
        else
            if (indexPath.row == 1 && indexPath.section == 0)
            {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "roomBookingCustomTableViewCell", for: indexPath) as! RoomBookingCustomTableViewCell
                
                if(cell.roomDeatailTextView.text.isEmpty) {
                    cell.roomDeatailTextView.textColor = UIColor.lightGray
                    cell.roomDeatailTextView.text = "Meeting Description"
                }
                
                cell.roomsDetailLabel.text = self.roomsDetail[indexPath.row]
                cell.roomDeatailTextView.delegate = self
                meetingDescription = cell.roomDeatailTextView.text
                
                cell.roomDeatailTextView.tag = 1
                return cell
                
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "roomBookingTableViewCell", for: indexPath) as! RoomBookingTableViewCell
                
                cell.roomsDetailLabel.text = roomsDetail[indexPath.row]
                
                if(indexPath.row == 0 && indexPath.section == 0){
                    
                    meetingName = cell.roomsDetailTextField.text
                    
                }
                
                //access date picker value
                if ( indexPath.row == 2 && indexPath.section == 0) {
                    
                    cell.roomsDetailTextField.inputAccessoryView = toolbar
                    cell.roomsDetailTextField.inputView = datePicker
                    cell.roomsDetailTextField.text = selectedDate
                    
                }
                
                //access start time picker value
                if (indexPath.row == 3 && indexPath.section == 0) {
                    
                    cell.roomsDetailTextField.inputAccessoryView = toolbar2
                    cell.roomsDetailTextField.inputView = startTimePicker
                    cell.roomsDetailTextField.text = startTime
                    
                }
                
                //access end time picker value
                if (indexPath.row == 4 && indexPath.section == 0) {
                    
                    cell.roomsDetailTextField.inputAccessoryView = toolbar3
                    cell.roomsDetailTextField.inputView = endTimePicker
                    cell.roomsDetailTextField.text = endTime
                    
                    
                }
                if (indexPath.row == 5 && indexPath.section == 0) {
                    
                    cell.roomsDetailLabel.text = roomsDetail[indexPath.row]
                    cell.roomsDetailTextField.keyboardType = .numberPad
                    capacity = cell.roomsDetailTextField.text
                    
                }
                if(indexPath.row == 6 && indexPath.section == 0) {
                    
                    cell.roomsDetailLabel.text = roomsDetail[indexPath.row]
                    cell.roomsDetailTextField.placeholder = "Others"
                    
                    if let mentionedFacility = cell.roomsDetailTextField.text {
                        
                        if !(mentionedFacility.isEmpty) {
                            facility.append(mentionedFacility)
                        }
                    }
                    
                }
                cell.roomsDetailTextField.placeholder = roomsDetail[indexPath.row]
                cell.roomsDetailTextField.delegate = self
                cell.roomsDetailTextField.tag = indexPath.row
                
                return cell
                
        }
        
    }
    
    //    Footer for table view
    func setupTableFooterView() {
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 120))
        footerView.backgroundColor = .white
        
        let button = UIButton(frame: CGRect(x: (footerView.frame.width/2) - 60, y: 20, width: 130, height: 30))
        button.setTitle("Book Room", for: .normal)
        button.backgroundColor = UIColor(red: 81.0/255.0, green: 38.0/255.0, blue: 69.0/255.0, alpha: 1.0)
        button.addTarget(self, action: #selector(addRoomTooDatabase), for: .touchUpInside)
        
        
        
        let viewSchedule = UIButton(frame: CGRect(x: (footerView.frame.width/2) - 60  , y: 70 , width: 130, height: 30))
        viewSchedule.setTitle("View Schedule", for: .normal)
        viewSchedule.backgroundColor = UIColor(red: 81.0/255.0, green: 38.0/255.0, blue: 69.0/255.0, alpha: 1.0)
        viewSchedule.addTarget(self, action: #selector(viewScheduleTapped), for: .touchUpInside)
        
        footerView.addSubview(viewSchedule)
        footerView.addSubview(button)
        tableView.tableFooterView = footerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.section == 1) {
            
            return 40
            
        }
        else if(indexPath.section == 0 && indexPath.row == 1) {
            
            return 70.0
        }
        else {
            
            return 70.0
            
        }
    }
    
    func checkBoxClickAction(button : UIButton) {
        
        print(button.isSelected)
        button.isSelected = !button.isSelected
        
        switch button.tag {
        case 0:
            if button.isSelected == true {
                facility.append(facilityArray[0])
                
            }
            else {
                
                if let index = facility.index(of: facilityArray[0]) {
                    facility.remove(at: index)
                    
                }
                
            }
        case 1:
            if button.isSelected == true {
                facility.append(facilityArray[1])
            }
            else {
                
                if let index = facility.index(of: facilityArray[1]) {
                    facility.remove(at: index)
                }
            }
        case 2 :
            if button.isSelected == true {
                facility.append(facilityArray[2])
            }
            else {
                if let index = facility.index(of: facilityArray[2]) {
                    facility.remove(at: index)
                }
            }
            
        default:
            if button.isSelected == true {
                facility.append(facilityArray[3])
            }
            else {
                
                if let index = facility.index(of: facilityArray[3]) {
                    facility.remove(at: index)
                }
            }
        }
        print(facility)
        
        
    }
    
}

extension RoomBookingTableViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            
            
            nextField.becomeFirstResponder()
            
        }
            
        else {
            
            textField.resignFirstResponder()
            return true
            
        }
        return false
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField.tag == 6) {
            moveTextField(textField, moveDistance: -250, up: true)
        }
    }
    
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
        
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if(textField.tag == 6) {
            moveTextField(textField, moveDistance: -250, up: false)
            
        }
    }
}

extension RoomBookingTableViewController : UITextViewDelegate  {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = "Meeting Description"
            textView.textColor = UIColor.lightGray
        }
    }
}



extension RoomBookingTableViewController {
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            tableView.contentInset = UIEdgeInsetsMake(64, 0, keyboardHeight, 0)
        }
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
            
        })
        
    }
    
    
    
}

