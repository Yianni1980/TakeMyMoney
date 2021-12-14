//
//  PaymentWithCreditTableViewController.swift
//  TakeMyMoney
//
//  Created by ioannis giannakidis on 8/10/21.
//

import UIKit

class PaymentWithCreditVC: UITableViewController {

    @IBOutlet weak var creditCardLabel: UILabel!
    
    var creditCard = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        creditCardLabel.text = creditCard
        
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
