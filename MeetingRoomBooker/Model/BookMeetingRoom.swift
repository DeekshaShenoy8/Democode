
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
    

    
    //To fetch booking of particular day
    func getBookedRoom(dateString : String, emailid : String, callback: @escaping (Bool, [String]) -> () ) {
        var success = false
        var idkeys = [String]()
        var bookingid = [String]()
        self.roomDetails = []

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
                                
                                var roomDetail = MeetingRoomDetail()
                                
                                roomDetail.RoomName = name
                                roomDetail.startTime = startTime
                                roomDetail.endTime = endTime
                                roomDetail.email = email
                                roomDetail.MeetingName = meetingName
                                
                                if( emailid == email) {
                                    
                                     self.roomDetail.RoomName = name
                                     self.roomDetail.startTime = startTime
                                     self.roomDetail.endTime = endTime
                                     self.roomDetail.email = email
                                     self.roomDetail.MeetingName = meetingName

                                bookingid.append(keys)
                                }
                                self.roomDetails.append(roomDetail)
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
    
    
   /* func fetchFreeRoomsFromFirebase(roomlist : [String] , callback: @escaping (Bool) -> ()) {
        var success = false
        //let name = "Kings Landing"
        let calendar = Calendar.current
        var hours = " "
        let hour = calendar.component(.hour, from: Date())
        let minute = calendar.component(.minute, from: Date())
        let today = Utility.dateFormatter.string(from: Date())
        let foundbusy = false
        if(hour <= 9){
            hours = "0" + String(hour)
            
        }
        else {
            hours = String(hour)
        }

        print(roomlist)
        let currentTime = hours + ":" + String(minute)
        
        databaseReference = Database.database().reference()
        databaseReference?.child("RoomBooking").observe(.value, with: { (snapshot) in
            
            
            if let snapshots = snapshot.value as? [String: Any] {
                let keys = snapshots.keys
                for key in keys {
                    success = true
                    
                    let obj = snapshots[key] as? [String: Any]
                    
                    for name in roomlist {
                        
                    if  name == (obj?["RoomName"] as? String) {
                        
                        print(key)
                        print(name)
                        
                        if ( today == obj?["date"] as? String && currentTime == obj?["startTime"] as? String){
                            
                            print("\(name) room is already booked")
                            break
                        }
                        else {
                            print("room is free now")
                        }


                    
                }
                
            }
                }
            callback(success)
            }
        })
        
    }
 
    
    
    
}*/
