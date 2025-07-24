//
//  GamePayAppMessage.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 24/7/25.
//

public enum AppMessage {
    public enum Validation {
        public static let EmailEmpty = "Your email is empty."
        
        public static let CardNumberEmpty = "Your card numbers is empty."
        public static let CardNumberInvalidFormat = "Your card numbers is invalid."
        
        public static let CardHolderNameEmpty = "Your card holder name is empty."
        public static let CardHolderNameInvalid = "Your card holder name is invalid."
        
        public static let ExpityDateEmpty = "Your expiration date is empty."
        public static let ExpiryDateInvalidFormat = "Your expiration date is invalid."
        public static let ExpiryDateExpired = "Your expiration date is invalid."
        
        public static let CVVEmpty = "Your CVV is empty"
        public static let CVVInvalidFormat = "Your CVV is empty or invalid"
    }
}
