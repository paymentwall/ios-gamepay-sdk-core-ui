//
//  Required.swift
//  pyur-ios
//
//  Created by Jeff Potter on 12/22/14.
//  Copyright (c) 2015 jpotts18. All rights reserved.
//

import Foundation

/**
 `RequiredRule` is a subclass of Rule that defines how a required field is validated.
 */
open class RequiredRule: Rule {
    /// String that holds error message.
    private var message : String 
    
    /**
     Initializes `RequiredRule` object with error message. Used to validate a field that requires text.
     
     - parameter message: String of error message.
     - returns: An initialized `RequiredRule` object, or nil if an object could not be created for some reason that would not result in an exception.
     */
    public init(message: String = "This field is required"){
        if (message.elementsEqual("This field is required")) {
            self.message = "This field is required"
        }
        else {
            self.message = message
        }
    }
    
    /**
     Validates a field.
     
     - parameter value: String to check for validation.
     - returns: Boolean value. True if validation is successful; False if validation fails.
     */
    open func validate(_ value: String) -> Bool {
//        return !value.isEmpty
        return !value.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    /**
     Used to display error message when validation fails.
     
     - returns: String of error message.
     */
    open func errorMessage() -> String {
        return message
    }
}
