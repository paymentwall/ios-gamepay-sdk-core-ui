//
//  CustomCardNumberRule.swift
//  GamePaySDK
//
//  Created by Luke Nguyen on 12/6/25.
//

import Foundation

public class CustomCardNumberRule: Rule {
    let checkEmpty: Bool
    
    public init(checkEmpty: Bool = false) {
        self.checkEmpty = checkEmpty
    }
    
    public func validate(_ value: String) -> Bool {
        if value.isEmpty && !checkEmpty { return true }
        let number = value.components(separatedBy: " ").joined()

        if !number.isStringContainsOnlyNumbers() {
            return false
        }
        
        return checkCardNumberValidUsingLuhn(number)
    }
    
    private func checkCardNumberValidUsingLuhn(_ cardNumber: String) -> Bool {
        // Remove all non-digit characters (like spaces or dashes)
        let cardNumberDigits = cardNumber.filter { $0.isNumber }
        
        // Check if the card number is empty or has less than 2 digits
        if cardNumberDigits.count < 2 {
            return false
        }
        
        // Reverse the digits for Luhn algorithm calculation
        let reversedDigits = cardNumberDigits.reversed()
        
        var sum = 0
        for (index, char) in reversedDigits.enumerated() {
            guard let digit = char.wholeNumberValue else { return false }
            
            // If the index is odd (even position in the original number), double the digit
            if index % 2 == 1 {
                let doubled = digit * 2
                sum += doubled > 9 ? doubled - 9 : doubled
            } else {
                sum += digit
            }
        }
        
        // If the sum is divisible by 10, the card number is valid
        return sum % 10 == 0
    }
    
    public func errorMessage() -> String {
        return AppMessage.Validation.CardNumberInvalidFormat
    }
}
