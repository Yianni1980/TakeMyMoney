//
//  PaymentDataVCTableViewController.swift
//  TakeMyMoney
//
//  Created by ioannis giannakidis on 28/9/21.
//

import UIKit
enum PaymentRow:Int {
    case header = 0
    case creditCardPayment
    case payPalPayment
    case payButton
}
class PaymentDataVC: UITableViewController,UITextFieldDelegate {
    
    @IBOutlet weak var creditCardErrorLabel: UILabel!
    @IBOutlet weak var validUntilErrorLabel:UILabel!
    @IBOutlet weak var cardHolderErrorLabel:UILabel!
    @IBOutlet weak var paypalEmailErrorLabel:UILabel!
    @IBOutlet weak var paypalPasswordErrorLabel:UILabel!
    @IBOutlet weak var cvvErrorLabel:UILabel!
    @IBOutlet weak var paypalButton:UIButton!
    @IBOutlet weak var creditButton:UIButton!
    @IBOutlet weak var walletButton:UIButton!
    @IBOutlet weak var creditCardTextField:UITextField!
    @IBOutlet weak var validCreditCardDateText:UITextField!
    @IBOutlet weak var cvvTextField:UITextField!
    @IBOutlet weak var cardHolderTextField:UITextField!
    @IBOutlet weak var paypalEmailTextField:UITextField!
    @IBOutlet weak var paypalPasswordTextField:UITextField!
    
    let validUntilDateTimePicker = UIDatePicker()
    let fullnameValidity:String.ValidityType = .fullname
    var paypalMethodSelected = false
    {
        didSet {
            tableView.reloadData()
        }
    }
    var creditMethodSelected = true
    {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        paypalButton.alpha = 0.50
        
        creditButton.alpha = 1
        
        walletButton.alpha = 0.50
        
        creditCardTextField.delegate = self
        
        cvvTextField.delegate = self
        
        cardHolderTextField.delegate = self
        
        validUntilDateTime()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let row = PaymentRow(rawValue: indexPath.row) else {return 0}
        switch row {
        case .header:
            return 256
            
        case .creditCardPayment:
            if creditMethodSelected {
                return 350
            }else {
                return 0.0
            }
        case .payPalPayment:
            
            if paypalMethodSelected {
                return 198
            }else {
                return 0.0
            }
        case .payButton:
            return 80
            
        }
        
        
    }
    
    
    
    @IBAction func paypalButtonPressed(_ sender: Any) {
        
        highlight(selected: 1)
        
        paypalMethodSelected = true
        
        creditMethodSelected = false
    }
    
    
    @IBAction func creditButtonPressed(_ sender: Any) {
        
        highlight(selected: 2)
        
        paypalMethodSelected = false
        
        creditMethodSelected = true
    }
    
    func highlight(selected:Int) {
        
        switch selected {
        case 1:
            
            paypalButton.alpha = 1
            
            creditButton.alpha = 0.50
            
            walletButton.alpha = 0.50
            
        case 2:
            
            creditButton.alpha = 1
            
            paypalButton.alpha = 0.50
            
            walletButton.alpha = 0.50
        default:
            break
        }
    }
    
    func hideNumbers(number: String,forCreditCard:Bool) -> String {
        
        let trimmedString = number.components(separatedBy: .whitespaces).joined()
        
        let arrOfCharacters = Array(trimmedString)
        
        var result = ""
        
        
        if forCreditCard {
            arrOfCharacters.enumerated().forEach { (index, character) in
                
                if index % 4 == 0 && index > 0 {
                    
                    result += " "
                }
                if index < 12 {
                    
                    result += "*"
                    
                } else {
                    
                    result.append(character)
                }
            }
        }else{
            for  _ in arrOfCharacters{
                
                result += "*"
            }
        }
        return result
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string:  String) -> Bool {
        
        var result = false
        
        var maxLenght = 0
        
        switch textField {
            
        case creditCardTextField,cvvTextField:
            
            let allowedCharacters = "1234567890"
            
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            
            let typedCharacterSet = CharacterSet(charactersIn: string)
            
            if textField == creditCardTextField {
                
                maxLenght = 19
            }else{
                maxLenght = 3
            }
            let updatedString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            result = allowedCharacterSet.isSuperset(of: typedCharacterSet) && updatedString.count <= maxLenght
            
        case cardHolderTextField:
            let allowedCharacters = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            result = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            
        default:
            break
        }
        
        return result
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
    }
    
    @IBAction func creditCardTextFieldTextChanged(_ sender: Any)
    {
        creditCardTextField.text  = hideNumbers(number: creditCardTextField.text!,forCreditCard: true)
    }
    
    
    @IBAction func cvvTextFieldTextChanged(_ sender: Any) {
        
        cvvTextField.text = hideNumbers(number: cvvTextField.text!, forCreditCard: false)
    }
    
    @IBAction func proceedToConfirmButtonPressed(_ sender: Any) {
        
        if checkErrors() {
            
            errorMessage()
            
        }else {
            if creditMethodSelected{
                
                performSegue(withIdentifier: "creditCardPayment", sender: nil)
                
            } else {
                
                performSegue(withIdentifier: "paypalPayment", sender: nil)
                
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier ==  "creditCardPayment" {
            
            let paymentWithCreditVC = segue.destination as! PaymentWithCreditVC
            
            let creditcard = creditCardTextField.text
            
            paymentWithCreditVC.creditCard = creditcard!
            
        }else if segue.identifier == "paypalPayment" {
            
            let paymentwithPaypalVC = segue.destination as! PaymentWithPaypalVC
            
            let username = paypalEmailTextField.text
            
            paymentwithPaypalVC.username = username!
            
        }
        
    }
    
    func creatToolbar() ->UIToolbar {
        
        let toolbar = UIToolbar()
        
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        
        toolbar.setItems([doneBtn], animated: true)
        
        return toolbar
    }
    
    func validUntilDateTime() {
        
        validUntilDateTimePicker.preferredDatePickerStyle = .wheels
        
        validUntilDateTimePicker.datePickerMode = .date
        
        validUntilDateTimePicker.minimumDate = validUntilDateTimePicker.date.addingTimeInterval(86400)
        
        validCreditCardDateText.inputView = validUntilDateTimePicker
        
        validCreditCardDateText.inputAccessoryView = creatToolbar()
        
        
        
    }
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    @objc func donePressed() {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM/yyyy"
        
        validCreditCardDateText.text = dateFormatter.string(from: validUntilDateTimePicker.date)
        
        self.view.endEditing(true)
        
    }
    
    func checkErrors()->Bool {
        
        var errorMessageAppear = false
        if creditMethodSelected{
            
            
            if creditCardTextField.text == "" {
                
                showErrorLabel(textfield: creditCardTextField, errorLabel: creditCardErrorLabel, text: "Credit Card not set")
                
                errorMessageAppear = true
                
            }else if creditCardTextField.text!.count < 19 {
                
                showErrorLabel(textfield: creditCardTextField, errorLabel: creditCardErrorLabel, text: " Invalid Credit Card")
                
                errorMessageAppear = true
                
            }
            
            if validCreditCardDateText.text == "" {
                
                showErrorLabel(textfield: validCreditCardDateText, errorLabel: validUntilErrorLabel, text: "Valid until not set")
                
                errorMessageAppear = true
                
            }
            if cvvTextField.text == "" {
                
                showErrorLabel(textfield: cvvTextField, errorLabel: cvvErrorLabel, text: "CVV field empty")
                
                errorMessageAppear = true
                
            }else if cvvTextField.text!.count < 3 {
                
                showErrorLabel(textfield: cvvTextField, errorLabel: cvvErrorLabel, text: "CVV field must  be three digits")
                
                errorMessageAppear = true
                
                
            }
            
            if !checkText(textField: cardHolderTextField, validity: .fullname) {
                
                showErrorLabel(textfield: cardHolderTextField, errorLabel: cardHolderErrorLabel, text: "Card holder name not set correclty ")
                
                errorMessageAppear = true
            }
            
        }else {
            
            if !checkText(textField: paypalEmailTextField, validity: .email){
                
                showErrorLabel(textfield: paypalEmailTextField, errorLabel: paypalEmailErrorLabel, text: "username hasn't been set propertly")
                
                errorMessageAppear = true
            }
            
            if !checkText(textField: paypalPasswordTextField, validity: .password) {
                
                showErrorLabel(textfield: paypalPasswordTextField, errorLabel: paypalPasswordErrorLabel, text: "password hasn't been set propertly")
                
                errorMessageAppear = true
                
            }
            
        }
        return errorMessageAppear
        
    }
    
    func errorMessage() {
        
        let alert = UIAlertController(title: "Error", message: "There were some errors on your form", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.restoreTextfields()
            
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorLabel(textfield:UITextField,errorLabel:UILabel,text:String){
        
        let errorColor = UIColor.red
        
        textfield.layer.borderWidth = 0.5
        
        textfield.layer.borderColor =  errorColor.cgColor
        
        errorLabel.isHidden = false
        
        errorLabel.textColor = .red
        
        errorLabel.text = text
    }
    
    func restoreTextfields() {
        
        var allTextFields = [UITextField]()
        
        var allErrorLabels = [UILabel]()
        
        if creditMethodSelected{
            
            allTextFields = [creditCardTextField,validCreditCardDateText,cvvTextField,cardHolderTextField]
            
            allErrorLabels = [creditCardErrorLabel,validUntilErrorLabel,cvvErrorLabel,cardHolderErrorLabel]
            
        } else {
            
            allTextFields = [paypalEmailTextField,paypalPasswordTextField]
            
            allErrorLabels = [paypalEmailErrorLabel,paypalPasswordErrorLabel]
            
        }
        
        allTextFields.forEach { textfield in
            
            textfield.layer.borderWidth = 0
        }
        allErrorLabels.forEach { label in
            
            label.isHidden = true}
    }
    
    func checkText(textField:UITextField,validity:String.ValidityType) -> Bool{
        
        var check = false
        
        if let text = textField.text  {
            
            if text.isValid(validity){
                
                check = true
                
            }
        }
        return check
    }
}


