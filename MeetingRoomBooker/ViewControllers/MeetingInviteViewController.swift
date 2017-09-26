//
//  MeetingInviteViewController.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 20/09/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MessageUI
import EventKit

class MeetingInviteViewController: BaseViewController {
   
    @IBOutlet weak var meetingTitleTextField: UITextField!
    var ekCalendar: EKCalendar!
    @IBOutlet weak var roomnameTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var meetingDescriptionTextView: UITextView!
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    var dabaseReference : DatabaseReference?
    var roomname : String?
    var startTime: String?
    var endTime : String?
    var selectedDate: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        dabaseReference = Database.database().reference()

        if let selectedDate = selectedDate {
            fetchTodaysRoomBook(dateString: selectedDate)
        }
        
    }

    override func didReceiveMemoryWarning() {
    
        super.didReceiveMemoryWarning()
        
    }
    
    
    //MARK: Invite button click action, send mails
    @IBAction func inviteAction(_ sender: Any) {
        sendEmail()
    }
    
    
    
    //Fetch Booked rooms of selected date of particular user
    func fetchTodaysRoomBook(dateString: String){
        
//        startTimeArray = []
//        roomNameArray = []
//        endTimeArray = []
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
                            
                            
                            if let roomName = (dictionary["RoomName"] as? String), let startTime = (dictionary["startTime"] as? String), let endTime = (dictionary["endTime"] as? String), let email = (dictionary["email"] as? String), let meetingName = (dictionary["MeetingName"] as? String), let meetingDetail = (dictionary["MeetingDescription"]) {
                                
                                if( email == userEmail && roomName == self.roomname && startTime == self.startTime && endTime == self.endTime ) {
                                    
                                    self.roomnameTextField.text = roomName
                                    self.meetingTitleTextField.text = meetingName
                                    self.meetingDescriptionTextView.text = meetingDetail as! String
                                    self.dateTextField.text = self.selectedDate
                                    self.startTimeTextField.text = startTime
                                    self.endTimeTextField.text = endTime
                                    self.userNameTextField.text = email
                                    
                                }
                            }
                        }
                    })
                }
                self.stopActivityIndicator()
            })
        }
    }


    
    
    
    
    @IBAction func addEventButtonTapAction(_ sender: Any) {

        let eventStore = EKEventStore()
        
        
//        let startDate = Calendar.current.date(byAdding: .day, value: 4, to: Date())!
//        let endDate = Calendar.current.date(byAdding: .day, value: 5, to: Date())
        
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized){
            
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                self.createEvent(eventStore: eventStore, title: "testing event")
            })
        } else {
            createEvent(eventStore: eventStore, title: "TESTING EVENT")
        }
    
    }
    
    
    
 
    func createEvent(eventStore : EKEventStore, title : String ) {
       
        var string = " "
        var endStringTime = " "

        let event = EKEvent(eventStore: eventStore)
        event.title = title
        
        if let date = self.selectedDate , let startAt = self.startTime, let endAt = self.endTime {
            
            string = date + " at " + startAt
            endStringTime = date + " at " + endAt
            Utility.dateFormatter.locale = Locale.current
            //Utility.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            Utility.dateFormatter.dateFormat = "MM/dd/yy 'at' HH:mm" //"M/dd/yyyy 'at' h:mm a " //
            
            let langStr = Locale.current.languageCode
            print(langStr)
            
            event.startDate = Utility.dateFormatter.date(from: string) ?? Calendar.current.date(byAdding: .day, value: 5, to: Date())!//Date()
            print(event.startDate.description(with: .current) )
            
            event.endDate =  Utility.dateFormatter.date(from: endStringTime) ?? Calendar.current.date(byAdding: .day, value: 5, to: Date())!//Date()
            
        }
        print(event.startDate)
        print(event.endDate)
        //        event.startDate = startDate as Date
//        event.endDate = endDate as Date
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent, commit: true)
            print("saved")
        } catch {
            print(error)
            print("bad thing  happnd")
        }
    }

    
    
    
    //MARK: Add event to calendar
    @IBAction func addEventAction(_ sender: Any) {
        var string = " "
        var endStringTime = " "
        let eventStore : EKEventStore = EKEventStore()
        var savedeventId = " "
        
//
////        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
////            
            eventStore.requestAccess(to: .event) { (granted, error) in
               
                if(granted) && (error == nil)
                {
                    print(granted)
                    print(error)
                    
                    let event : EKEvent = EKEvent(eventStore: eventStore)
                    event.title = "Add event title for testing"
                    
                    
                    
                    if let date = self.selectedDate , let startAt = self.startTime, let endAt = self.endTime {
                        
                                            string = date + " at " + startAt
                                            endStringTime = date + " at " + endAt
                                            Utility.dateFormatter.locale = Locale.current
//                                            Utility.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                                            Utility.dateFormatter.dateFormat = "MM/dd/yyyy 'at' HH:mm"
                        
                                            let langStr = Locale.current.languageCode
                                            print(langStr)
                        
                                            event.startDate = Utility.dateFormatter.date(from: string) ?? Date()
                                            print(event.startDate.description(with: .current) )
                        
                                            event.endDate =  Utility.dateFormatter.date(from: endStringTime) ?? Date()
                                        
                                        }
                    
                    
                    print(event.startDate)
                   
                    print(event.endDate)
                    event.notes = "This is testing NOTE"
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    
                    do {
                        try eventStore.save(event, span: .thisEvent)
                        savedeventId = event.eventIdentifier
                        print(savedeventId)
                    } catch let error as NSError {
                        print(error)
                    }
                    print("saved")
                    
                } else {
                    print(error)
                }
            }
        
    }
    
    
    
    
    
    
    
    @IBAction func calendarEventButtonAction(_ sender: Any) {
        var string = " "
        var endStringTime = " "
        let eventStore = EKEventStore()
        
        if let calendarForEvent = eventStore.calendar(withIdentifier: self.ekCalendar.calendarIdentifier) {
            
            let event = EKEvent(eventStore: eventStore)
            
            event.calendar = calendarForEvent
            event.title = "Calendar event button action"
          
            if let date = self.selectedDate , let startAt = self.startTime, let endAt = self.endTime {
                
                string = date + " at " + startAt
                endStringTime = date + " at " + endAt
                Utility.dateFormatter.locale = Locale.current
                //Utility.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                Utility.dateFormatter.dateFormat = "M/dd/yyyy 'at' h:mm a "//"MM/dd/yyyy 'at' HH:mm"
                
                let langStr = Locale.current.languageCode
                print(langStr)
                
                event.startDate = Utility.dateFormatter.date(from: string) ?? Date()
                print(event.startDate.description(with: .current) )
                
                event.endDate =  Utility.dateFormatter.date(from: endStringTime) ?? Date()
                
            }
            print(event.startDate)
            print(event.endDate)
            //        event.startDate = startDate as Date
            //        event.endDate = endDate as Date
            //event.calendar = eventStore.defaultCalendarForNewEvents
            
            do {
                try eventStore.save(event, span: .thisEvent, commit: true)
                print("saved")
                 self.dismiss(animated: true, completion: nil)
            } catch {
                print(error)
                print("bad thing  happnd")
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    @IBAction func remainderAction(_ sender: Any) {
        
        let eventStore = EKEventStore()
        let reminder = EKReminder(eventStore: eventStore)
        
        reminder.title = "Go to the meeting"
        reminder.calendar = eventStore.defaultCalendarForNewReminders()
        
        do {
            try eventStore.save(reminder,
                                commit: true)
        } catch let error {
            print("Reminder failed with error \(error.localizedDescription)")
        }

//        var eventStore: EKEventStore!
//
//        let reminder = EKReminder(eventStore: eventStore)
//        reminder.title = "meeting"
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        
//         if let date = self.selectedDate , let startAt = self.startTime, let endAt = self.endTime {
//        let string = date + " at " + startAt
//        
//        let dueDateComponents =  Utility.dateFormatter.date(from: string) ?? Date()
//        //appDelegate.dateComponentFromNSDate(self.datePicker.date)
//        reminder.dueDateComponents = dueDateComponents
//        }
//        reminder.calendar = eventStore.defaultCalendarForNewReminders()
//        // 2
//        do {
//            try eventStore.save(reminder, commit: true)
//            dismiss(animated: true, completion: nil)
//        }catch{
//            print("Error creating and saving new reminder : \(error)")
//        }
        
        
    }
    


    
    //MARK: Deleting calendar event
    
    func deleteEvent(eventStore: EKEventStore, eventIdentifier : String) {
        let eventToRemove = eventStore.event(withIdentifier: eventIdentifier)
        if(eventToRemove != nil) {
            do {
                try eventStore.remove(eventToRemove!, span: .thisEvent)
            } catch {
                print("error during delete \(error)")
            }
        }
    }
    
    
    
}




extension MeetingInviteViewController: MFMailComposeViewControllerDelegate {
    func sendEmail() {
        let mailComposeViewController = configuredMailComposeViewController()

        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property

        //mailComposerVC.setToRecipients(["deeksha.shenoy@ymedialabs.com"])

        if let meetingTitle = meetingTitleTextField.text , let meetingDescription = meetingDescriptionTextView.text , let date = dateTextField.text, let roomname = roomnameTextField.text, let startTime = startTimeTextField.text , let endTime = endTimeTextField.text {
        mailComposerVC.setSubject(meetingTitle)
        mailComposerVC.setMessageBody("Meetingi scheduled on \(date)  plz be gather in \(roomname), at \(startTime)", isHTML: false)
        }
        return mailComposerVC
    }

    func showSendMailErrorAlert() {

        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()

    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

