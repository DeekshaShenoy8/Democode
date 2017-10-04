//
//  BookMeetingRoom.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 03/10/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


struct MeetingRoomDetail {
    var Capacity : String = " "
    var Facility = [String]()
    var MeetingDescription : String = " "
    var MeetingName : String = " "
    var RoomName : String = " "
    var date : String = " "
    var email : String = " "
    var endTime : String = " "
    var startTime : String = " "
    
    
}
class BookMeetingRoom: NSObject {
    
    
    var roomDetail = MeetingRoomDetail()
    var roomDetails = [MeetingRoomDetail]()
    var databaseReference : DatabaseReference?
    
    
    //TO get detail of Rooms
//    func getRoomDetail(roomname: String, callback: @escaping(Bool) -> ()){
//        var sucess = false
//        
//        databaseReference = Database.database().reference()
//        
//        databaseReference?.child("rooms").child(roomname).observeSingleEvent(of: .value, with: { (snapshot) in
//            if let dictionary = snapshot.value as? [String: AnyObject] {
//                
//                self.roomDetail.RoomName = (dictionary["RoomName"] as? String)!
//                self.roomDetail.Capacity = (dictionary["Capacity"] as? String)!
//                self.roomDetail.Facility = dictionary["facility"] as! [String]
//                
//            }
//            sucess = true
//            
//            callback(sucess)
//        })
//        
//    }
    
    
    //To fetch booking of particular day
    func getBookedRoom(dateString : String, emailid : String, callback: @escaping (Bool, [String]) -> () ) {
        var success = false
        var idkeys = [String]()
        var bookingid = [String]()
        roomDetails = []
        databaseReference = Database.database().reference()
        if let query = databaseReference?.child("RoomBooking").queryOrdered(byChild: "date").queryEqual(toValue: dateString){
            //startActivityIndicator()
            
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                
                for snap in snapshot.children.allObjects {
                    let id = snap as! DataSnapshot
                    idkeys.append(String(id.key))
                }
                
                for keys in idkeys {
                    
                    self.databaseReference?.child("RoomBooking").child(keys).observeSingleEvent(of: .value, with: { (snapshots) in
                        
                        if let dictionary = snapshots.value as? [String: AnyObject] {
                            
                            if let name = (dictionary["RoomName"] as? String), let startTime = (dictionary["startTime"] as? String), let endTime = (dictionary["endTime"] as? String) ,let email = (dictionary["email"] as? String), let meetingName =  (dictionary["MeetingName"] as? String) {
                                
                                self.roomDetail.RoomName = name
                                self.roomDetail.startTime = startTime
                                self.roomDetail.endTime = endTime
                                self.roomDetail.email = email
                                self.roomDetail.MeetingName = meetingName
                                
                                if( emailid == email) {
                                bookingid.append(keys)
                                }
                                self.roomDetails.append(self.roomDetail)
                                success = true
                            }
                        }
                        callback(success,bookingid)
                    })
                }
            })
        }
        
    }
    
    
    
    
    
}
