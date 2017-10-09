
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
        var bookingid = [String]()
        self.roomDetails = []

        databaseReference = Database.database().reference()
        if let query = databaseReference?.child(FirebaseRoomBookingKey.entity).queryOrdered(byChild: FirebaseRoomBookingKey.date).queryEqual(toValue: dateString){
            
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.value as? [String: Any] {
                    let keys = snapshots.keys
                   
                    for key in keys {
                        if let dictionary = snapshots[key] as? [String: AnyObject] {
                            if let name = (dictionary[FirebaseRoomBookingKey.roomName] as? String), let startTime = (dictionary[FirebaseRoomBookingKey.startTime] as? String), let endTime = (dictionary[FirebaseRoomBookingKey.endTime] as? String) ,let email = (dictionary[FirebaseRoomBookingKey.email] as? String), let meetingName =  (dictionary[FirebaseRoomBookingKey.meetingTitle] as? String) {
                                
                                var roomDetail = MeetingRoomDetail()
                                success = true
                                roomDetail.RoomName = name
                                roomDetail.startTime = startTime
                                roomDetail.endTime = endTime
                                roomDetail.email = email
                                roomDetail.MeetingName = meetingName
                                
                                if( emailid == email) {
                                bookingid.append(key)
                                }
                                self.roomDetails.append(roomDetail)
                               
                            }
                        }
                }
                callback(success,bookingid)
                }
            })
        }
        
    }

}
