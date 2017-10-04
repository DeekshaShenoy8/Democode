
import UIKit

class BaseViewController: UIViewController {
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //start spinner(activity indicator)
    func startActivityIndicator(){
        view.isUserInteractionEnabled = false
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.gray
       // spinner.frame = CGRect(x: 150, y: 300, width: 40.0, height: 40.0)
        view.addSubview(spinner)
        view.bringSubview(toFront: spinner)
        spinner.startAnimating()
    }
    
    //stopSpinner
    func stopActivityIndicator(){
        view.isUserInteractionEnabled = true
        spinner.stopAnimating()
    }
    
    
    //calayer, textfield border
    func textFieldBorder(textField : UITextField, color : UIColor, edge : CGFloat) {
        
    let bottomLine = CALayer()
    bottomLine.frame = CGRect(x: 0.0, y: textField.frame.height  - 1, width: view.frame.size.width - edge, height: 1.15)
        print("border y\(textField.frame.width)")
    bottomLine.backgroundColor = color.cgColor
    textField.borderStyle = UITextBorderStyle.none
    textField.layer.addSublayer(bottomLine)
        
    }
    

}
