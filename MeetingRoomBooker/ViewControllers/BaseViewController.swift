
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
    func startActivityIndicator() {
        view.isUserInteractionEnabled = false
        spinner.center = self.view.center
        
        //hide when animating set to false
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.gray

        view.addSubview(spinner)
        view.bringSubview(toFront: spinner)
        spinner.startAnimating()
        
    }
    
    //To stopSpinner
    func stopActivityIndicator() {
        
        view.isUserInteractionEnabled = true
        spinner.stopAnimating()
        
    }
    
    //To give textfield border( To set bottom line of textfield)
    func textFieldBorder(textField : UITextField, color : UIColor, edge : CGFloat) {
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textField.frame.height  - 1, width: view.frame.size.width - edge, height: 1.15)
        bottomLine.backgroundColor = color.cgColor
        
        textField.borderStyle = UITextBorderStyle.none
        textField.layer.addSublayer(bottomLine)
        
    }
    
}
