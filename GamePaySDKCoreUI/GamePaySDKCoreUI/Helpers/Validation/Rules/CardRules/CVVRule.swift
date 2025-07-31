//
//  CVVRule.swift
//  GamePaySDK
//
//  Created by Luke Nguyen on 12/6/25.
//


public class CVVRule: Rule {
    let checkEmpty: Bool
    
    public init(checkEmpty: Bool = false) {
        self.checkEmpty = checkEmpty
    }
    
    public func validate(_ value: String) -> Bool {
        if value.isEmpty && !checkEmpty { return true }
        if !value.isStringContainsOnlyNumbers() {
            return false
        }
        
        // CVV has to be 3 or 4 digits
        return (value.count == 3) || (value.count == 4)

    }
    
    public func errorMessage() -> String {
//        return "Please enter valid CVV number"
        return AppMessage.Validation.CVVInvalidFormat
    }
}
