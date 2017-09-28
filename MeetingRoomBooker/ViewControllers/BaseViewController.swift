//
//  BaseViewController.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 15/09/17.
//  Copyright © 2017 Deeksha Shenoy. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //start spinner(activity indicator)
    func startActivityIndicator(){
        view.isUserInteractionEnabled = false
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.gray
        spinner.frame = CGRect(x: 150, y: 300, width: 40.0, height: 40.0)
        view.addSubview(spinner)
        view.bringSubview(toFront: spinner)
        spinner.startAnimating()
    }
    
    //stopSpinner
    func stopActivityIndicator(){
        view.isUserInteractionEnabled = true
        spinner.stopAnimating()
    }
    
    //calayer, textfield border for buttom
    
    func textFieldBorder(textField : UITextField) {
        
    let bottomLine = CALayer()
    bottomLine.frame = CGRect(x: 0.0, y: textField.frame.height  - 1, width: textField.frame.width, height: 1.0)
    bottomLine.backgroundColor = UIColor.black.cgColor
    textField.borderStyle = UITextBorderStyle.none
    textField.layer.addSublayer(bottomLine)
        
    }
    

}
