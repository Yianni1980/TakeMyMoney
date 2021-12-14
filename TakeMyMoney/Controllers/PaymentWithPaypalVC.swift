//
//  PaymentWithPaypalVC.swift
//  TakeMyMoney
//
//  Created by ioannis giannakidis on 8/10/21.
//

import UIKit

class PaymentWithPaypalVC: UITableViewController {
    
    
    @IBOutlet weak var paypalUsernameLabel: UILabel!
    
    var username = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        paypalUsernameLabel.text = username
    
    }

    @IBAction func payButtonPressed(_ sender: Any) {
     errorMessage() 
    }
    
    func errorMessage() {
        let alert = UIAlertController(title: "Error", message: "Your payment has failed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
