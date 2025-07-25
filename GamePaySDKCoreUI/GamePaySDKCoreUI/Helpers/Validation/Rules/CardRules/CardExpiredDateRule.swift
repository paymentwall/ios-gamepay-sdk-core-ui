//
//  CardExpiredDateRule.swift
//  GamePaySDK
//
//  Created by Luke Nguyen on 12/6/25.
//

import Foundation

public class CardExpiredDateRule: Rule {
    var message: String = ""
    
    public init() { }
    
    public func validate(_ value: String) -> Bool {
        if value.isEmpty { return true } // consider empty is true, add required rule if needed
        guard let expiredDate = value.toDate(format: "MM/yy") else {
            message = AppMessage.Validation.ExpiryDateInvalidFormat
            return false
        }
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        
        let enteredYear = expiredDate.get(.year)
        let enteredMonth = expiredDate.get(.month)
        
        if enteredYear == currentYear,
           enteredMonth >= currentMonth {
            return true
        }
        else if enteredYear > currentYear {
            if (1 ... 12).contains(enteredMonth) {
                return true
            } else {
                message = AppMessage.Validation.ExpiryDateInvalidFormat
                return false
            }
        } else {
            message = AppMessage.Validation.ExpiryDateExpired
            return false
        }
    }
    
    public func errorMessage() -> String {
        return message
    }
}
