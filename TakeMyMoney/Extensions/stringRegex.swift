//
//  stringRegex.swift
//  TakeMyMoney
//
//  Created by ioannis giannakidis on 9/10/21.
//

import Foundation
extension String {
    
    enum ValidityType {
        case email
        case password
        case fullname
        
        var regex:String {
            switch self {
            case .email : return "[A-Z0-9a-z._%t-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,64}"
            case .password : return "^(?=.*[a-z])(?=.*[A-Z])(?=.*[$@@!%*?&#])[A-Za-z\\d$@$!%*?&#]{6,25}"
            case .fullname: return  "[A-Za-z]+[:space:]+[A-Za-z]{1,64}"
            }
        }
    }
    func isValid(_ validityType: ValidityType) -> Bool {
        let format = "SELF MATCHES %@"
        return NSPredicate(format: format, validityType.regex).evaluate(with: self)

    }
}
