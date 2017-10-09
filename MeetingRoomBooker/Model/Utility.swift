//
//  Utility.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 13/09/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import UIKit

class Utility: NSObject {
          static let dateFormatter = DateFormatter()
}

extension UIViewController {
    
    //Alert controller function
    func addAlert(title:String, message:String, cancelTitle:String ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //Hide key board on tap gestyre recognization
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    //Alert and pop to VC
    func alertController(title:String, message:String, cancelTitles:[String], actions : [(UIAlertAction) -> ()]) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        for (index,title) in cancelTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alertController.addAction(action)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}



