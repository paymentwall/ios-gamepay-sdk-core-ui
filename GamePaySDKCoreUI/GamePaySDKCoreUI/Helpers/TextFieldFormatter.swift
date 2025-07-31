//
//  TextFieldFormatter.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 24/7/25.
//

public protocol TextFieldFormatter {
    func format(_ text: String) -> String
    var maxLength: Int { get }
    func unformatted(_ text: String) -> String
}

extension TextFieldFormatter {
    var maxLength: Int { 256 } 
    func format(_ text: String) -> String {
        return text
    }
    func unformatted(_ text: String) -> String { return text }
}
