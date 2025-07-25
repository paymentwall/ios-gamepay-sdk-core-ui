//
//  DropdownOption.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 25/7/25.
//

public struct DropdownOption: Codable {
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
