//
//  DobRule.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 31/7/25.
//


public class DoBRule: Rule {
    var message: String = ""
    private let format: String
    private let minimumAge: Int

    public init(format: String, minimumAge: Int = 18) {
        self.format = format
        self.minimumAge = minimumAge
    }

    public func validate(_ value: String) -> Bool {
        if value.isEmpty { return true }

        guard let dob = value.toDate(format: format) else {
            message = AppMessage.Validation.DateOfBirthInvalidFormat
            return false
        }

        let calendar = Calendar.current
        let today = Date()

        if dob > today {
            message = AppMessage.Validation.DateOfBirthInFuture
            return false
        }

        let ageComponents = calendar.dateComponents([.year], from: dob, to: today)
        if let age = ageComponents.year, age >= minimumAge {
            return true
        } else {
            message = AppMessage.Validation.DateOfBirthTooYoung(minAge: minimumAge)
            return false
        }
    }

    public func errorMessage() -> String {
        return message
    }
}
