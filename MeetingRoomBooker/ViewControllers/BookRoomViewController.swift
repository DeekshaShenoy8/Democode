//
//  BookRoomViewController.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 09/09/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class BookRoomViewController: BaseViewController {
    
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var facilityLabel: UITextView!
    
    @IBOutlet weak var meetingTitleField: UITextField!
    @IBOutlet weak var meetingDescriptionText: UITextView!
    @IBOutlet weak var dateTimeText: UITextField!
    
    
    @IBOutlet weak var meetingTitleLabel: UITextField!
    @IBOutlet weak var meetingDescriptionLabel: UITextView!
    
    @IBOutlet weak var endTimeText: UITextField!
    @IBOutlet weak var startTimeText: UITextField!
    
//    var startTimePicker : UIPickerView!
//    var endTimePicker : UIPickerView!
    
    var databaseReference : DatabaseReference?
    var databaseHandle : DatabaseHandle?
    var selectedDate : Date?
    
    var datePicker = UIDatePicker()
    var startTimePicker = UIDatePicker()
    var endTimePicker = UIDatePicker()
    let formatter = DateFormatter()
    let calendar = Calendar.current
    
    var facilityArray = [String]()

    let dispatchGroup = DispatchGroup()
    
    var today : String = " "
   
    var listOfRoom = [MeetingRoom]()
    
    //selected cell roomaname
    var roomname :String?
    
    //static var roomId : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseReference = Database.database().reference()
        hideKeyboardWhenTappedAround()
        
        // fetch rooms detail from database
        fetchRoomDetail()
        
        //creation of date & time picker
        createDatePicker()
        startTimePickerCreation()
        endTimePickerCreation()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
                // Dispose of any resources that can be recreated.
    }
    
  
    // unique id creation function
/*    func idCreation() -> Int {
        BookRoomViewController.roomId = BookRoomViewController.roomId+1
        return BookRoomViewController.roomId
   } */
    
    
    // Date picker creation
    func createDatePicker() {
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        
        dateTimeText.inputAccessoryView = toolbar
        
        dateTimeText.inputView = datePicker
        
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
        
        
        //        Utility.dateFormatter.dateFormat = "HH:mm"
        //        let minTime = calendar.date(from: minimumTime)
        //        Utility.dateFormatter.dateFormat = "HH:mm"
        //        let maxTime = calendar.date(from: maximumTime)
        
        formatter.dateFormat = "HH:mm"
        let minTime = calendar.date(from: minimumTime)
        formatter.dateFormat = "HH:mm"
        let maxTime = calendar.date(from: maximumTime)
        
        
        
        startTimePicker.minimumDate = minTime
        startTimePicker.maximumDate = maxTime
        startTimePicker.minuteInterval = 15
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(setTime))
        
        toolbar.setItems([doneButton], animated: false)
        startTimeText.inputAccessoryView = toolbar
        startTimeText.inputView = startTimePicker
        
    }
    
    
    //CREATE END TIME PICKER
    func endTimePickerCreation()  {
        
        endTimePicker.datePickerMode = UIDatePickerMode.time
        endTimePicker.frame = CGRect(x: 0.0, y: (self.view.frame.height/2 + 60), width: self.view.frame.width, height: 150.0)
        endTimePicker.backgroundColor = UIColor.white
        endTimePicker.locale = Locale(identifier: "en_GB")
        //formatter.locale = Locale(identifier: "en_GB")
        var minimumTime = calendar.dateComponents([.hour], from: Date())
        minimumTime.hour = 08
        var maximumTime = calendar.dateComponents([.hour], from: Date())
        maximumTime.hour = 21
        
        
        formatter.dateFormat = "HH:mm"
        let minTime = calendar.date(from: minimumTime)
        formatter.dateFormat = "HH:mm"
        let maxTime = calendar.date(from: maximumTime)
        
        
        
        //        Utility.dateFormatter.dateFormat = "HH:mm"
        //        let minTime = calendar.date(from: minimumTime)
        //        Utility.dateFormatter.dateFormat = "HH:mm"
        //        let maxTime = calendar.date(from: maximumTime)
        //
        
        endTimePicker.minimumDate = minTime
        endTimePicker.maximumDate = maxTime
        endTimePicker.minuteInterval = 15
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(setEndTime))
        toolbar.setItems([doneButton], animated: false)
        endTimeText.inputAccessoryView = toolbar
        endTimeText.inputView = endTimePicker
        
        
        
    }
    
    func setEndTime()
    {
        
        //formatter.timeStyle = .short
        print(startTimePicker.date)
        //endTimeText.text = Utility.dateFormatter.string(from: endTimePicker.date)
        endTimeText.text = formatter.string(from: endTimePicker.date)
        self.view.endEditing(true)
    }
    
    func setTime()
    {
        
        //formatter.timeStyle = .short
        //        startTimeText.text = Utility.dateFormatter.string(from: startTimePicker.date)
        startTimeText.text = formatter.string(from: startTimePicker.date)
        self.view.endEditing(true)
    }
    

    
    
    //on action done pressed
    func  donePressed() {
        
        
        Utility.dateFormatter.dateFormat = "MM/dd/yyyy"// "yyyy-mm-dd"
        Utility.dateFormatter.dateStyle = .short
        Utility.dateFormatter.timeStyle = .none
        
        dateTimeText.text = Utility.dateFormatter.string(from: datePicker.date)
        today = Utility.dateFormatter.string(from: Date())
        
        self.view.endEditing(true)
    }
    
    
   
    //Fetch the required room detail
    func fetchRoomDetail()
    {
       databaseReference?.child("rooms").child(roomname!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                self.roomNameLabel.text = dictionary["RoomName"] as? String
                self.capacityLabel.text = dictionary["Capacity"] as? String
                 self.facilityArray = dictionary["facility"] as! [String]
                
            }
        
        //display available facilities in text view
        for items in self.facilityArray {
           self.facilityLabel.text.append(items)
            self.facilityLabel.text.append("\n")
        }
        
        })
    }
    
    
    //MARK: add bookedRoom Detail into firebase database
    @IBAction func addBookRoomIntoDatabase(_ sender: Any) {
        // idCreation()
        //addBookedRoom()
        addRoomTooDatabase()
    }
    
    
    //add Booked Room into firebase Database
    func addRoomTooDatabase() {
        
        var idkeys = [String]()
        var foundDate : Bool = false
        var foundNameTime : Bool = false
        //var validDate : Bool = true
        
        guard !( (meetingTitleField.text?.isEmpty)! || (meetingDescriptionText.text?.isEmpty)! || (dateTimeText.text?.isEmpty)! || (startTimeText.text?.isEmpty)! || (endTimeText.text?.isEmpty)!) else {
            
            addAlert(title: "PLEASE FILL ALL THE DETAIL", message: "Try again", cancelTitle: "ok")
            return
        }
            if let meetingname = meetingTitleField.text, let meetingDescription = meetingDescriptionText.text, let dateTime = dateTimeText.text, let startTime = startTimeText.text , let endTime = endTimeText.text, let roomname = roomname {
                
                guard (startTime < endTime ) else {
                    addAlert(title: "Enter valid Start and End Time", message: "Room booking is valid from 8am to 8pm", cancelTitle: "Ok")
                    return
                }
                
                let hour = calendar.component(.hour, from: Date())
                let hours = String(hour)
                print(hours)
                print(startTime)
                
                if dateTime == today {
                if(startTime < hours) {
                    
                    let  timeTitle = "Time is Alredy" + "\(hours)"
                    addAlert(title: timeTitle, message: "select any other valid time", cancelTitle: "Ok")
                }
                }
  
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
                        
                        foundNameTime = self.fetchBookingDetailFromDate(dateTime: dateTime, startTime: startTime , endTime: endTime, roomname: roomname , idkeys: idkeys)
                    }
                    
                    self.dispatchGroup.leave()
                })
                
                dispatchGroup.notify(queue: .main) {
                    
                    if foundDate == false || foundNameTime == false {
                         self.loadToFirebase(roomname: roomname, meetingname: meetingname, meetingDescription: meetingDescription, dateTime: dateTime, startTime: startTime, endTime: endTime)
                        }
                    
                }
        }
        
     
        
    }
    
    
    // Successfully loaded function
    
    func loadToFirebase(roomname: String, meetingname: String, meetingDescription: String, dateTime: String, startTime : String, endTime:String)
    {
        //store booking in database
            startActivityIndicator()
        self.databaseReference?.child("RoomBooking").childByAutoId().setValue(["RoomName": self.roomname, "MeetingName": meetingname, "MeetingDescription": meetingDescription, "date" : dateTime, "startTime"
            : startTime, "endTime": endTime])
        stopActivityIndicator()
        print("added successfully")
        print("room is free")
        self.addAlert(title: "Room Booked Succesfully ", message: "Thank you", cancelTitle: "ok")
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
            
            //func*****
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
                        self.addAlert(title: "Room is already booked ", message: "Try with other room", cancelTitle: "OK")
                        return
                    }
                    
                }
                
                self.dispatchGroup.leave()
            })
            
        }
        
        return foundNameTimeBool
        
    }
    
    
    
      @IBAction func viewBookedRoomTable(_ sender: Any) {
        
        let calendarTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalandarTableViewController") as! CalandarTableViewController
        self.navigationController?.pushViewController(calendarTableVC, animated: true)

    }
    
   

}

