//
//  PhoneDropdownOption.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 28/7/25.
//

class PhoneDropdownOption: DropdownOption {
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
