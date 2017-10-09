//
//  Constants.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 06/10/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import Foundation

let canceltitle = "Ok"

struct LoginData {
    
}

struct CheckBoxValue {
    static let projector = "projector"
    static let wifi = "wifi"
    static let microphone = "microphone"
    static let laptop = "laptop"
}

struct FirebaseRoomData {
    static let entity = "rooms"
    static let roomName = "RoomName"
    static let capacity = "Capacity"
    static let facility = "facility"
}

struct FirebaseRoomBookingKey {
    static let entity = "RoomBooking"
    static let capacity = "Capacity"
    static let facility = "Facility"
    static let meetingDescription = "MeetingDescription"
    static let meetingTitle = "MeetingName"
    static let roomName = "RoomName"
    static let date = "date"
    static let email = "email"
    static let startTime = "startTime"
    static let endTime = "endTime"
}

struct NavigationTitle {
    static let addRoom = "Add Room"
    static let registration = "Registration"
    static let roomDetail = "Room Detail"
    static let rooms = "Rooms"
    static let profile = "Profile"
}

struct UserDefaultKey {
    static let userEmail = "userEmail"
    static let userPassword = "userPassword"
    static let isLoginPageIsThereInNavigationStack = "isLoginPageIsThereInNavigationStack"
}

struct EmptyFieldAlert {
    static let alertTitle = "PLEASE FILL ALL THE DETAIL"
    static let message = "Try again"
    static let cancelTile = "Ok"
}

struct InvalidPasswordOrEmailAlert {
    static let alertTitle = "Incorrect Email Or Password"
    static let message = "Try again"
    static let cancelTile = "Ok"
}

struct ErrorAlert {
    static let alertTitle = "Error found"
    static let cancelTitle = "Ok"
}

struct SuccessAlert {
    static let roomAdded = "Room Added Successfully"
    static let changesSaved = "Changes saved successfully"
    static let roomBooked = "Room Booked Successfully"
    static let registered = "Registered successfully"
    static let message = "Thank you"
    static let cancelTitle = "ok"
}

struct EventAlert {
    static let eventRemoved = "Event Removed From Calendar Successfully"
    static let noEventFound = "No events are found"
    static let notFoundMessage = "Event is not added"
    static let meetingOverAlertTitle = "Meeting is already over"
    static let meetingOverMessage = "You canot edit meeting now"
}

struct RoomBookingAlert {
    
    static let validStartAndEndTimeAlertTitle = "Enter valid start and end time"
    static let validStartAndEndTimeMessage = "Room is valid from 8am to 9pm"
    static let roomIsBookedAlertTitle = "Room is already booked"
    static let roomIsBookedMessage = "Try with other rooms"
    static let capacityExceededAlertTitle = "Entered capacity is more then Room capacity"
    static let capacityExceedMessage = "Try again"
    static let invalidTimeMessage = "Enter valid time and try again"
    
}
