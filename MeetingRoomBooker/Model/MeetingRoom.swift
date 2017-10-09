
import UIKit
import FirebaseDatabase
import Firebase

struct  RoomsDetail {
    var RoomName : String = ""
    var Capacity : String = ""
    var facility = [String]()
}

class MeetingRoom: NSObject {
    
    var roomdetail = RoomsDetail()
    var roomdetails = [RoomsDetail]()
    var databaseReference : DatabaseReference?
    
    //Store rooms into Firebase
    func loadRoomsToFirebaseDatabase(complete : () -> ()) {
        
        print(roomdetail.RoomName)
        databaseReference = Database.database().reference()
        
        databaseReference?.child("rooms").child(roomdetail.RoomName).setValue([FirebaseRoomData.roomName: roomdetail.RoomName, FirebaseRoomData.capacity: roomdetail.Capacity, FirebaseRoomData.facility : roomdetail.facility])
        complete()
        
    }
    
    
    //Fetch rooms from firebase database
    func fetchRoomsFromDatabase(entityName: String, complete : @escaping (Bool)->()) {
        
        var success = false
        databaseReference = Database.database().reference()
        databaseReference?.child(entityName).observe(.value, with: { (snapshot) in
            
            if let snapshots = snapshot.value as? [String: Any] {
                let keys = snapshots.keys
                for key in keys {
                    let obj = snapshots[key] as? [String: Any]
                    if let name = (obj?["RoomName"] as? String), let capacity = (obj?["Capacity"] as? String) {
                        self.roomdetail.RoomName = name
                        self.roomdetail.Capacity = capacity
                        self.roomdetail.facility = obj?["facility"] as! [String]
                        self.roomdetails.append(self.roomdetail)
                    }
                    success = true
                }
            }
            complete(success)
        })
    }
}

