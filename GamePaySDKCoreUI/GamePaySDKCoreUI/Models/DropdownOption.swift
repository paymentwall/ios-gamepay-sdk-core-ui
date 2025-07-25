//
//  DropdownOption.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//

public class DropdownOption: Codable {
    let value: String
    let name: String
    let logoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case value
        case name
        case logoUrl = "logo"
    }
    
    public init(value: String, name: String, logoUrl: String? = nil) {
        self.value = value
        self.name = name
        self.logoUrl = logoUrl
    }
}

class DropdownPhoneOption: DropdownOption {
    let phoneCode: UInt64?
    var flag: String?

    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    public init?(for countryCode: String, with phoneNumberKit: PhoneNumberKit) {
        guard
            let name = (Locale.current as NSLocale).localizedString(forCountryCode: countryCode),
            let flag = countryCode.getFlagScalar() else {
            return nil
        }

        self.phoneCode = phoneNumberKit.countryCode(for: countryCode)
        self.flag = flag
        super.init(value: countryCode, name: name)
    }
}
