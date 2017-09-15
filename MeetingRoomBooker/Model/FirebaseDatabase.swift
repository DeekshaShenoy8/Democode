//
//  FirebaseDatabase.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 13/09/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FirebaseDatabase: NSObject {
    typealias callback = ([String: AnyObject])->()
   var databaseReference : DatabaseReference?
  
    var roomlist = [MeetingRoom]()
        
    func fetchRoomsFromDatabase(entityName: String, complete : @escaping callback) {
          databaseReference = Database.database().reference()
        databaseReference?.child(entityName).observe(.value , with: { (snapshot) in
            print("entered block")
            if let roomsData = snapshot.value as? [String : AnyObject] {
           // print(roomsData)
            complete(roomsData)
            }
      
        })
        
    }
}
