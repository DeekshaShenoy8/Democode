
import UIKit
import Firebase
import FirebaseDatabase

class CalandarTableViewController: BaseViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var bookMeetingRoom = BookMeetingRoom()
    
    var tagValue : Int = 0
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        prevButton.isEnabled = false
        
        formatDate()
        
        setColorToButton()
        
        setTitleToButton()
        
        fetchTodaysRoomBook(dateString: findDates(tag: button1.tag) )
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func formatDate() {
        Utility.dateFormatter.dateFormat = "MM/dd/yyyy"
        Utility.dateFormatter.dateStyle = .short
        Utility.dateFormatter.timeStyle = .none
    }
    
    //Set grey color for all button, highlight todays date
    func setColorToButton() {
        
        button4.backgroundColor = UIColor.gray
        button1.backgroundColor = UIColor(red: 81.0/255.0, green: 38.0/255.0, blue: 69.0/255.0, alpha: 1.0)
        button2.backgroundColor = UIColor.gray
        button3.backgroundColor = UIColor.gray
        
    }
    
    //Set button title (starting from todays date to next 7 days)
    func setTitleToButton() {
        
        button1.setTitle(findDates(tag: button1.tag), for: .normal)
        button2.setTitle(findDates(tag: button2.tag), for: .normal)
        button3.setTitle(findDates(tag: button3.tag), for: .normal)
        button4.setTitle(findDates(tag: button4.tag), for: .normal)
        
    }
    
    func findDates( tag : Int)-> String
    {
        
        return Utility.dateFormatter.string(from:Calendar.current.date(byAdding: .day, value: tag, to: Date())!)
        
    }
    
    //MARK : Fetch particular date Room Booking From firebase
    func fetchTodaysRoomBook(dateString: String) {
        
      //  startActivityIndicator()
        let userEmail = UserDefaults.standard.string(forKey: "userName")
        
        self.bookMeetingRoom.getBookedRoom(dateString: dateString, emailid : userEmail!, callback: { [weak self] (success, bookingid) in
            
        //    self?.stopActivityIndicator()
            
            if success {
                
                DispatchQueue.main.async(execute: {
                    
                    self?.tableView.reloadData()
                    
                })
                
            }
            
        })
        
    }
    
    @IBAction func onDatesButtonClickAction(_ sender: UIButton) {
        
        button4.backgroundColor = UIColor.gray
        button1.backgroundColor = UIColor.gray
        button2.backgroundColor = UIColor.gray
        button3.backgroundColor = UIColor.gray
        
        if let date = sender.title(for: .normal) {
            tableView.reloadData()
            fetchTodaysRoomBook(dateString: date)
            tagValue = sender.tag
        }
        
        sender.backgroundColor = UIColor(red: 81.0/255.0, green: 38.0/255.0, blue: 69.0/255.0, alpha: 1.0)
        
    }
    
    
    @IBAction func previousButtonClick(_ sender: Any) {
        
        fetchTodaysRoomBook(dateString:(findDates(tag:  tagValue)))
        
        button1.setTitle(findDates(tag: 0), for: .normal)
        button2.setTitle(findDates(tag: 1), for: .normal)
        button3.setTitle(findDates(tag: 2), for: .normal)
        button4.setTitle(findDates(tag: 3), for: .normal)
        prevButton.isEnabled = false
        nextButton.isEnabled = true
        
    }
    
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        fetchTodaysRoomBook(dateString:(findDates(tag: 4 + tagValue)))
        
        prevButton.isEnabled = true
        nextButton.isEnabled = false
        
        button1.setTitle(findDates(tag: 4), for: .normal)
        button2.setTitle(findDates(tag: 5), for: .normal)
        button3.setTitle(findDates(tag: 6), for: .normal)
        button4.setTitle(findDates(tag: 7), for: .normal)
        
    }
    
}

extension CalandarTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    //Number of rows in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bookMeetingRoom.roomDetails.count
        //return roomNameArray.count
    }
    
    
    //To display romname & time in row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "calandarCell", for: indexPath) as? CalanderTableViewCell
        // let timeString = timezone[indexPath.row]
        
        cell?.timeCellLabel.text = bookMeetingRoom.roomDetails[indexPath.row].startTime //startTimeArray[indexPath.row]
        cell?.roomNameLbel.text = bookMeetingRoom.roomDetails[indexPath.row].RoomName //roomNameArray[indexPath.row]
        cell?.durationLabel.text = bookMeetingRoom.roomDetails[indexPath.row].endTime //endTimeArray[indexPath.row]
        
        return cell!
        
    }
    
    
    //To set cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
        
    }
    
    
}

